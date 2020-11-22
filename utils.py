import numpy as np
import random
import math
from typing import Union, Tuple, List
from particle import Particle
from target import Target
from copy import copy
import matplotlib.pyplot as plt

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

def show_grid(grid: np.ndarray, particles: List[Particle],
              save_fig: bool = False, filename: str = "fig.png",
              title: str = "Simulation Snapshot"):
    palette=copy(plt.get_cmap("tab20"))
    palette.set_under('white',1.0)
    fig, ax = plt.subplots()
    ax.imshow(grid, cmap=palette, vmin=0)
    ax.set_xticks(np.arange(0,grid.shape[0],1))
    ax.set_yticks(np.arange(0,grid.shape[1],1))
    ax.set_xticklabels(np.arange(0, grid.shape[0], 1))
    ax.set_yticklabels(np.arange(0, grid.shape[1], 1))
    ax.set_xticks(np.arange(-.5, grid.shape[0], 1), minor=True)
    ax.set_yticks(np.arange(-.5, grid.shape[1], 1), minor=True)
    ax.grid(which='minor', color='black', linestyle='-', linewidth=2)
    for x in range(grid.shape[0]):
        for y in range(grid.shape[1]):
            if(grid[x][y]!=-1):
                id=grid[x][y]
                print(f"x: {x} y: {y} id: {id}")
                inner_state=particles[id].inner_state
                lbl=f"ID: {id}\nIN: {inner_state}"
                ax.text(y,x,lbl,va="center",ha="center")
    plt.title(title)
    if save_fig:
        plt.savefig(filename)
    plt.show()

