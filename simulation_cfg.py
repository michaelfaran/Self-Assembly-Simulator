from typing import List, IO
import json
import numpy as np
import codecs

class Cfg(object):
    pass


class TargetCfg(Cfg):
    weak_interaction: int
    strong_interaction: int
    num_of_instances: int
    local_drive: int

    def __init__(self, dictionary: dict):
        self.weak_interaction = dictionary["weak_interaction"]
        self.strong_interaction = dictionary["strong_interaction"]
        self.num_of_instances = dictionary["num_of_instances"]
        self.local_drive = dictionary["local_drive"]


class SimulationCfg(Cfg):
    length: int
    num_of_particles: int
    targets_cfg: List[TargetCfg]
    is_cyclic: bool
    #seed_matrix: np.array
    #obj_text = codecs.open('r', encoding='utf-8').read()
    seed_matrix = json.load(codecs.open('seed.json', 'r', 'utf-8-sig'))
    #b_new = json.loads(obj_text)
    #a_new = np.array(b_new)
    #keys = seed_matrixx[0]
    #seed_matrix = [dict(zip(keys, values)) for values in seed_matrixx[1:]]
    c = {}
    for i in range(1, len(seed_matrix)):
        c[i] = seed_matrix[i]
    def __init__(self, dictionary: dict):
        self.length = dictionary["length"]
        self.num_of_particles = dictionary["num_of_particles"]
        self.targets_cfg = dictionary["targets_cfg"]
        self.is_cyclic = dictionary["is_cyclic"]
        self.seed_matrix = dictionary["seed_matrix"]


def load_cfg(cfg_file: IO) -> SimulationCfg:
    cfg = json.load(cfg_file)
    return deserialize_cfg(cfg)  # this should throw exceptions


def deserialize_cfg(cfg: dict):
    target_objects = [TargetCfg(target_cfg) for target_cfg in cfg["targets_cfg"]]
    cfg["targets_cfg"] = target_objects
    return SimulationCfg(cfg)
