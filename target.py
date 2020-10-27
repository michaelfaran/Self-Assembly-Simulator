import numpy as np
import random
import utils
import math
from exceptions import NonSquareParticlesNumber


class Target(object):
    def __init__(self, id, num_of_particles, weak_interaction, strong_interaction):
        self.id = id
        self.adjacency_matrix = self.build_adjacency_matrix(num_of_particles)
        self.weak_interaction = weak_interaction
        self.strong_interaction = strong_interaction

    def build_adjacency_matrix(self, num_of_particles) -> np.ndarray:
        if num_of_particles != math.isqrt(num_of_particles)**2:
            raise NonSquareParticlesNumber()
        array_length = int(num_of_particles ** 0.5)
        particles_list = [i for i in range(num_of_particles)]
        random.shuffle(particles_list)
        particles = np.array(particles_list).reshape(array_length, array_length)
        adjacency_matrix = np.zeros((num_of_particles, num_of_particles), int)

        for x in range(array_length):
            for y in range(array_length):
                neighbors = utils.get_neighboring_elements(particles, x, y)
                for direction, element in neighbors.items():
                    adjacency_matrix[particles[x][y], element] = 1

        return adjacency_matrix

    def get_energy(self, p1, p2):
        return 0.5 * (self.strong_interaction * self.adjacency_matrix[p1][p2] +
                      self.weak_interaction * (1 - self.adjacency_matrix[p1][p2]))