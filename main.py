from typing import IO
from exceptions import *
import json
from board import Board
from simulation_cfg import SimulationCfg, TargetCfg
import numpy as np
from utils import metropolis
CFG_FILE = "cfg.json"
from datetime import datetime
COUNTER = 0
MIN_DISTANCE = 1000

def load_cfg(cfg_file: IO) -> dict:
    cfg = json.loads(cfg_file)
    validate_cfg(cfg)  # this should throw exceptions
    return cfg


def validate_cfg(cfg: dict):
    return True

def main2():
    output = []
    for i in range(150):
        for j in range(1, 100000):
            if metropolis(-2.5):
                output.append(j)
                break

    print(sum(output)/len(output))

def main():
    global COUNTER
    global MIN_DISTANCE
    target1 = TargetCfg()
    target1.strong_interaction = -1.5
    target1.weak_interaction = -1
    target1.num_of_instances = 1
    target1.local_drive = 0
    cfg = SimulationCfg()
    cfg.length = 15
    cfg.num_of_particles = 25
    cfg.is_cyclic = True
    cfg.targets_cfg = [target1]
    global_result = []
    runs = [-5]

    startTime = datetime.now()

    with open("output.txt", "w") as outfile:
        for run in runs:
            outfile.write("begining run with strong interaction = {}------\n".format(run))
            target1.strong_interaction = run
            for i in range(2):
                COUNTER = 0
                MIN_DISTANCE=1000
                print("begining run {} with interaction {}".format(i, run))
                board = Board(cfg, outfile, False)  # Random initialization for TFAS measurements
                board.run_simulation(5 * (10**7

                                          ), tfas_turn_callback)
                print('\nend run--------------')


        print(datetime.now() - startTime)



def original_turn_callback(board, turn_num):
    distance_from_targets = board.calc_distance_from_targets()
    print(turn_num)

    turn_target = distance_from_targets.index(0) if 0 in distance_from_targets else -1  # get the target with distance 0

    if turn_target == -1:
        board.time_in_targets.append((turn_num, board.time_in_target))
        board.time_in_target = 0
        try:
            board.output_file.append(board.time_in_targets[1][1])
        except:
            board.output_file.append(1)
            return False

        return False

    if turn_target == board.current_target:
        board.time_in_target += 1
        return True

    if turn_target != -1 and board.hitting_times[turn_target] == -1:
        board.hitting_times[turn_target] = turn_num

    board.current_target = turn_target
    board.time_in_targets.append((turn_num, board.time_in_target))
    board.time_in_target = 0

    return True

def new2_turn_callback(board, turn_num):
    global COUNTER
    distance_from_targets = board.calc_distance_from_targets()
    print("\rturn {}".format(turn_num), end='')
    if not turn_num % (10 ** COUNTER):
        print('\r 10 ^ {}'.format(COUNTER))
        COUNTER += 1

    turn_target = distance_from_targets.index(0) if 0 in distance_from_targets else -1  # get the target with distance 0

    if turn_target == -1:
        board.time_in_target = 0

    elif turn_target == 0:
        board.time_in_target += 1
        board.time_in_targets += 1

    else:
        board.current_target = turn_target
        board.time_in_target = 1

    return True


def tfas_turn_callback(board, turn_num):
    global MIN_DISTANCE
    distance_from_targets = board.calc_distance_from_targets()
    if min(distance_from_targets) < MIN_DISTANCE:
        MIN_DISTANCE = min(distance_from_targets)
    print("\rturn {}    global min distance {}     current min distance".format(turn_num,MIN_DISTANCE, min(distance_from_targets)), end='')
    if 0 in distance_from_targets:  # If we are in some target - stop
        return False
    return True  # else continue

if __name__ == '__main__':
    main()
