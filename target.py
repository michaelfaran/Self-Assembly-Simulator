import numpy as np
import random
import utils
import math
from exceptions import NonSquareParticlesNumber


class Target(object):
    def __init__(
        self, id, num_of_particles, weak_interaction, strong_interaction, local_drive, enconding_factor
    ):
        self.id = id
        self.particles_grid = self.build_particles_grid(num_of_particles)
        self.adjacency_matrix = self.build_adjacency_matrix(self.particles_grid, enconding_factor)
        self.weak_interaction = weak_interaction
        self.strong_interaction = strong_interaction
        self.local_drive = local_drive

    def build_adjacency_matrix(self, particles: np.ndarray, enconding_factor: int) -> np.ndarray:
        num_of_particles = particles.size
        array_length = particles.shape[0]
        adjacency_matrix = np.zeros((num_of_particles, num_of_particles), int)
        adjacency_matrix[:] = -1

        for x in range(array_length):
            for y in range(array_length):
                neighbors = utils.get_neighboring_elements(
                    particles, (x, y), is_cyclic=False
                )
                for direction, element in neighbors.items():
                    adjacency_matrix[particles[x][y]][element] = self.id * (enconding_factor + 1)

                adjacency_matrix[particles[x][y]][particles[x][y]] = self.id * (enconding_factor + 1)

        return adjacency_matrix

    def build_particles_grid(self, num_of_particles):
        if num_of_particles != math.sqrt(num_of_particles) ** 2:
            raise NonSquareParticlesNumber()
        array_length = int(num_of_particles ** 0.5)
        particles_list = [i for i in range(num_of_particles)]
        random.shuffle(particles_list)
        return np.array(particles_list).reshape(array_length, array_length)

    def get_energy(self, p1: int, p2: int):
        """
        Gets two particles id's, returns the interaction strength between them.
        TODO: consider renaming to get_interaction, to not confuse with the calculate_energy
              function of Board. Even tough the board function may be erased.
        """
        indicator = 1 if self.are_neighboors_in_target(p1, p2) else 0
        return self.strong_interaction * indicator + self.weak_interaction * (
            1 - indicator
        )

    def are_neighboors_in_target(self, p1, p2):
        return 1 if self.adjacency_matrix[p1][p2] != -1 else 0
