import utils


class CallbackGlobals(object):
    COUNTER = 0
    MIN_DISTANCE = 0


def time_in_target_callback(board, turn_num, finished=False):
    # finished is the last chance to keep variables before simulation ends. Conditions you want as results are below.
    if finished:
        board.output_file.write("time in target: {}\n".format(board.time_in_target))
        return

    distance_from_targets = board.calc_distance_from_targets()
    # Function inside board that calculates this
    print("\rturn {}".format(turn_num), end="")
    if not turn_num % (10 ** CallbackGlobals.COUNTER):
        print("\r 10 ^ {}".format(CallbackGlobals.COUNTER))
        CallbackGlobals.COUNTER += 1

    turn_target = (
        distance_from_targets.index(0) if 0 in distance_from_targets else -1
    )  # get the target with distance 0
    # Check if the system is now in a target
    if turn_target == 0:
        board.time_in_target += 1
    # Here we started with target 0, so we add to time in target 0 if we are in this target, o.w
    return True
    # If this is false, you break the simulation.


def tfas_turn_callback(board, turn_num, finished=False):
    if finished:
        board.output_file.write("tfas: {}\n".format(turn_num))
        return
    # If we finished, write it all to output. This callback is only for random. This is the second option was realizied in this project.
    # If we decide to follow entropy, we should write in the board, since it depends on the past.

    distance_from_targets = board.calc_distance_from_targets()
    board.distance_vec[turn_num]= min(distance_from_targets)
    board.distance_vec[turn_num] = distance_from_targets
    if min(distance_from_targets) < CallbackGlobals.MIN_DISTANCE:
        CallbackGlobals.MIN_DISTANCE = min(distance_from_targets)
        """
        if min(distance_from_targets) < 11:
            utils.show_grid(board.grid, board.particles, 1, True,
                            "j{}r{}close_state.png".format(board.targets[0].strong_interaction,
                                                           CallbackGlobals.COUNTER),
                            title="Close state snapshot d={}".format(min(distance_from_targets)))
            utils.show_grid(board.targets[0].particles_grid, board.particles, 1,
                            True,
                            "j{}r{}target.png".format(board.targets[0].strong_interaction, CallbackGlobals.COUNTER),
                            title="Target snapshot j={} run {}".format(board.targets[0].strong_interaction,
                                                                       CallbackGlobals.COUNTER))
    """
    # Here some pictures are posted, this optional for future work if needed.

    #Printing every x steps snapshot, x is set to 2*10^6 at the moment
    x = 500000
    CallbackGlobals.COUNTER = turn_num
    if turn_num % x == 0:

        utils.show_grid(board.grid, board.particles, board.num_targets,  turn_num, board.mu, 0,
                        board.run_indexz, board.results_dir, True,  "State_".format(board.targets[0].strong_interaction,
                                                       CallbackGlobals.COUNTER),
                        title="Close state snapshot d={}".format(min(distance_from_targets)),)




    print(
        "\rturn {}    global min distance {}     current min distance {}".format(
            turn_num, CallbackGlobals.MIN_DISTANCE, min(distance_from_targets)
        ),
        end="",
    )

    #x = 500

    if turn_num % x == 0:

        for ij in range(0, (board.num_targets)):
            '''
            utils.show_grid(board.targets[ij].particles_grid, board.particles, board.num_targets, turn_num, board.mu,ij,
                    board.run_indexz, board.results_dir, True,
                    "Target_".format(board.targets[ij].strong_interaction, CallbackGlobals.COUNTER),
                    title="Target snapshot j={} run {}".format(board.targets[ij].strong_interaction,
                                                               CallbackGlobals.COUNTER), )
            '''
            utils.show_grid2(board.targets[ij].particles_grid, board.particles, board.num_targets, turn_num, board.mu,ij,
                    board.adjacency_matrix_encoding_factor, board.run_indexz,   board.adjacency_matrix,
                             board.targets[ij].adjacency_matrix,board.results_dir, True,
                    "Target_".format(board.targets[ij].strong_interaction, CallbackGlobals.COUNTER),
                    title="Target snapshot j={} run {}".format(board.targets[ij].strong_interaction,
                                                               CallbackGlobals.COUNTER), )

            #utils.show_grid2(board.grid, board.particles, board.num_targets, turn_num, board.mu, 0,
             #                board.adjacency_matrix_encoding_factor,
              #               board.run_indexz, board.results_dir, board.adjacency_matrix,
               #              board.targets[ij].adjacency_matrix, True,
                #             "State_".format(board.targets[0].strong_interaction,
                 #                            CallbackGlobals.COUNTER),
                  #           title="Close state snapshot d={}".format(min(distance_from_targets)))

    if 0 in distance_from_targets:  # If we are in some target - stop
        return False
    return True  # else continue
