import particle
import constants
import numpy as np
import random
from typing import List

class Board:
    """
    TODO API:
    move_particle(particle, new_loc)
    """
    def __init__(self, size: int, particle_list: List[particle]):
        self.particles = particle_list
        self.grid = self.grid_initialize(particle_list)
        if np.power(size,2) < constants.N:
            pass #TODO: SizeException
        else:
            self.L = size #TODO: Replace all the constants.L with board.L

    def grid_initialize(self, particle_list: List[particle]):
        """
        Initializes grid.
        Gets list of particles, and randomly populates them in the grid.
        Returns the grid.
        """
        grid = [[None for i in range(constants.L)] for j in range(constants.L)]
        coordinates = [(i,j) for i in range(constants.L) for j in range(constants.L)]
        random.shuffle(coordinates)
        for i in range(constants.N):
            x,y = coordinates[i]
            grid[x][y] = particle_list[i]
        return grid

    def get_particle(self, loc: List[int]):
        """
        Returns the particle in specified location.
        Returns None if the location is empty.
        """
        x, y = loc
        return self.grid[x][y]