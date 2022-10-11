import matplotlib as mpl

mpl.use("Agg")
import numpy as np
import random
import math
from typing import Union, Tuple, List
from particle import Particle
from target import Target
from copy import copy
import matplotlib.pyplot as plt
import matplotlib
import os
import matplotlib.markers as mmarkers
from matplotlib.lines import Line2D

neighbor_directions = {"right": (0, 1), "left": (0, -1), "up": (-1, 0), "down": (1, 0)}


def metropolis(r: Union[float, int]) -> bool:
    """
    Implements the Metropolis criterion, gets the acceptation probability p
    """
    p = math.exp(r)
    if p >= 1:
        return True
    else:
        return np.random.binomial(1, p, 1) == 1


def metropolis_part_1(r: Union[float, int]) -> Union[int, float]:
    """
    Awaken the sleeper
    """
    """
    Implements the Metropolis criterion, gets the acceptation probability p
    """
    p = math.exp(r)
    if p >= 1:
        return 1
    else:
        return p


def get_neighboring_elements(
    array: np.ndarray,
    coordinates: Tuple[int, int],
    is_cyclic: bool = False,
) -> dict:
    """
    Gets matrix of elements, and returns dictionary
    of the neighbors elements of a given index.
    Elements can be id's (like in target) or Particles.
    """
    neighboring_elements = {}

    for direction, delta in neighbor_directions.items():
        try:
            neighbor_coordinates = add_coordinates(
                coordinates, delta, array.shape[0], is_cyclic
            )
            if array[neighbor_coordinates[0]][neighbor_coordinates[1]] != -1:
                neighboring_elements[direction] = array[neighbor_coordinates[0]][
                    neighbor_coordinates[1]
                ]
        except IndexError:
            pass

    return neighboring_elements


def is_coordinates_in_bounds(coordinates: tuple, x_dimension: int, y_dimension: int):
    return 0 <= coordinates[0] < x_dimension and 0 <= coordinates[1] < y_dimension


def add_coordinates(
    original: Tuple[int, int], delta: Tuple[int, int], length: int, is_cyclic=False
):
    new = original[0] + delta[0], original[1] + delta[1]
    if is_cyclic:
        return new[0] % length, new[1] % length

    if is_coordinates_in_bounds(new, length, length):
        return new

    raise IndexError  # if coordinate not in bounds

