import random
import constants
from typing import List


class Particle:
    def __init__(self, particle_id: int):
        self.id = particle_id
        self.x = None
        self.y = None
        self.inner_state = random.randrange(0, constants.m) #TODO: replace me with the cfg shit.
