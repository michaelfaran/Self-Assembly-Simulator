from board import Board
import matplotlib as mpl
from matplotlib import pyplot
import numpy as np

"""
board = Board(10, 8)
grid_copy = np.copy(board.grid)
occupied_positions = board.grid != None
grid_copy[occupied_positions] = grid_copy[]

# make a color map of fixed colors
cmap = mpl.colors.ListedColormap(['b','g','r','c','m','y','k','w'])
bounds=[x-0.5 for x in range(9)]
norm = mpl.colors.BoundaryNorm(bounds, cmap.N)

# tell imshow about color map so that only set colors are used
img = pyplot.imshow(vals,interpolation='nearest',
                    cmap = cmap,norm=norm)

# make a color bar
pyplot.colorbar(img,cmap=cmap,
                norm=norm,boundaries=bounds,ticks=[-5,0,5])

pyplot.show()
"""

