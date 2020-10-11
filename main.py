import numpy as np, constants, random

class Board:
    """
    TODO API:
    move_particle(particle, new_loc)
    """
    def __init__(self, particle_list):
        self.particles = particle_list
        self.grid = self.grid_initialize(particle_list)

    def grid_initialize(self, particle_list):
        grid = [[None for i in range(constants.L)] for j in range(constants.L)]
        coordinates = [(i,j) for i in range(constants.L) for j in range(constants.L)]
        random.shuffle(coordinates)
        for i in range(constants.N):
            x,y = coordinates[i]
            grid[x][y] = particle_list[i]
        return grid

    def get_particle(self, loc):
        x, y = loc
        return self.grid[x][y]

class Particle:
    def __init__(self):
        self.x = None
        self.y = None
        self.inner_state = random.randrange(0, constants.m)

    def get_location(self):
        return [self.x, self.y]

    def get_inner_state(self):
        return self.inner_state

    def set_inner_state(self, new_state):
        self.inner_state = new_state

    def move_particle(self, new_loc):
        #TODO: Add bounds & continusity checks
        x, y = new_loc
        self.x = x
        self.y = y


def metropolis(p):
    """
    Implements the Metropolis criterion, gets the acceptation probability p
    """
    if p>=1:
        return True
    else:
        return np.random.binomial(1, p, 1) == 1
        
def same_state_interaction(p1, p2, internal_state):
    """
    returns interaction between adjacent particles with the same internal state
    """
    if are_nn(p1, p2, internal_state):
        return constants.JS
    else:
        return constants.JW

def interaction(p1, p2):
    """
    Returns interaction between 2 adjacent particles (with any internal state)
    """
    if p2 is None:
        return 0 #There's no particle in the adjacent slot, therefore no interaction
    else:
        #If the particles are from the same internal state - this expression simply evaluates the same_state_interaction.
        #Else, the interaction value is as eq. 2 in the paper.
        return 0.5*(same_state_interaction(p1, p2, p1.internal_state) + same_state_interaction(p1, p2, p2.internal_state))

def adjacent_locs(loc):
    """
    Given location, this function returns a list contains indices lists of valid adjacent locations
    """
    adj_locs = []
    #up
    if loc[0] < constants.L - 1:
        adj_locs.append([loc[0] + 1, loc[1]])
    #down
    if loc[0] > 0:
        adj_locs.append([loc[0] - 1, loc[1]])
    #right
    if loc[1] < constants.L - 1:
        adj_locs.append([loc[0], loc[1] + 1])
    #left
    if loc[1] > 0:
        adj_locs.append([loc[0], loc[1] - 1])
    return adj_locs

def physical_energy_difference(p, next_loc):
    """
    Given particle p and proposed location to move next_loc, this function calculates the energy difference between the states.
    To calculate the energy difference, one only need to examine the changes in the interactions of the moving particle (no need to sum over all the grid)/
    This difference is needed to calculate the move proposal acception probability to use in the Metropolis Criteria.
    """
    new_energy = sum([interaction(p, Board.get_particle(loc)) for loc in adjacent_locs(next_loc)])
    curr_energy = p.energy
    return new_energy - p.energy
    
            
def move_attempt(p):
    """
    Gets particle, and handles a move attempt - Changes the location & energy of the particle & it's neghibors if
    succssesful, else does nothing.
    """
    new_loc = p.loc.copy()
    new_loc[random.choice([0,1])]+=random.choice([-1,1]) #random move proposal
    if 0 <= new_loc[0] <= constants.L and 0 <= new_loc[1] <= constants.L: #Check if within grid bounds
        if not Board.get_particle(new_loc): #Check if this slot isn't already populated
            energy_difference = physical_energy_difference(p, new_loc)
            if metropolis(np.exp(-energy_difference)): #TODO: make this line more modular, because the probability factor will be more complicated (local drive, etc.)
                p.loc = new_loc
                p.update_energy() #TODO
                p.neghibors.update_energy() #TODO

def are_nn():
    pass