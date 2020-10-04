import numpy, constants

def metropolis(p):
    if p>=1:
        return True
    else:
        return numpy.random.binomial(1, p, 1) == 1
        
def same_state_interaction(p1, p2, internal_state):
    if are_nn(p1, p2, internal_state):
        return constants.JS
    else:
        return constants.JW

def interaction(p1, p2):
    if p2 == None:
        return 0
    else:
        return 0.5*(same_state_interaction(p1, p2, p1.internal_state) + same_state_interaction(p1, p2, p2.internal_state))

def adjacent_locs(loc):
    adj_locs = []
    #up
    if next_loc[0] < constants.L - 1:
        adj_locs.append((next_loc[0] + 1, next_loc[1]))
    #down
    if next_loc[0] > 0:
        adj_locs.append((next_loc[0] - 1, next_loc[1]))
    #right
    if next_loc[1] < constants.L - 1:
        adj_locs.append((next_loc[0], next_loc[1] + 1))
    #left
    if next_loc[1] > 0:
        adj_locs.append((next_loc[0], next_loc[1] - 1))
    return adj_locs

def physical_energy_difference(p, next_loc):
    new_energy = sum([interaction(p1, grid.get_particle(loc)) for loc in adjacent_locs(next_loc)])
    curr_energy = p.energy
    return new_energy - p.energy
    
            
