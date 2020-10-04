import numpy, constants, random


def metropolis(p):
    """
    Implements the Metropolis criterion, gets the acception probability p
    """
    if p>=1:
        return True
    else:
        return numpy.random.binomial(1, p, 1) == 1
        
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
    if p2 == None:
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
    if next_loc[0] < constants.L - 1:
        adj_locs.append([next_loc[0] + 1, next_loc[1]])
    #down
    if next_loc[0] > 0:
        adj_locs.append([next_loc[0] - 1, next_loc[1]])
    #right
    if next_loc[1] < constants.L - 1:
        adj_locs.append([next_loc[0], next_loc[1] + 1])
    #left
    if next_loc[1] > 0:
        adj_locs.append([next_loc[0], next_loc[1] - 1])
    return adj_locs

def physical_energy_difference(p, next_loc):
    """
    Given particle p and proposed location to move next_loc, this function calculates the energy difference between the states.
    To calculate the energy difference, one only need to examine the changes in the interactions of the moving particle (no need to sum over all the grid)/
    This difference is needed to calculate the move proposal acception probability to use in the Metropolis Criteria.
    """
    new_energy = sum([interaction(p1, grid.get_particle(loc)) for loc in adjacent_locs(next_loc)])
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
        if not grid.get_particle(new_loc): #Check if this slot isn't already populated
            energy_difference = physical_energy_difference(p, new_loc)
            if metropolis(np.exp(-energy_difference)): #TODO: make this line more modular, because the probability factor will be more complicated (local drive, etc.)
                p.loc = new_loc
                p.update_energy() #TODO
                p.neghibors.update_energy() #TODO



