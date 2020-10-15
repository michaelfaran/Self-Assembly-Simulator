import random
import constants
from typing import List


class Particle:
    def __init__(self, particle_id: int):
        self.id = particle_id
        self.x = None
        self.y = None
        self.inner_state = random.randrange(0, constants.m)
        self.energy = 0
        self.neighbors = []

    def get_location(self):
        return [self.x, self.y]

    def get_inner_state(self):
        return self.inner_state

    def set_inner_state(self, new_state: int):
        self.inner_state = new_state

    def move_particle(self, new_loc: List[int]):
        #TODO: Add bounds & continusity checks
        x, y = new_loc
        self.x = x
        self.y = y

    def update_energy(self, old_loc: List[int], new_loc: List[int]):
        """
        Updates energy of particle and it's old & new neighbors
        after physical move.
        """
        #TODO: implement
        pass