'''
def show_grid(
    grid: np.ndarray,
    particles: List[Particle],
    inner_states_number: int,
    save_fig: bool = True,
    filename: str = "fig.png",
    title: str = "Simulation Snapshot",
):
    script_dir = os.path.dirname(__file__)
    results_dir = os.path.join(script_dir, 'Results/')
    if not os.path.isdir(results_dir):
        os.makedirs(results_dir)
    palette = copy(plt.get_cmap("tab20", inner_states_number))
    palette.set_under("white", 1.0)

    inner_states_matrix = np.full((grid.shape[0], grid.shape[1]), -1, int)
    for x in range(grid.shape[0]):
        for y in range(grid.shape[1]):
            if grid[x][y] != -1:
                inner_states_matrix[x][y] = particles[grid[x][y]].inner_state
    fig, ax = plt.subplots()
    plot = ax.imshow(
        inner_states_matrix, cmap=palette, vmin=-0.5, vmax=inner_states_number - 0.5
    )
    ax.set_xticks(np.arange(0, grid.shape[0], 1))
    ax.set_yticks(np.arange(0, grid.shape[1], 1))
    ax.set_xticklabels(np.arange(0, grid.shape[0], 1))
    ax.set_yticklabels(np.arange(0, grid.shape[1], 1))
    ax.set_xticks(np.arange(-0.5, grid.shape[0], 1), minor=True)
    ax.set_yticks(np.arange(-0.5, grid.shape[1], 1), minor=True)
    ax.grid(which="minor", color="black", linestyle="-", linewidth=2)
    for x in range(grid.shape[0]):
        for y in range(grid.shape[1]):
            if grid[x][y] != -1:
                id = grid[x][y]
                inner_state = particles[id].inner_state
                # print(f"x: {x} y: {y} id: {id} state: {inner_state}")
                lbl = f"{id}"
                ax.text(y, x, lbl, va="center", ha="center", fontweight="bold")
    plt.title(title)
    # fig.colorbar(plot)
    cax = plt.colorbar(plot, ticks=np.arange(0, inner_states_number))
    if save_fig:
        plt.savefig(results_dir + filename)
    # plt.show()
    plt.close("all")

'''
def show_grid(
    grid: np.ndarray,
    particles: List[Particle],
    inner_states_number: int,
    turn_num: int,
    mu: int,
    j: int,
    run_indexz: int,
    results_dir,
    save_fig: bool = True,
    filename: str = "fig.png",
    title: str = "Simulation Snapshot",

):
    script_dir = os.path.dirname(__file__)
  #  results_dir = os.path.join(script_dir, 'Results/')
  #  if not os.path.isdir(results_dir):
  #      os.makedirs(results_dir)
    palette = copy(plt.get_cmap("tab20", inner_states_number))
    palette.set_under("white", 1.0)

    inner_states_matrix = np.full((grid.shape[0], grid.shape[1]), -1, int)
    for x in range(grid.shape[0]):
        for y in range(grid.shape[1]):
            if grid[x][y] != -1:
                inner_states_matrix[x][y] = particles[grid[x][y]].inner_state
    fig, ax = plt.subplots()
    plot = ax.imshow(
        inner_states_matrix, cmap=palette, vmin=-0.5, vmax=inner_states_number - 0.5
    )
    ax.set_xticks(np.arange(0, grid.shape[0], 1))
    ax.set_yticks(np.arange(0, grid.shape[1], 1))
    ax.set_xticklabels(np.arange(0, grid.shape[0], 1))
    ax.set_yticklabels(np.arange(0, grid.shape[1], 1))
    ax.set_xticks(np.arange(-0.5, grid.shape[0], 1), minor=True)
    ax.set_yticks(np.arange(-0.5, grid.shape[1], 1), minor=True)
    ax.grid(which="minor", color="black", linestyle="-", linewidth=2)
    for x in range(grid.shape[0]):
        for y in range(grid.shape[1]):
            if grid[x][y] != -1:
                id = grid[x][y]
                inner_state = particles[id].inner_state
                # print(f"x: {x} y: {y} id: {id} state: {inner_state}")
                lbl = f"{id+1}"
                if inner_state == 0:
                    ax.text(y, x, lbl, va="center", ha="center", fontweight="bold", fontsize=24, color='white')
                else:
                    ax.text(y, x, lbl, va="center", ha="center", fontweight="bold", fontsize=24)

    plt.title(title)
    # fig.colorbar(plot)
    cax = plt.colorbar(plot, ticks=np.arange(0, inner_states_number))
    if save_fig:
        plt.savefig(results_dir + filename + "mu_" + str(int(mu)) + "_run_index_" + str(int(run_indexz)) + "_num_target_" + str(int(j)) + "_turn_number_" + str(int(turn_num)) + ".png")
    # plt.show()
    plt.close("all")

