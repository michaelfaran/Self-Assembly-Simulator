from datetime import datetime, date
from board import Board
from simulation_cfg import load_cfg, SimulationCfg
import utils
from turn_callbacks import CallbackGlobals, time_in_target_callback, tfas_turn_callback
from multiprocessing import Pool


CFG_FILE = "cfg.json"


def simulation_manager(cfg: SimulationCfg ,num_targets: int):
    today=date.today()
    date_string=today.strftime("%d_%m_%Y")
    filename="output_"+date_string+"_interaction_"+str(cfg.targets_cfg[0].strong_interaction)+"_targets_"+str(num_targets)+".txt"

    with open(filename,"w") as outfile:
        cfg.targets_cfg[0].num_of_instances = num_targets
        outfile.write(str(cfg.__dict__))
        outfile.write(str([target_cfg.__dict__ for target_cfg in cfg.targets_cfg]))
        outfile.write("begining sim with with strong interaction = {}------\n".format(cfg.targets_cfg[0].strong_interaction))
        for mu in range(6,11):
            outfile.write("begining run with mu interaction = {}------\n".format(mu))
            outfile.flush()
            for j in range(len(cfg.targets_cfg)):
                cfg.targets_cfg[j].local_drive = mu
                for i in range(6):
                    CallbackGlobals.MIN_DISTANCE = 1000
                    print("begining run {} with mu interaction {}".format(i, mu))
                    board = Board(cfg, outfile, start_at_target=0 )  # Start at target 0, not random!!!
                    board.run_simulation(5 * (10 ** 7), time_in_target_callback, CallbackGlobals.COUNTER)
                    print('\nend run--------------')
                    outfile.flush()


if __name__ == '__main__':
    num_targets = [9,10,11,12,13]
    arg_list=[]
    with open(CFG_FILE, "r") as f_cfg:
        cfg = load_cfg(f_cfg)
    for i in num_targets:
        arg_list.append((cfg, i))
    with Pool(5) as p:
        p.starmap(simulation_manager,arg_list)
