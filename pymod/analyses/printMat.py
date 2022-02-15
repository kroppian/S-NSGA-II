import sys
import numpy as np

#np.set_printoptions(threshold=sys.maxsize)

file_names = sys.argv[1:]

for file_name in file_names:


    dat = np.load(file_name)
    cols = np.shape(dat)[1]
    rows = np.shape(dat)[0]

    for row in range(rows):
        frmt_str = "%f,".join([str("") for a in range(cols+1)])[0:-1]
        print(frmt_str % tuple(dat[row,:]))


