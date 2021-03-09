from datetime import datetime

from board import Board
from simulation_cfg import load_cfg
import utils
from turn_callbacks import CallbackGlobals, original_turn_callback, new2_turn_callback, tfas_turn_callback

CFG_FILE = "cfg.json"


def main():
    global_result = []
    runs = [-6, -6.5, -7, -7.5, -8, -8.5]

    start_time = datetime.now()

    with open(CFG_FILE, "r") as f_cfg:
        cfg = load_cfg(f_cfg)

    with open("output.txt", "w") as outfile:
        CallbackGlobals.COUNTER = 0
        for run in runs:
            outfile.write("begining run with strong interaction = {}------\n".format(run))
            cfg.targets_cfg[0].strong_interaction = run
            for i in range(5):
                CallbackGlobals.MIN_DISTANCE = 500
                print("begining run {} with interaction {}".format(i, run))
                board = Board(cfg, outfile, False)  # Random initialization for TFAS measurements
                board.run_simulation(5 * (10 ** 7), tfas_turn_callback, CallbackGlobals.COUNTER)
                CallbackGlobals.COUNTER += 1
                print('\nend run--------------')

        print(datetime.now() - start_time)


if __name__ == '__main__':
    main()
