from particle import Particle  # A class defined for each particle.
from simulation_cfg import SimulationCfg
import numpy as np
import random
import utils
import math

# Self defined functions.
from target import Target

# The target is created in the load configuration.
from typing import List, Union, Tuple

# What the function except to get (integer etc), would output error but continue if not included.
from exceptions import TooManyParticlesError

# Self defined exception, If more particles than board.


class Board:
    entropy: int
    cfg: SimulationCfg
    particles: List[Particle]
    # Vector of particles. This contains informations about the grid as well, and where the particle number on the grid.
    grid: np.ndarray
    # Array of dimenon n is created
    targets: List[Target]

    def __init__(self, cfg, output_file, start_at_target=False):
        # This is a function of the board. Each indented function is part of the class.
        self.output_file = output_file
        self.cfg = cfg
        self.adjacency_matrix_encoding_factor = 10 ** (math.floor(math.log10(self.get_num_of_targets())) + 1)
        self.targets = self.initialize_targets()
        self.particles = self.initialize_particles_list(start_at_target)
        self.grid = self.initialize_grid(
            cfg.length, cfg.num_of_particles, start_at_target
        )
        self.adjacency_matrix = self.initizalize_adjacency_matrix(self.adjacency_matrix_encoding_factor)
        self.current_target = -1
        self.time_in_target = -1
        self.entropy_add = 0

    # Each object in Python has self.attribute (same as field). In the class all is intetned.
    # This is from object oriented. Self inside the object is to say act on me. Each
    def initialize_grid(self, length: int, num_of_particles: int, start_at_target):
        """
        Initializes grid.
        Gets list of particles, and randomly populates them in the grid.
        Not necessraly random for start at target if given start a traget NUMBER.
        Returns the grid.
        """
        grid = np.full(
            (length, length), -1, int
        )  # Particle slots, -1 represents no particle, intialzation of grid with -1, no particle definition.
        coordinates = [
            (i, j) for i in range(length) for j in range(length)
        ]  # Coordinates set, prepares list of coordinates.

        if start_at_target is False:
            random.shuffle(coordinates)
        # Shuffle the coordinates.
        else:
            self.set_particles_at_target(coordinates, start_at_target)

        for i in range(num_of_particles):
            x, y = coordinates[i]
            grid[x][y] = i
            self.particles[i].x, self.particles[i].y = x, y
        return grid

    def get_num_of_targets(self):
        num_of_targets = 0
        for config in self.cfg.targets_cfg:
            for i in range(config.num_of_instances):
                num_of_targets += 1
        return num_of_targets

    def initialize_particles_list(self, start_at_target):
        if start_at_target is False:
            return [
                Particle(i, random.randrange(0, len(self.targets)))
                for i in range(self.cfg.num_of_particles)
            ]

        return [Particle(i, start_at_target) for i in range(self.cfg.num_of_particles)]

    def initialize_targets(self) -> List[Target]:
        """
        Returns list of randomly built targets
        """
        targets = []
        id = 0
        for config in self.cfg.targets_cfg:
            for i in range(config.num_of_instances):
                targets.append(
                    Target(
                        id,
                        self.cfg.num_of_particles,
                        config.weak_interaction,
                        config.strong_interaction,
                        config.local_drive,
                        self.adjacency_matrix_encoding_factor
                    )
                )
                id += 1
        return targets

    def initizalize_adjacency_matrix(self, encoding_factor):
        adjacency_matrix = np.zeros(
            (self.cfg.num_of_particles, self.cfg.num_of_particles), int
        )
        adjacency_matrix[:] = -1
        # The default for no particle neighbour is -1
        for x in range(self.cfg.length):
            for y in range(self.cfg.length):
                if -1 == self.grid[x][y]:  # if no particle there.
                    continue
                neighbors = utils.get_neighboring_elements(
                    self.grid, (x, y), self.cfg.is_cyclic
                )
                # boubdary conditions is defined in the grid configuration file. returns hashmap\dictionary.
                for direction, element in neighbors.items():
                    adjacency_matrix[self.grid[x][y]][element] = (
                        encoding_factor * self.particles[self.grid[x][y]].inner_state
                        + self.particles[element].inner_state
                    )
                adjacency_matrix[self.grid[x][y]][self.grid[x][y]] = (
                    encoding_factor * self.particles[self.grid[x][y]].inner_state
                    + self.particles[self.grid[x][y]].inner_state
                )
                # direction and element is extracting the matrix index in a location one by one and put it in the adjaency matrix.
        return adjacency_matrix

    def calculate_particle_energy(self, particle: Particle) -> Union[int, float]:
        """
        Gets particle id, returns the current energy the particle adds to the system
        (energy with it being there vs. no particle being there).
        """
        p_target = self.targets[particle.inner_state]
        energy = 0
        for direction, neighbor_id in utils.get_neighboring_elements(
            self.grid, particle.get_coordinates()
        ).items():
            n_target = self.targets[self.particles[neighbor_id].inner_state]
            energy += 0.5 * (
                p_target.get_energy(particle.id, neighbor_id)
                + n_target.get_energy(particle.id, neighbor_id)
            )

        return energy

    def turn(self, turn_num, turn_callback):
        particle = random.choice(self.particles)
        # Return a random choice from the list
        self.physical_move(particle)
        # Try physical move with Metropolis condition
        particle = random.choice(self.particles)
        # Chose another random particle
        self.state_change(particle)
        # Choose each one in random.
        # Add entropy.
        # Gets accsess to the board, and what turn number are we in.
        return turn_callback(self, turn_num)

    def run_simulation(self, max_num_of_turns, turn_callback, run_index, entropy_vec):
        self.distance_vec = np.zeros(max_num_of_turns)
        distances = [self.cfg.num_of_particles ** 2]  # distance from targets along realization. bins of 5000-mean.
        for turn_num in range(max_num_of_turns):
            if not self.turn(turn_num, turn_callback):
                # if the callback says we should stop
                entropy_vec[turn_num] = self.entropy_add
                #distance_vec[turn_num] = min(self.calc_distance_from_targets())
                return entropy_vec
                # break

            #self.output_file.write("time in target: {}\n".format(self.time_in_targets))
            #print("time in target: {}\n".format(self.time_in_targets))
            #self.output_file.write("tfas: {}\n".format(turn_num))
            #self.output_file.write("minimum distance bin: {}\n".format(min(distances)))
            #print("tfas: {}\n".format(turn_num))
            #print("minimum distance bin: {}\n".format(min(distances)))
            #utils.save_distance_figure(f"j{self.targets[0].strong_interaction}r{run_index} distances_graph", distances)
           # distance_vec[turn_num] = min(self.calc_distance_from_targets())
            entropy_vec[turn_num] = self.entropy_add

        turn_callback(self, turn_num, finished=True)

    def physical_move(self, particle: Particle) -> None:
        """
        Gets particle, and attempting to make a physical move according to
        energy difference metropolis query.
        """
        direction = random.choice(list(utils.neighbor_directions.keys()))
        # Take all possible directions. neighbor_directions are the dictionary,. Dictionary.keys, are turning into list. and then random takes 1 of the 4 options randomly). Value is the delta.
        direction_delta = utils.neighbor_directions[direction]
        # Direction is from the dictionary the way a praticle will go next step (up, bottom etc)
        # plus B.C. such as 2D grid.
        new_coordinates = utils.add_coordinates(
            particle.get_coordinates(),
            direction_delta,
            self.cfg.length,
            self.cfg.is_cyclic,
        )
        # This was chosen instead of just adding delta due to boundary conditions.
        if not self.is_move_allowed(new_coordinates):
            return
        old_energy = self.calculate_particle_energy(particle)
        # All the energy of the particle contribution to total energy.
        old_coordinates = particle.get_coordinates()

        # move particle and recalculate energy
        self.do_move_particle(particle, new_coordinates)
        new_energy = self.calculate_particle_energy(particle)
        # New energy after particle motion.
        new_neighbors = utils.get_neighboring_elements(
            self.grid, new_coordinates, self.cfg.is_cyclic
        )
        # Here we take all the new neihbours ot he particle. if the move is accepted, we keep it, and zero the neihgbors.
        kenb = utils.metropolis(-(new_energy - old_energy))
        if utils.metropolis(-(new_energy - old_energy)):
            # add entropy of step
            self.entropy_add = math.log(
                (
                    utils.metropolis_part_1(-(new_energy - old_energy))
                    / utils.metropolis_part_1((new_energy - old_energy))
                )
            )

            # update adjacency matrix
            self.adjacency_matrix[:, particle.id] = -1
            # I will forget mine.
            self.adjacency_matrix[particle.id, :] = -1
            # They will forget me.
            self.adjacency_matrix[particle.id][particle.id] = (
                self.adjacency_matrix_encoding_factor * particle.inner_state + particle.inner_state
            )
            # This is due to how we keep the particle and its neighbours new state in the neighbouring matrix. MIGHT BE REFACORTED.
            for n in new_neighbors.values():
                self.adjacency_matrix[particle.id][n] = (
                    self.adjacency_matrix_encoding_factor * particle.inner_state + self.particles[n].inner_state
                )
                self.adjacency_matrix[n][particle.id] = (
                    self.adjacency_matrix_encoding_factor * self.particles[n].inner_state + particle.inner_state
                )
            return

        # if the move is rejected, we revert it
        self.do_move_particle(particle, old_coordinates)
        self.entropy_add = 0
        return

    def is_move_allowed(self, new_coordinates: Tuple[int]) -> bool:
        """
        Gets particle and movement direction (up/down/left/right) and cyclicity, and decides
        if the move is allowed (bounds & occupation considerations).
        """
        if utils.is_coordinates_in_bounds(
            new_coordinates, self.cfg.length, self.cfg.length
        ):
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

        # calculate local drive, Michael will go through this again.
        neighbors = utils.get_neighboring_elements(
            self.grid, particle.get_coordinates(), self.cfg.is_cyclic
        )
        num_of_neighbors_in_original_state = len(
            [
                n
                for n in neighbors.values()
                if self.particles[n].inner_state == original_state
            ]
        )
        num_of_neighbors_in_new_state = len(
            [
                n
                for n in neighbors.values()
                if self.particles[n].inner_state == new_state
            ]
        )
        local_drive = 0

        if num_of_neighbors_in_original_state >= 2:
            local_drive -= self.targets[original_state].local_drive
        if num_of_neighbors_in_new_state >= 2:
            local_drive += self.targets[new_state].local_drive
            AA = utils.metropolis_part_1(-(new_energy - old_energy) + local_drive)
            BB = utils.metropolis_part_1((new_energy - old_energy) + local_drive)
            aaaa = math.log(AA / BB)
        # self.entropy_add = math.log((utils.metropolis_part_1(-(new_energy - old_energy) + local_drive)/utils.
        # metropolis_part_1((new_energy - old_energy) - local_drive)))

        # Check change probabilty and edit adjacency_matrix.
        kenb = utils.metropolis(-(new_energy - old_energy) + local_drive)
        if utils.metropolis(-(new_energy - old_energy) + local_drive):
            for n in neighbors.values():
                self.adjacency_matrix[particle.id][n] = (
                    self.adjacency_matrix_encoding_factor * new_state + self.particles[n].inner_state
                )
                self.adjacency_matrix[n][particle.id] = (
                    self.adjacency_matrix_encoding_factor * self.particles[n].inner_state + new_state
                )
            self.adjacency_matrix[particle.id][particle.id] = self.adjacency_matrix_encoding_factor * new_state + new_state
            self.entropy_add = math.log(
                (
                    utils.metropolis_part_1(-(new_energy - old_energy) + local_drive)
                    / utils.metropolis_part_1((new_energy - old_energy) - local_drive)
                )
            )
            return

        # if change rejected, revert state
        particle.inner_state = original_state
        self.entropy_add = 0

        return

    def do_move_particle(self, particle, destination_coordinates):
        self.grid[particle.x][particle.y] = -1  # no particle
        self.grid[destination_coordinates[0]][
            destination_coordinates[1]
        ] = particle.id  # move particle on grid
        particle.x, particle.y = (
            destination_coordinates[0],
            destination_coordinates[1],
        )  # update particle coordinates

    # **The neibougring matrix are compared, due to rotation and transaltation symmetries.  A key point that might be troubl
    # some. To further explain the project book.
    def calc_distance_from_targets(self):
        distances = []
        for i in self.targets:
            distances.append(
                np.count_nonzero(self.adjacency_matrix != i.adjacency_matrix)
            )

        return distances

    def set_particles_at_target(self, coordinates, target_num):
        target_grid = self.targets[target_num].particles_grid
        particles_array_length = int(self.cfg.num_of_particles ** 0.5)

        for i in range(particles_array_length):
            for j in range(particles_array_length):
                coordinates[target_grid[i][j]] = (i, j)


# If we choose to start in target, what types etc.
