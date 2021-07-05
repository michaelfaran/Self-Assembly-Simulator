from simulation_cfg import load_cfg
from board import Board
import numpy as np
import matplotlib.pyplot as plt
import matplotlib

CFG_FILE="test_cfg.json"
MOCK_OUTFILE="bla.txt"
NUM_TARGETS=40

def adjacency_distance(mat1:np.ndarray, mat2: np.ndarray):
    return np.count_nonzero(mat1 != mat2)


with open(CFG_FILE, "r") as f_cfg:
    cfg = load_cfg(f_cfg)

cfg.targets_cfg[0].num_of_instances = NUM_TARGETS

with open(MOCK_OUTFILE,"w") as outfile:
    board = Board(cfg, outfile, start_at_target=0)  # Create the board to test the targets distances.
    adjacency_matrices = [target.adjacency_matrix % 11 for target in board.targets]  # Modulo 11 because the adjacency
    # matrices involves the inner state index, by multiplication by 11 (see build_adjacency_matrix in target.py).
    distances_list=[]
    for i in range(len(adjacency_matrices)):
        for j in range(i+1, len(adjacency_matrices)):
            distances_list.append(np.count_nonzero(adjacency_matrices[i] != adjacency_matrices[j]))

    print(adjacency_matrices[0])
    print(adjacency_matrices[1])
    print(distances_list[0])
    print(len(distances_list))
    print(min(distances_list))
    print(max(distances_list))
    print(np.std(distances_list))
    occurrences_list = dict((x, distances_list.count(x)) for x in set(distances_list))
    print(occurrences_list)
    #plt.scatter(range(len(distances_list)),distances_list)
    matplotlib.use("TkAgg")
    plt.bar(*zip(*occurrences_list.items()))
    plt.xticks(np.arange(start=min(occurrences_list.keys()),stop=max(occurrences_list.keys())+1,step=2))
    plt.title(f"Hamming distance between encoded targets\nGrid size: {cfg.length}X{cfg.length}"
              f"\nNumber of particles: {cfg.num_of_particles}"
              f"\nNumber of targets: {NUM_TARGETS}")
    plt.xlabel("Hamming distance")
    plt.ylabel("Number of pairs")
    plt.show()
