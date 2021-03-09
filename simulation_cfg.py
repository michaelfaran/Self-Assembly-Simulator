from typing import List, IO
import json


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

    def __init__(self, dictionary: dict):
        self.length = dictionary["length"]
        self.num_of_particles = dictionary["num_of_particles"]
        self.targets_cfg = dictionary["targets_cfg"]
        self.is_cyclic = dictionary["is_cyclic"]


def load_cfg(cfg_file: IO) -> SimulationCfg:
    cfg = json.load(cfg_file)
    return deserialize_cfg(cfg)  # this should throw exceptions


def deserialize_cfg(cfg: dict):
    target_objects = [TargetCfg(target_cfg) for target_cfg in cfg["targets_cfg"]]
    cfg["targets_cfg"] = target_objects
    return SimulationCfg(cfg)
