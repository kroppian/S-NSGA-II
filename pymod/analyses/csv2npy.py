import sys
import numpy as np


file_names = sys.argv[1:]

for file_name in file_names: 

    dat = np.genfromtxt(file_name, delimiter=',')

    updated_file_name = file_name[0:-4] + ".npy"

    print("%s -> %s" % (file_name, updated_file_name))
    np.save(updated_file_name, dat) 


