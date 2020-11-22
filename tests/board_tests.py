import unittest
import numpy as np
from simulation_cfg import SimulationCfg, TargetCfg
from board import Board
from file_dummy import FileDummy



class BoardTests(unittest.TestCase):
    def setUp(self):
        file_dummy = FileDummy()
        self.board = Board(get_test_cfg(), file_dummy)

    def test_zero_distance(self):
        arrange_at_target(self.board.targets[0], self.board)
        distances = self.board.calc_distance_from_targets()
        assert(distances[0] == 0)


def get_test_cfg():
    target1 = TargetCfg()
    target1.strong_interaction = -2
    target1.weak_interaction = -1
    target1.num_of_instances = 1
    target1.local_drive = 0
    dummy_cfg = SimulationCfg()
    dummy_cfg.length = 50
    dummy_cfg.num_of_particles = 25
    dummy_cfg.is_cyclic = True
    dummy_cfg.targets_cfg = [target1]

    return dummy_cfg

def arrange_at_target(target, test_board):
    #init grid
    test_board.grid = np.full(test_board.grid.shape, -1, int)
    for i in range(target.particles_grid.shape[0]):
        for j in range(target.particles_grid.shape[0]):
            test_board.grid[i][j] = target.particles_grid[i][j]
            particle = test_board.particles[target.particles_grid[i][j]]
            particle.x = i
            particle.y = j

    test_board.adjacency_matrix = test_board.initizalize_adjacency_matrix()


