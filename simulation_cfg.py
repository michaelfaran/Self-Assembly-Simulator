from typing import List


class TargetCfg(object):
    weak_interaction: int
    strong_interaction: int
    num_of_instances: int
    local_drive: int


class SimulationCfg(object):
    length: int
    num_of_particles: int
    targets_cfg: List[TargetCfg]
    is_cyclic: bool

