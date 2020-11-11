import random
from typing import List


class Particle:
    def __init__(self, particle_id: int, inner_state: int):
        self.id = particle_id
        self.x = -1
        self.y = -1
        self.inner_state = inner_state
