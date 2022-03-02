from datetime import datetime, date
from board import Board
from simulation_cfg import load_cfg, SimulationCfg
import utils
from turn_callbacks import CallbackGlobals, time_in_target_callback, tfas_turn_callback, tfas_turn_callback2, seed_callback
import os
# This is the options names for the simulations. put it inside next.
from multiprocessing import Pool
import numpy as np
import scipy as sp
from scipy.io import savemat
import sys
import math
import re
#
import random
import gzip


CFG_FILE = "cfg.json"
# Importing paramaters for simulation


def simulation_manager(cfg: SimulationCfg, num_targets: int, num_of_runs_per_one: int):
    # Everyhing that the main does. The motivation is to change the parameters without creating different files.
    today = date.today()
    now = datetime.now()
    date_string = today.strftime("%d_%m_%Y")
    date_string_two = now.strftime("%m_%d_%Y_%H_%M_%S")
    filename = (
        "output_"
        + date_string_two
        + "_targets_"
        + str(num_targets)
        + "_num_of_run_"
        + str(num_of_runs_per_one)
        + ".txt"
    )
    #        + "_interaction_"
        #+ str(cfg.targets_cfg[0].strong_interaction)
#michael add for new fodler created
    script_dir = os.path.dirname(__file__)
    #resder = "Results\\" + date_string_two + "\\"
    results_dir = os.path.join(script_dir, 'Results', date_string_two, '')
    n = random.random()
    #results_dir = os.path.join(results_dir, str(n), '')
    results_dir = os.path.join(results_dir, str(num_targets), str(num_of_runs_per_one), '')
  #  os.makedirs(results_dir)

    if not os.path.isdir(results_dir):
        try:
            os.makedirs(results_dir)
        finally:
            aaa = 1


    with open(results_dir + filename, "w") as outfile:
        # Way in python to say- open this file. no end, just indientation.
        # Michael add of Entropy calculation
        TurnMaxNumber = 5 * (10 **0)
        RunMax = 2
        #20
        unitt = 1
        muMax = 3
        muMin = 0
        unittt = 2
        JMin =int(6.5*unittt)
        JMax = 3*unittt
        energy_step = 1
#22
       #should I hide it?
        for Jaa in range(JMax,JMin):
            Ja = -Jaa/unittt
            cfg.targets_cfg[0].num_of_instances = num_targets
            outfile.write(str(cfg.__dict__))
            outfile.write(str([target_cfg.__dict__ for target_cfg in cfg.targets_cfg]))
            #outfile.write(
               # "beginning sim with with strong interaction = {}------\n".format(
              #    cfg.targets_cfg[0].strong_interaction
             #   )
            #)
            outfile.write(
                "beginning sim with with strong interaction = {}------\n".format(
                  Ja)
            )

            for mu in range(muMin, muMax):
                # Different drives choices for the simulation
                check = range(len(cfg.targets_cfg))
                for j in range(len(cfg.targets_cfg)):
                    # For every target change local drive
                    cfg.targets_cfg[j].local_drive = unitt*mu
                    cfg.targets_cfg[j].strong_interaction = Ja
                    outfile.write("beginning run with mu ={} and with interaction ={}------\n".format(mu, cfg.targets_cfg[j].strong_interaction))
                    outfile.flush()
                    for run_index in range(0, RunMax):
                        # Number of iterations of the simulation, 100 originally
                        CallbackGlobals.MIN_DISTANCE = 30
                        # Maximum length parameter. Save information outside the main, save in the callback. In each callback we search the
                        # each parameter you want, we use this parameter here in order to take "snapshots".
                        # along with saving the minimum distance. If run is renewed, print again the strong interaciton and your good, might add to the file name the rest

                        print(
                            "beginning run {} with mu interaction {} and with Interaction {}".format(run_index, mu, cfg.targets_cfg[j].strong_interaction)
                        )
                        now = datetime.now()
                        current_time = now.strftime("%H:%M:%S")
                        outfile.write(f"start time: {current_time}\n")
                        board = Board(
                            cfg, outfile, start_at_target=0, seed_pivot= 1)  # Start at target 0, not random!!!
                        # This is the initial target to start with, its name is 0. otherwise put false for totally random.
                        # A new class is used here. This class reperestns the lattice and other things, also runs interations.
                        run_indexz = run_index
                        entropy_vec = np.zeros((TurnMaxNumber, 2))
                        energy_vec = np.zeros((TurnMaxNumber, 2))
                        board.run_simulation(
                            TurnMaxNumber,
                            seed_callback,
                            CallbackGlobals.COUNTER,
                            entropy_vec,
                            energy_vec,
                            num_targets,
                            mu,
                            j,
                            Ja,
                            results_dir,
                            run_indexz,
                        )
                        #tfas_turn_callback instead of time_in_target_callback, start at target= false usually

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
                            +"_total_num_target_"
                            + str(int(num_targets) )
                            + ".mat"
                        )
                        savemat(results_dir + name, {"foo": entropy_vec}, do_compression=True)
                        name: str = (
                                "distance_vec"
                                + "_mu_"
                                + str(int(mu))
                                + "_run_num_"
                                + str(int(run_index) + 1)
                                + "_num_target_"
                                + str(int(j) + 1)
                                + "_total_num_target_"
                                + str(int(num_targets))
                                + ".mat"
                        )
                        savemat(results_dir + name, {"foo": board.distance_vec}, do_compression=True)
                        name: str = (
                                "energy_vec"
                                + "_mu_"
                                + str(int(mu))
                                + "_run_num_"
                                + str(int(run_index) + 1)
                                + "_num_target_"
                                + str(int(j) + 1)
                                + "_total_num_target_"
                                + str(int(num_targets))
                                + ".mat"
                        )
                        savemat(results_dir + name, {"foo": energy_vec}, do_compression=True)


if __name__ == "__main__":
    # This is a check for number of different targets done for the project. This is a Python syntax, for if I ran this file as main.
    # What would happen if you run this inside python sledom and not outside.
    num_targets_list = [1, 2, 3, 4, 5, 10, 15, 20]
    num_targets_list = [1,2,3,4]
    num_targets_list = [2]
    num_of_runs_per_one = [1]
    #num_targets_list = [2]
    #num_of_runs_per_one = [1]
    # Changing the number of targets.
    arg_list = []
    with open(CFG_FILE, "r") as f_cfg:
        cfg = load_cfg(f_cfg)
        # This is how to turn JASONS into python objects. This is a convention, not must. Configuraiton is the parameters file.


    #Michael Add for more parallel
    for i in num_targets_list:
        for j in num_of_runs_per_one:
            arg_list.append((cfg, i, j))

        # Multiprocessing of many CPUs on python Syntax.
        #Here is the number of cores
    with Pool(12) as p:
        p.starmap(simulation_manager, arg_list)
