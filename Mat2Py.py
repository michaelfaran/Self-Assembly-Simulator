from mat4py import loadmat
import numpy as np
from scipy import signal
from scipy.interpolate import interp1d
import scipy.io
mat = scipy.io.loadmat('op.mat')


def downsample(array, npts):
    interpolated = interp1d(np.arange(len(array)), array, axis = 0, fill_value = 'extrapolate')
    downsampled = interpolated(np.linspace(0, len(array), npts))
    return downsampled
mat = scipy.io.loadmat('op.mat')
po= mat['op']
downsampled_y = downsample(po, 1000)

downsampled2 = signal.resample(po, 10)
np.save("downsampled.npy", downsampled)

