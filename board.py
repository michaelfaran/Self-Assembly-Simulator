from particle import Particle
import numpy as np
import random
from typing import List
from exceptions import TooManyParticlesError


class Board:

    """
    TODO API:
    move_particle(particle, new_loc)
    """
    def __init__(self, size: int, particles_number: int):
        self.particles = [Particle(i) for i in range(particles_number)]
        self.grid = grid_initialize(size, particles_number, self.particles)
        if size ** 2 < particles_number:
            raise TooManyParticlesError(particles_number, size)
        else:
            self.L = size

    def get_particle(self, loc: List[int]):
        """
        Returns the particle in specified location.
        Returns None if the location is empty.
        """
        x, y = loc
        return self.grid[x][y]


def grid_initialize(size: int, particles_number: int, particle_list: List[Particle]):
    """
    Initializes grid.
    Gets list of particles, and randomly populates them in the grid.
    Returns the grid.
    """
    grid = np.empty((size, size), dtype=object)  # Particle slots
    coordinates = [(i, j) for i in range(size) for j in range(size)]  # Coordinates set
    random.shuffle(coordinates)
    for i in range(particles_number):
        x, y = coordinates[i]
        grid[x][y] = particle_list[i]
    return grid

