from datetime import datetime, date
from board import Board
from simulation_cfg import load_cfg, SimulationCfg
import utils
from turn_callbacks import CallbackGlobals, time_in_target_callback, tfas_turn_callback

# This is the options names for the simulations. put it inside next.
from multiprocessing import Pool
import numpy as np
import scipy as sp
from scipy.io import savemat
import math
import re
#


CFG_FILE = "cfg.json"
# Importing paramaters for simulation


def simulation_manager(cfg: SimulationCfg, num_targets: int):
    # Everyhing that the main does. The motivation is to change the parameters without creating different files.
    today = date.today()
    date_string = today.strftime("%d_%m_%Y")
    filename = (
        "output_"
        + date_string
        + "_interaction_"
        + str(cfg.targets_cfg[0].strong_interaction)
        + "_targets_"
        + str(num_targets)
        + ".txt"
    )

    with open(filename, "w") as outfile:
        # Way in python to say- open this file. no end, just indientation.
        # Michael add of Entropy calculation
        TurnMaxNumber = 5 * (10 ** 5)
        RunMax = 3
        muMax = 3
        cfg.targets_cfg[0].num_of_instances = num_targets
        outfile.write(str(cfg.__dict__))
        outfile.write(str([target_cfg.__dict__ for target_cfg in cfg.targets_cfg]))
        outfile.write(
            "beginning sim with with strong interaction = {}------\n".format(
                cfg.targets_cfg[0].strong_interaction
            )
        )

        for mu in range(0, muMax):
            # Different drives choices for the simulation
            outfile.write("beginning run with mu interaction = {}------\n".format(mu))
            outfile.flush()
            for j in range(len(cfg.targets_cfg)):
                # For every target change local drive
                cfg.targets_cfg[j].local_drive = mu
                for run_index in range(0, RunMax):
                    # Number of iterations of the simulation
                    CallbackGlobals.MIN_DISTANCE = 1000
                    # Maximum length parameter. Save information outside the main, save in the callback. In each callback we search the
                    # each parameter you want, we use this parameter here in order to take "snapshots".
                    # along with saving the minimum distance.
                    print(
                        "beginning run {} with mu interaction {}".format(run_index, mu)
                    )
                    now = datetime.now()
                    current_time = now.strftime("%H:%M:%S")
                    outfile.write(f"start time: {current_time}\n")
                    board = Board(
                        cfg, outfile, start_at_target=35
                    )  # Start at target 0, not random!!!
                    # This is the initial target to start with, its name is 0. otherwise put false for totally random.
                    # A new class is used here. This class reperestns the lattice and other things, also runs interations.
                    entropy_vec = np.zeros(TurnMaxNumber)
                    board.run_simulation(
                        TurnMaxNumber,
                        time_in_target_callback,
                        CallbackGlobals.COUNTER,
                        entropy_vec,
                    )
                    # The first index is the number of time steps. dt is considered 1. turns instead of time constant. Counter is counting the number of turns. This is a possible to print to the user.
                    # The second index is what you want to simulation to do, IMPORTANT. this is a function. All the function possibilities are written above. If in the future we want to add another model
                    # it is possible by adding another name and file to this code.
                    print("\nend run--------------\n")
                    now = datetime.now()
                    current_time = now.strftime("%H:%M:%S")
                    outfile.write(f"end time: {current_time}\n\n")
                    outfile.flush()
                    name: str = (
                        "entropy_vec"
                        + "_mu_"
                        + str(int(mu))
                        + "_run_num_"
                        + str(int(run_index) + 1)
                        + "_num_target_"
                        + str(int(j) + 1)
                        + ".mat"
                    )
                    savemat(name, {"foo": entropy_vec})


if __name__ == "__main__":
    # This is a check for number of different targets done for the project. This is a Python syntax, for if I ran this file as main.
    # What would happen if you run this inside python sledom and not outside.
    num_targets_list = [1, 2, 3, 4, 5, 10, 15, 20]
    # Changing the number of targets.
    arg_list = []
    with open(CFG_FILE, "r") as f_cfg:
        cfg = load_cfg(f_cfg)
        # This is how to turn JASONS into python objects. This is a convention, not must. Configuraiton is the parameters file.
    for i in num_targets_list:
        arg_list.append((cfg, i))
        # Multiprocessing of many CPUs on python Syntax.
    with Pool(8) as p:
       p.starmap(simulation_manager, arg_list)
