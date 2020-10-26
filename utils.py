import constants
import numpy as np
import random
from typing import Union, Optional, List

neighboor_directions = {"up": (0, 1),
                            "down": (0, -1),
                            "left": (-1, 0),
                            "right": (1, 0)}


def metropolis(p: Union[float, int]):
    """
    Implements the Metropolis criterion, gets the acceptation probability p
    """
    if p >= 1:
        return True
    else:
        return np.random.binomial(1, p, 1) == 1

def get_neighborig_elements(array: np.ndarray, x: int, y: int, is_cyclic: bool = False) -> dict:
    x_dimension, y_dimension = array.shape[0], array.shape[1]

    neighboring_elements = {}
    for direction, delta in neighboor_directions.items():
        neighboor_coordinates = ((x + delta[0]) % x_dimension, (y + delta[1]) % y_dimension) if is_cyclic \
            else (x + delta[0], y + delta[1])
        try:
            neighboring_elements[direction] = array[neighboor_coordinates[0]][neighboor_coordinates[1]]
        except:
            pass

    return neighboring_elements



