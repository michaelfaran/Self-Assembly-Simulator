import constants, numpy as np, random
from board import Board
from particle import Particle
from typing import Union, Optional, List


def metropolis(p: Union[float, int]):
    """
    Implements the Metropolis criterion, gets the acceptation probability p
    """
    if p >= 1:
        return True
    else:
        return np.random.binomial(1, p, 1) == 1


def same_state_interaction(p1: Particle, p2: Particle, inner_state: int):
    """
    Interaction calculator for adjacent particles with the same internal state
    """
    if are_nn(p1, p2, inner_state):
        return constants.JS
    else:
        return constants.JW


def interaction(p1: Particle, p2: Optional[Particle]):
    """
    General interaction calculator for 2 adjacent particles (with any internal state)
    """
    if p2 is None:
        return 0  # There's no particle in the adjacent slot, therefore no interaction
    else:
        """
        If the particles are from the same internal state,
        this expression simply evaluates the same_state_interaction.
        Otherwise, the interaction value is as eq. 2 in the paper.
        """
        return 0.5 * (same_state_interaction(p1, p2, p1.inner_state)
                      + same_state_interaction(p1, p2, p2.inner_state))


def adjacent_locs(loc: List[int], board: Board):
    """
    Given location, this function returns a list contains indices lists of valid adjacent locations
    """
    adj_locs = []
    # up
    if loc[0] < board.L - 1:
        adj_locs.append([loc[0] + 1, loc[1]])
    # down
    if loc[0] > 0:
        adj_locs.append([loc[0] - 1, loc[1]])
    # right
    if loc[1] < board.L - 1:
        adj_locs.append([loc[0], loc[1] + 1])
    # left
    if loc[1] > 0:
        adj_locs.append([loc[0], loc[1] - 1])
    return adj_locs


def physical_energy_difference(p: Particle, next_loc: List[int], board: Board):
    """
    Given particle p and proposed location to move next_loc, this function calculates
    the energy difference between the states.
    To calculate the energy difference, one only need to examine the changes in the
    interactions of the moving particle (no need to sum over all the grid).
    This difference is needed to calculate the move proposal acceptation probability
    to use in the Metropolis Criteria.
    """
    new_energy = sum([interaction(p, board.get_particle(loc)) for loc in adjacent_locs(next_loc)])
    curr_energy = p.energy
    return new_energy - p.energy


def move_attempt(p: Particle, board: Board):
    """
    Gets particle, and handles a move attempt - Changes the location & energy of the particle & it's neghibors if
    successful, else does nothing.
    """
    new_loc = p.loc.copy()
    new_loc[random.choice([0, 1])] += random.choice([-1, 1])  # random move proposal
    if 0 <= new_loc[0] <= board.L and 0 <= new_loc[1] <= board.L:  # Check if within grid bounds
        if board.get_particle(new_loc) is None:  # Check if this slot isn't already populated
            energy_difference = physical_energy_difference(p, new_loc, board)
            if metropolis(np.exp(
                    -energy_difference)):
                old_loc = p.loc
                p.loc = new_loc
                p.update_energy(old_loc, new_loc)


def are_nn(p1: Particle, p2: Particle, internal_state: int):
    """
    Determining if 2 particles are nearest neighbors (nn),
    in the target that matches an internal state.

    TODO: Think how to store targets efficiently.
    efficiently - so the nn check will be fast and simple.
    """
    pass