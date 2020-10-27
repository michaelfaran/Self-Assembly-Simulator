from particle import Particle
from simulation_cfg import SimulationCfg
import numpy as np
import random
import utils
from target import Target
from typing import List
from exceptions import TooManyParticlesError


class Board:
    cfg: SimulationCfg
    grid: np.ndarray
    targets: List[Target]
    """
    TODO API:
    move_particle(particle, new_loc)
    """

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

    def calculate_particle_energy(self, particle_id: int) -> int:
        p = self.particles[particle_id]
        p_target = self.targets[p.inner_state]
        energy = 0
        for direction, neighbour_id in utils.get_neighboring_elements(self.grid, p.x, p.y, is_cyclic=True):
            n = self.particles[neighbour_id]
            n_target = self.targets[n.inner_state]
            energy += p_target.get_energy(p, n) + n_target.get_energy(n, p)

        return energy

    def turn(self):
        particle = random.choice(self.particles)



    def physical_move(self, ):
        particle = random.choice(self.particles)
        direction = random.choice(utils.neighbor_directions.keys())
        if not self.is_move_allowed(particle, direction):
            return
        original_energy = particle.energy
        original_x, original_y = particle.x, particle.y







