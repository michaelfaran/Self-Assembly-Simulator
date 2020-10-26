from typing import IO
from exceptions import *
import json
from board import Board
from simulation_cfg import SimulationCfg, TargetCfg
CFG_FILE = "cfg.json"


def load_cfg(cfg_file: IO) -> dict:
    cfg = json.loads(cfg_file)
    validate_cfg(cfg)  # this should throw exceptions
    return cfg


def validate_cfg(cfg: dict):
    return True


def main():
    target1 = TargetCfg()
    target1.strong_interaction = 1
    target1.weak_interaction = 1
    target1.num_of_instances = 3
    cfg = SimulationCfg()
    cfg.length = 4
    cfg.num_of_particles = 9
    cfg.targets_cfg = [target1]
    board = Board(cfg)
    print(board.grid)

if __name__ == '__main__':
    main()