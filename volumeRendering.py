#Author : Ashwin de Silva
#Last Updated : 2018 Mar 9

#Volumetric rendering 
#==============================================================================


#import libraries

import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import scipy.io as sio

#load the vspace.mat file

vspace = sio.loadmat('vspace.mat')
vspace = vspace['vspace']

#V = np.empty(voxels.shape, dtype=object)
V = vspace

fig = plt.figure()
ax = fig.gca(projection='3d')
ax.voxels(V, facecolors='r', edgecolor='k')

plt.show()

