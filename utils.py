import numpy as np
import random
import math
from typing import Union, Tuple, List
from particle import Particle
from target import Target

neighbor_directions = {"right": (0, 1),
                       "left": (0, -1),
                       "up": (-1, 0),
                       "down": (1, 0)}


def metropolis(r: Union[float, int]) -> bool:
    """
    Implements the Metropolis criterion, gets the acceptation probability p
    """
    p = math.exp(r)
    if p >= 1:
        return True
    else:
        return np.random.binomial(1, p, 1) == 1


def get_neighboring_elements(array: np.ndarray, coordinates: Tuple[int], is_cyclic: bool=False,) -> dict:
    """
    Gets matrix of elements, and returns dictionary
    of the neighbors elements of a given index.
    Elements can be id's (like in target) or Particles.
    """
    neighboring_elements = {}

    for direction, delta in neighbor_directions.items():
        try:
            neighbor_coordinates = add_coordinates(coordinates, delta, is_cyclic, array.shape[0])
            if array[neighbor_coordinates[0]][neighbor_coordinates[1]] != -1:
                neighboring_elements[direction] = array[neighbor_coordinates[0]][neighbor_coordinates[1]]
        except IndexError:
            pass

    return neighboring_elements


def is_coordinates_in_bounds(coordinates: tuple, x_dimension: int, y_dimension: int):
    return 0 <= coordinates[0] < x_dimension and 0 <= coordinates[1] < y_dimension


def add_coordinates(original: Tuple[int], delta: Tuple[int], is_cyclic=False, length=math.inf):
    new = original[0] + delta[0], original[1] + delta[1]
    if is_cyclic:
        return new[0] % length, new[1] % length

    if is_coordinates_in_bounds(new, length, length):
        return new

    raise IndexError #if coordinate not in bounds
