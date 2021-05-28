import utils


class CallbackGlobals(object):
    COUNTER = 0
    MIN_DISTANCE = 0



def original_turn_callback(board, turn_num):
    distance_from_targets = board.calc_distance_from_targets()
    print(turn_num)

    turn_target = distance_from_targets.index(0) if 0 in distance_from_targets else -1  # get the target with distance 0

    if turn_target == -1:
        board.time_in_targets.append((turn_num, board.time_in_target))
        board.time_in_target = 0
        try:
            board.output_file.append(board.time_in_targets[1][1])
        except:
            board.output_file.append(1)
            return False

        return False

    if turn_target == board.current_target:
        board.time_in_target += 1
        return True

    if turn_target != -1 and board.hitting_times[turn_target] == -1:
        board.hitting_times[turn_target] = turn_num

    board.current_target = turn_target
    board.time_in_targets.append((turn_num, board.time_in_target))
    board.time_in_target = 0

    return True


def new2_turn_callback(board, turn_num):
    distance_from_targets = board.calc_distance_from_targets()
    print("\rturn {}".format(turn_num), end='')
    if not turn_num % (10 ** CallbackGlobals.COUNTER):
        print('\r 10 ^ {}'.format(CallbackGlobals.COUNTER))
        CallbackGlobals.COUNTER += 1

    turn_target = distance_from_targets.index(0) if 0 in distance_from_targets else -1  # get the target with distance 0

    if turn_target == -1:
        board.time_in_target = 0

    elif turn_target == 0:
        board.time_in_target += 1
        board.time_in_targets += 1

    else:
        board.current_target = turn_target
        board.time_in_target = 1

    return True


def tfas_turn_callback(board, turn_num):
    distance_from_targets = board.calc_distance_from_targets()

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
    print(
        "\rturn {}    global min distance {}     current min distance {}".format(turn_num, CallbackGlobals.MIN_DISTANCE,
                                                                                 min(distance_from_targets)),
        end='')
    if 0 in distance_from_targets:  # If we are in some target - stop
        return False
    return True  # else continue
