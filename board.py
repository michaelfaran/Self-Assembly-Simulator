from particle import Particle
from simulation_cfg import SimulationCfg
import numpy as np
import random
import utils
from target import Target
from typing import List, Union
from exceptions import TooManyParticlesError


class Board:
    cfg: SimulationCfg
    particles: List[Particle]
    grid: np.ndarray
    targets: List[Target]


    def __init__(self, cfg):
        self.cfg = cfg
        self.particles = [Particle(i) for i in range(cfg.num_of_particles)]
        self.grid = self.initialize_grid(cfg.length, cfg.num_of_particles)
        self.targets = self.initialize_targets()

    def initialize_grid(self, length: int, num_of_particles: int):
        """
        Initializes grid.
        Gets list of particles, and randomly populates them in the grid.
        Returns the grid.
        """
        grid = np.full((length, length), -1, int)  # Particle slots, -1 represents no particle
        coordinates = [(i, j) for i in range(length) for j in range(length)]  # Coordinates set
        random.shuffle(coordinates)
        for i in range(num_of_particles):
            x, y = coordinates[i]
            grid[x][y] = i
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
                                      config.strong_interaction))
                id += 1
        return targets

    def calculate_particle_energy(self, particle_id: int) -> Union[int, float]:
        """
        Gets particle id, returns the current energy of the particle.
        TODO: why do we need this?
        """
        p = self.particles[particle_id]
        p_target = self.targets[p.inner_state]
        energy = 0
        for direction, neighbor_id in utils.get_neighboring_elements(self.grid, p.x, p.y, is_cyclic=False):
            n = self.particles[neighbor_id]
            n_target = self.targets[n.inner_state]
            energy += 0.5 * (p_target.get_energy(particle_id, neighbor_id) +
                             n_target.get_energy(particle_id, neighbor_id))

        return energy

    def turn(self):
        particle = random.choice(self.particles)
        self.physical_move(particle)
        # TODO: complete me

    def physical_move(self, particle: Particle) -> None:
        """
        Gets particle, and attempting to make a physical move according to
        energy difference metropolis query.
        """
        direction = random.choice(utils.neighbor_directions.values())
        direction_delta = utils.neighbor_directions[direction]

        if not self.is_move_allowed(particle,
                                    direction):  # TODO: take is_cyclic into consideration, maybe as board property from cfg.
            return

        new_x, new_y = particle.x + direction_delta[0], particle.y + direction_delta[1]
        original_neighbors = [self.particles[neighbor_id] for neighbor_id
                              in utils.get_neighboring_elements(self.grid, particle.x, particle.y).values()]
        new_neighbors = [self.particles[neighbor_id] for neighbor_id
                         in utils.get_neighboring_elements(self.grid, new_x, new_y).values()]  # TODO: is_cyclic also here

        energy_difference = 0
        for neighbor in original_neighbors:
            energy_difference -= utils.calc_interaction(particle, neighbor, self.targets)
        for neighbor in new_neighbors:
            energy_difference += utils.calc_interaction(particle, neighbor, self.targets)

        if utils.metropolis(-energy_difference):
            self.grid[particle.x][particle.y] = -1
            self.grid[new_x][new_y] = particle.id
            particle.x = new_x
            particle.y = new_y
        return




    def is_move_allowed(self, particle: Particle, direction: str, is_cyclic=False) -> bool:
        """
        Gets particle and movement direction (up/down/left/right) and cyclicity, and decides
        if the move is allowed (bounds & occupation considerations).
        """
        delta = utils.neighbor_directions[direction]
        length = self.grid.shape[0]  # Assuming square grid.

        if is_cyclic:
            new_coordinates = ((particle.x + delta[0]) % length, (particle.y + delta[1]) % length)
        else:
            new_coordinates = (particle.x + delta[0], particle.y + delta[1])

        if utils.is_coordinates_in_bounds(new_coordinates, length, length):
            return self.grid[new_coordinates[0]][new_coordinates[1]] == -1

        return False
