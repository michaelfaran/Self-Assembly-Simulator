import constants
import numpy as np
import random
from typing import Union, Optional, List

neighbor_directions = {"right": (0, 1),
                            "left": (0, -1),
                            "up": (-1, 0),
                            "down": (1, 0)}


def metropolis(p: Union[float, int]):
    """
    Implements the Metropolis criterion, gets the acceptation probability p
    """
    if p >= 1:
        return True
    else:
        return np.random.binomial(1, p, 1) == 1


def get_neighboring_elements(array: np.ndarray, x: int, y: int, is_cyclic: bool = False) -> dict:
    x_dimension, y_dimension = array.shape[0], array.shape[1]

    neighboring_elements = {}
    for direction, delta in neighbor_directions.items():
        if is_cyclic:
            neighbor_coordinates = ((x + delta[0]) % x_dimension, (y + delta[1]) % y_dimension)
        else:
            neighbor_coordinates = (x + delta[0], y + delta[1])
        try:
            if is_coordinates_in_bounds(neighbor_coordinates, x_dimension, y_dimension):
                neighboring_elements[direction] = array[neighbor_coordinates[0]][neighbor_coordinates[1]]
        except IndexError:
            pass

    return neighboring_elements


def is_coordinates_in_bounds(coordinates: tuple, x_dimension: int, y_dimension: int):
    return 0 <= coordinates[0] < x_dimension and 0 <= coordinates[1] < y_dimension
