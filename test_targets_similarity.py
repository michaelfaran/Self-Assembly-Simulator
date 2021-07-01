from simulation_cfg import load_cfg
from board import Board
import numpy as np
import matplotlib.pyplot as plt

CFG_FILE="test_cfg.json"
MOCK_OUTFILE="bla.txt"
NUM_TARGETS=1000

def adjacency_distance(mat1:np.ndarray, mat2: np.ndarray):
    return np.count_nonzero(mat1 != mat2)


with open(CFG_FILE, "r") as f_cfg:
    cfg = load_cfg(f_cfg)

cfg.targets_cfg[0].num_of_instances = NUM_TARGETS

with open(MOCK_OUTFILE,"w") as outfile:
    board = Board(cfg, outfile, start_at_target=0)  # Create the board to test the targets distances.
    adjacency_matrices = [target.adjacency_matrix for target in board.targets]
    distances_list=[]
    for i in range(len(adjacency_matrices)):
        for j in range(i+1, len(adjacency_matrices)):
            distances_list.append(np.count_nonzero(adjacency_matrices[i] != adjacency_matrices[j]))
    print(len(distances_list))
    print(min(distances_list))
    print(max(distances_list))
    print(np.std(distances_list))
    plt.scatter(range(len(distances_list)),distances_list)
    plt.savefig("list_plot.png")