def show_grid2(
    grid: np.ndarray,
    particles: List[Particle],
    inner_states_number: int,
    turn_num: int,
    mu: int,
    j: int,
    adjacency_matrix_encoding_factor: int,
    run_indexz: int,
    Ja: float,
    adjacency_matrix: np.ndarray,
    target_matrix: np.ndarray,
    results_dir,
    save_fig: bool = True,
    filename: str = "fig.png",
    title: str = "Simulation Snapshot",

):
    script_dir = os.path.dirname(__file__)
  #  results_dir = os.path.join(script_dir, 'Results/')
  #  if not os.path.isdir(results_dir):
  #      os.makedirs(results_dir)
    #matplotlib.use('TkAgg')
    palette = copy(plt.get_cmap("tab20", inner_states_number))
    palette.set_under("white", 1.0)
    palette2 = copy(plt.get_cmap("Set1", inner_states_number))
    palette2.set_under("white", 1.0)
    #palette2.colors[0] = (0.2800461361014994, 0.6269896193771626, 0.7024221453287197, 1)
    palette2.colors[0] = [1, 1, 0, 1.        ]
    palette2.colors[1] = [1, 0, 0, 1.]
    #palette2.colors[0] = [0.6, 0.6, 0.6, 1.]
    inner_states_matrix = np.full((grid.shape[0], grid.shape[1]), -1, int)
    coordinates_gridold = np.zeros((grid.shape[0]*grid.shape[1], 2))
    coordinates_grid = coordinates_gridold.astype(np.int)
    for x in range(grid.shape[0]):
        for y in range(grid.shape[1]):
            if grid[x][y] != -1:
                inner_states_matrix[x][y] = particles[grid[x][y]].inner_state
                inner_states_matrix[x][y] = j
                coordinates_grid[grid[x][y]] = [ x , y ]
                #coordinates_grid[grid[x][y], 2] = y
    fig, ax = plt.subplots()
    plot = ax.imshow(
        inner_states_matrix, cmap=palette, vmin=-0.5, vmax=inner_states_number - 0.5
    )

    ax.set_xticks(np.arange(0, grid.shape[0], 1))
    ax.set_yticks(np.arange(0, grid.shape[1], 1))
    ax.set_xticklabels(np.arange(0, grid.shape[0], 1))
    ax.set_yticklabels(np.arange(0, grid.shape[1], 1))
    ax.set_xticks(np.arange(-0.5, grid.shape[0], 1), minor=True)
    ax.set_yticks(np.arange(-0.5, grid.shape[1], 1), minor=True)
    ax.set_xticklabels([])
    ax.set_yticklabels([])
    ax.set_xticks([])
    ax.set_yticks([])
    ax.tick_params(axis='y', which='minor', left=False)
    ax.tick_params(axis='x', which='minor', bottom=False)
    ax.grid(which="minor", color="black", linestyle="-", linewidth=2)

    lett = np.shape(adjacency_matrix)
    let = lett[1]
    #neighbors_mat = zeros(let,4)-1
    #count = zeros(let,1)
    connection_coordiantesx = 0
    connection_coordiantesy = 0
    v = 0
    cmap = get_cmap(inner_states_number)
    neighbours_vec=[]
    for x in range(grid.shape[0]):
        for y in range(grid.shape[1]):
            if grid[x][y] != -1:
                id = grid[x][y]
                inner_state = particles[id].inner_state
                # print(f"x: {x} y: {y} id: {id} state: {inner_state}")
                lbl = f"{id+1}"
                if j == 0:
                    ax.text(y, x, lbl, va="center", ha="center", fontweight="bold", fontsize=24, color='white')
                else:
                    ax.text(y, x, lbl, va="center", ha="center", fontweight="bold", fontsize=24)

    #cax = plt.colorbar(plot, ticks=np.arange(0, inner_states_number))
    for xx in range(let):
        # statesituation = checkstateofparticlein[adjacency_matrix(xx, xx)]
        # statesituation2 = checkstateofparticlein[target(xx, xx)]
        # a = adjacency_matrix[xx, xx]
        # aa = adjacency_matrix[xx, xx] - adjacency_matrix_encoding_factor * adjacency_matrix[xx, xx] / (
        #  adjacency_matrix_encoding_factor + 1)
        if adjacency_matrix[xx, xx] - adjacency_matrix_encoding_factor * adjacency_matrix[xx, xx] / (
                adjacency_matrix_encoding_factor + 1) == j:
            for yy in range(let):
                # aa = adjacency_matrix[xx, yy]- adjacency_matrix_encoding_factor*adjacency_matrix[xx, xx]/(adjacency_matrix_encoding_factor+1)
                d = not yy == xx
                if (adjacency_matrix[xx, yy] - adjacency_matrix_encoding_factor * adjacency_matrix[xx, xx] / (
                        adjacency_matrix_encoding_factor + 1) == j) & d:
                    a = not (adjacency_matrix[xx, yy] == -1)
                    # b =  ~adjacency_matrix[xx, yy]
                    if (adjacency_matrix[xx, yy] - target_matrix[xx, yy] == 0) & a:
                        asf = (coordinates_grid[xx, 0] + coordinates_grid[yy, 0]) / 2
                        connection_coordiantesx = (coordinates_grid[xx, 0] + coordinates_grid[yy, 0]) / 2
                        connection_coordiantesy = (coordinates_grid[xx, 1] + coordinates_grid[yy, 1]) / 2
                        neighbours_vec.append([xx, yy])
                        # count(xx)=count(xx)+1
                        # neighbors_mat (xx ,count(xx)) = adjacency_matrix(xx, yy)
                        v = 1
                        plt.sca(ax)
                        plt.plot(connection_coordiantesy, connection_coordiantesx, marker=Line2D.filled_markers[j], color=palette2.colors[j], markersize=10)
                      #  plt.xlim(-0.5, 4.5)
                       # plt.ylim(-0.5, 4.5)
   # plt.title(title)

    # fig.colorbar(plot)
    """
    plt.tick_params(
        axis='both',  # changes apply to the x-axis
        which='both',  # both major and minor ticks are affected
        bottom=False,  # ticks along the bottom edge are off
        left=False,  # ticks along the top edge are off
        labelbottom=False)  # labels along the bottom edge are off
    """
    if save_fig:
        plt.savefig(results_dir + filename + "mu_" + str(int(mu)) + "_run_index_" + str(int(run_indexz)) + "_num_target_" + str(int(j)) + "_turn_number_" + str(int(turn_num)) +"_J_strong_" + str(float(Ja)) + ".png")
    # plt.show()
    plt.close("all")
    return neighbours_vec

