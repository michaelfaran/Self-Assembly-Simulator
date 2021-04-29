from datetime import datetime

from board import Board
from simulation_cfg import load_cfg
import utils
from turn_callbacks import CallbackGlobals, original_turn_callback, new2_turn_callback, tfas_turn_callback

CFG_FILE = "cfg.json"


def main(filename):
    global_result = []
    runs = [8, 9, 10, 11]

    start_time = datetime.now()

    with open(CFG_FILE, "r") as f_cfg:
        cfg = load_cfg(f_cfg)

    with open(filename, "w") as outfile:
        CallbackGlobals.COUNTER = 0
        print(str(cfg.__dict__))
        outfile.write(str(cfg.__dict__))
        print(str([target_cfg.__dict__ for target_cfg in cfg.targets_cfg]))
        outfile.write(str([target_cfg.__dict__ for target_cfg in cfg.targets_cfg]))
        outfile.write("begining sim with with strong interaction = {}------\n".format(cfg.targets_cfg[0].strong_interaction))
        print("begining sim with with strong interaction = {}------\n".format(cfg.targets_cfg[0].strong_interaction))
        for run in runs:
            outfile.write("begining run with mu interaction = {}------\n".format(run))
            outfile.flush()
            for j in range(len(cfg.targets_cfg)):
                cfg.targets_cfg[j].local_drive = run
            for i in range(6):
                CallbackGlobals.MIN_DISTANCE = 1000
                print("begining run {} with mu interaction {}".format(i, run))
                board = Board(cfg, outfile, False)  # Random initialization for TFAS measurements
                board.run_simulation(5 * (10 ** 7), tfas_turn_callback, CallbackGlobals.COUNTER)
                CallbackGlobals.COUNTER += 1
                print('\nend run--------------')
                outfile.flush()
        print(datetime.now() - start_time)


if __name__ == '__main__':
    main("output_5_4_21_4.5strong_4targets.txt")
