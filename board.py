from particle import Particle
from simulation_cfg import SimulationCfg
import numpy as np
import random
import utils
from target import Target
from typing import List, Union, Tuple
from exceptions import TooManyParticlesError


class Board:
    cfg: SimulationCfg
    particles: List[Particle]
    grid: np.ndarray
    targets: List[Target]

    def __init__(self, cfg, output_file, start_at_target=False):
        self.output_file = output_file
        self.cfg = cfg
        self.targets = self.initialize_targets()
        self.particles = [Particle(i, random.randrange(0, len(self.targets))) for i in range(cfg.num_of_particles)]
        self.grid = self.initialize_grid(cfg.length, cfg.num_of_particles, start_at_target)
        self.adjacency_matrix = self.initizalize_adjacency_matrix()
        self.hitting_times = [-1] * len(self.targets)
        self.current_target = -1
        self.time_in_target = -1
        self.time_in_targets = 0

    def initialize_grid(self, length: int, num_of_particles: int, start_at_target):
        """
        Initializes grid.
        Gets list of particles, and randomly populates them in the grid.
        Returns the grid.
        """
        grid = np.full((length, length), -1, int)  # Particle slots, -1 represents no particle
        coordinates = [(i, j) for i in range(length) for j in range(length)]  # Coordinates set

        if start_at_target is False:
            random.shuffle(coordinates)
        else:
            self.set_particles_at_target(coordinates, start_at_target)

        for i in range(num_of_particles):
            x, y = coordinates[i]
            grid[x][y] = i
            self.particles[i].x, self.particles[i].y = x, y
        return grid

    def initialize_targets(self) -> List[Target]:
        """
        Returns list of randomly built targets
        """
        targets = []
        id = 0
        for config in self.cfg.targets_cfg:
            for i in range(config.num_of_instances):
                targets.append(Target(id,
                                      self.cfg.num_of_particles,
                                      config.weak_interaction,
                                      config.strong_interaction,
                                      config.local_drive))
                id += 1
        return targets

    def initizalize_adjacency_matrix(self):
        adjacency_matrix = np.zeros((self.cfg.num_of_particles, self.cfg.num_of_particles), tuple)

        for x in range(self.cfg.length):
            for y in range(self.cfg.length):
                if -1 == self.grid[x][y]: #if no particle there.
                    continue
                neighbors = utils.get_neighboring_elements(self.grid, (x, y), self.cfg.is_cyclic)
                for direction, element in neighbors.items():
                    adjacency_matrix[self.grid[x][y]][element] = str((self.particles[self.grid[x][y]].inner_state,
                                                                  self.particles[element].inner_state))
                adjacency_matrix[self.grid[x][y]][self.grid[x][y]] = str((self.particles[self.grid[x][y]].inner_state,
                                                                         self.particles[self.grid[x][y]].inner_state))

        return adjacency_matrix

    def calculate_particle_energy(self, particle: Particle) -> Union[int, float]:
        """
        Gets particle id, returns the current energy the particle adds to the system
        (energy with it being there vs. no particle being there).
        """
        p_target = self.targets[particle.inner_state]
        energy = 0
        for direction, neighbor_id in utils.get_neighboring_elements(self.grid, particle.get_coordinates()).items():
            n_target = self.targets[self.particles[neighbor_id].inner_state]
            energy += 0.5 * (p_target.get_energy(particle.id, neighbor_id) +
                             n_target.get_energy(particle.id, neighbor_id))

        return energy

    def turn(self, turn_num, turn_callback):
        particle = random.choice(self.particles)
        self.physical_move(particle)
        particle = random.choice(self.particles)
        self.state_change(particle)

        # TODO: Save data - energy, entropy, assembly times, etc.
        return turn_callback(self, turn_num)

    def run_simulation(self, num_of_turns, turn_callback):
        for i in range(1, num_of_turns + 1):
            if not self.turn(i, turn_callback):
                #if the callback says we should stop
                break

        self.output_file.write("time in target: {}\n".format(self.time_in_targets))
        print("time in target: {}\n".format(self.time_in_targets))

    def physical_move(self, particle: Particle) -> None:
        """
        Gets particle, and attempting to make a physical move according to
        energy difference metropolis query.
        """
        direction = random.choice(list(utils.neighbor_directions.keys()))
        direction_delta = utils.neighbor_directions[direction]
        new_coordinates = utils.add_coordinates(particle.get_coordinates(),
                                                direction_delta,
                                                self.cfg.length,
                                                self.cfg.is_cyclic
                                                )

        if not self.is_move_allowed(new_coordinates):
            return

        old_energy = self.calculate_particle_energy(particle)
        old_coordinates = particle.get_coordinates()

        # move particle and recalculate energy
        self.do_move_particle(particle, new_coordinates)
        new_energy = self.calculate_particle_energy(particle)
        new_neighbors = utils.get_neighboring_elements(self.grid, new_coordinates, self.cfg.is_cyclic)
        # if the move is accepted, we keep it
        if utils.metropolis(-(new_energy - old_energy)):
            # update adjacency matrix
            self.adjacency_matrix[:][particle.id] = self.adjacency_matrix[particle.id][:] = 0
            self.adjacency_matrix[particle.id][particle.id] = str((particle.inner_state, particle.inner_state))
            for n in new_neighbors.values():
                self.adjacency_matrix[particle.id][n] = str((particle.inner_state, self.particles[n].inner_state))
            return

        # if the move is rejected, we revert it
        self.do_move_particle(particle, old_coordinates)
        return

    def is_move_allowed(self, new_coordinates: Tuple[int]) -> bool:
        """
        Gets particle and movement direction (up/down/left/right) and cyclicity, and decides
        if the move is allowed (bounds & occupation considerations).
        """
        if utils.is_coordinates_in_bounds(new_coordinates, self.cfg.length, self.cfg.length):
            return -1 == self.grid[new_coordinates[0]][new_coordinates[1]]

        return False

    def state_change(self, particle: Particle) -> None:
        """
        Handles the inner state change attempt of a particle.
        """
        old_energy = self.calculate_particle_energy(particle)
        original_state = particle.inner_state

        # pick a new state and calc energy in new state
        new_state = random.randrange(0, len(self.targets))
        particle.inner_state = new_state
        new_energy = self.calculate_particle_energy(particle)

        # calculate local drive
        neighbors = utils.get_neighboring_elements(self.grid, particle.get_coordinates(), self.cfg.is_cyclic)
        num_of_neighbors_in_original_state = len([n for n in neighbors.values()
                                                  if self.particles[n].inner_state == original_state])
        num_of_neighbors_in_new_state = len([n for n in neighbors.values()
                                             if self.particles[n].inner_state == new_state])
        local_drive = 0

        if num_of_neighbors_in_original_state >= 2:
            local_drive -= self.targets[original_state].local_drive
        if num_of_neighbors_in_new_state >= 2:
            local_drive += self.targets[new_state].local_drive

        # Check change probabilty and edit adjacency_matrix.
        if utils.metropolis(-(new_energy - old_energy) + local_drive):
            for n in neighbors.values():
                self.adjacency_matrix[particle.id][n] = str((new_state, self.particles[n].inner_state))
            self.adjacency_matrix[particle.id][particle.id] = str((new_state, new_state))
            return

        # if change rejected, revert state
        particle.inner_state = original_state
        return

    def do_move_particle(self, particle, destination_coordinates):
        self.grid[particle.x][particle.y] = -1  # no particle
        self.grid[destination_coordinates[0]][destination_coordinates[1]] = particle.id  # move particle on grid
        particle.x, particle.y = destination_coordinates[0], destination_coordinates[1]  # update particle coordinates


    def calc_distance_from_targets(self):
        distances = []
        for i in self.targets:
            matching_adjacnet = np.logical_and(self.adjacency_matrix == str((i.id, i.id)), i.adjacency_matrix == 1)
            matching_vacancy = np.logical_and(self.adjacency_matrix == 0, i.adjacency_matrix == 0)
            b = ~np.logical_or(matching_adjacnet, matching_vacancy)
            distances.append(np.count_nonzero(~np.logical_or(matching_adjacnet, matching_vacancy)))

        return distances

    def set_particles_at_target(self, coordinates, target_num):
        target_grid = self.targets[target_num].particles_grid
        particles_array_length = int(self.cfg.num_of_particles ** 0.5)

        for i in range(particles_array_length):
            for j in range(particles_array_length):
                coordinates[target_grid[i][j]] = (i, j)



