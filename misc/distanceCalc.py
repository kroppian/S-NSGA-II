import math 
import matplotlib.pyplot as plt

nums = list(range(0,100))

dists = []

for outnum in nums:

    total_dist = 0

    for innum in nums:

        total_dist += abs(outnum - innum)

    dists.append(total_dist)  
  
plt.bar(nums, dists)

plt.show()


