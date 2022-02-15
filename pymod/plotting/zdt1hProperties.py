import matplotlib.pyplot as plt
import numpy as np


h = lambda f1, g : 1 - np.sqrt(f1/g)

# f1 constant 
g = np.linspace(1, 10, num=200)

ax1 = plt.subplot(1,2,1)
ax1.set_title("h vs g, with f1=1")

ax1.plot(g, h(1,g))

ax1.set_xlabel("g")
ax1.set_ylabel("h")


# g constant

f1 = np.linspace(0, 1, num=200)

ax2 = plt.subplot(1,2,2)
ax2.set_title("h vs f1, with g=1")

ax2.set_xlabel("f1")

ax2.plot(f1, h(f1,1))

plt.show()