def show_grid3(
    grid: np.ndarray,
    particles: List[Particle],
    hey: list,
    inner_states_number: int,
    turn_num: int,
    mu: int,
    j: int,
    run_indexz: int,
    Ja:float,
    results_dir,
    save_fig: bool = True,
    filename: str = "fig.png",
    title: str = "Simulation Snapshot",

):
    script_dir = os.path.dirname(__file__)
  #  results_dir = os.path.join(script_dir, 'Results/')
  #  if not os.path.isdir(results_dir):
  #      os.makedirs(results_dir)
    palette = copy(plt.get_cmap("tab20", inner_states_number))
    palette.set_under("white", 1.0)
    palette2 = copy(plt.get_cmap("Set1", inner_states_number))
    palette2.set_under("white", 1.0)
    #palette2.colors[0] = (0.2800461361014994, 0.6269896193771626, 0.7024221453287197, 1)
    palette2.colors[1] = [1, 0, 0, 1.]
    palette2.colors[0] = [1, 1, 0, 1.]
    #palette2.colors[0] = [1, 1, 0, 1.        ]
    #palette2.colors[0] = 'r'
    #palette2.colors[1] = 'y'
    inner_states_matrix = np.full((grid.shape[0], grid.shape[1]), -1, int)
    for x in range(grid.shape[0]):
        for y in range(grid.shape[1]):
            if grid[x][y] != -1:
                inner_states_matrix[x][y] = particles[grid[x][y]].inner_state

    fig, ax = plt.subplots()
    plot = ax.imshow(
        inner_states_matrix, cmap=palette, vmin=-0.5, vmax=inner_states_number - 0.5
    )
    ax.tick_params(axis='y', which='minor', left=False)
    ax.tick_params(axis='x', which='minor', bottom=False)

    for ko in range(inner_states_number):
        BlackCoat = hey[ko]
        for ii in range(int(0.5*np.size(BlackCoat))):
            index1= BlackCoat[ii][0]
            index2= BlackCoat[ii][1]
            x1 = 0.5 * (particles[index1].x+ particles[index2].x)
            y1 = 0.5 * (particles[index1].y + particles[index2].y)


            if (np.abs(particles[index1].x- particles[index2].x)>1):
                plt.sca(ax)
                plt.plot(y1, 0-0.5, marker=Line2D.filled_markers[ko], color=palette2.colors[ko],
                         markersize=4)
                plt.plot(y1, grid.shape[0]-0.5, marker=Line2D.filled_markers[ko], color=palette2.colors[ko],
                        markersize=4)
            elif (np.abs(particles[index1].y - particles[index2].y) > 1):
                plt.sca(ax)
                plt.plot(0-0.5, x1, marker=Line2D.filled_markers[ko], color=palette2.colors[ko],
                         markersize=4)
                plt.plot(grid.shape[0]-0.5, x1, marker=Line2D.filled_markers[ko], color=palette2.colors[ko],
                        markersize=4)
            elif (particles[index1].inner_state == ko and particles[index2].inner_state == ko):
                plt.sca(ax)
                plt.plot(y1, x1, marker=Line2D.filled_markers[ko], color=palette2.colors[ko],
                     markersize=4)
            #plt.xlim(-0.5, 4.5)
            #plt.ylim(-0.5, 4.5)
    ax.set_xticks(np.arange(0, grid.shape[0], 1))
    ax.set_yticks(np.arange(0, grid.shape[1], 1))
    ax.set_xticklabels(np.arange(0, grid.shape[0], 1))
    ax.set_yticklabels(np.arange(0, grid.shape[1], 1))
    ax.set_xticks(np.arange(-0.5, grid.shape[0], 1), minor=True)
    ax.set_yticks(np.arange(-0.5, grid.shape[1], 1), minor=True)
    ax.set_xticklabels([])
    ax.set_yticklabels([])
    ax.set_xticks([])
    ax.set_yticks([])
    ax.grid(which="minor", color="black", linestyle="-", linewidth=2)

    for x in range(grid.shape[0]):
        for y in range(grid.shape[1]):
            if grid[x][y] != -1:
                id = grid[x][y]
                inner_state = particles[id].inner_state
                # print(f"x: {x} y: {y} id: {id} state: {inner_state}")
                lbl = f"{id+1}"
                if inner_state == 0:
                    ax.text(y, x, lbl, va="center", ha="center", fontweight="bold", fontsize="8",color='white')
                else:
                    ax.text(y, x, lbl, va="center", ha="center", fontweight="bold", fontsize="8")

    #plt.title(title)
    # fig.colorbar(plot)
    #cax = plt.colorbar(plot, ticks=np.arange(0, inner_states_number))
    if save_fig:
       # plt.savefig(results_dir + filename + "mu_" + str(int(mu)) + "_run_index_" + str(int(run_indexz)) + "_num_target_" + str(int(j)) + "_turn_number_" + str(int(turn_num)) + ".png")
        plt.savefig(results_dir + filename + "mu_" + str(int(mu)) + "_run_index_" + str(int(run_indexz)) + "_num_target_" + str(int(j)) + "_turn_number_" + str(int(turn_num)) + "_J_strong_" + str(float(Ja)) + ".png")
    # plt.show()
    plt.close("all")

def save_distance_figure(name, arr):
    plt.clf()
    plt.plot(arr)
    plt.savefig(f"{name}.png")
    plt.close("all")

def get_cmap(n, name='hsv'):
    '''Returns a function that maps each index in 0, 1, ..., n-1 to a distinct
    RGB color; the keyword argument name must be a standard mpl colormap name.'''
    return plt.cm.get_cmap(name, n)
