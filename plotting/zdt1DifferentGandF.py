import matplotlib.pyplot as plt
import numpy as np

f1 = np.linspace(0, 1, num=200)


g = lambda a : a

h = lambda f1, g : 1 - np.sqrt(f1/g)

# Changes in g
ax1 = plt.subplot(1,2,1)
ax1.set_title("Changes in g")
params = np.linspace(1, 3, num=5)
colors = ['black', 'green', 'red', 'yellow', 'blue']


for (i, param) in enumerate(params):

    g_val = g(param)
    f2 = g_val * h(f1, g_val)
    ax1.plot(f1, f2, color=colors[i], label="g=%f" % param )

# Changes in f1
ax2 = plt.subplot(1,2,2)
ax2.set_title("Changes in f1")


percents = np.linspace(0, 0.75, num=5)

for (i, percent) in enumerate(percents):

    offset = (len(f1)*percent)/2

    lower = int(offset)
    upper = int(len(f1) - offset)

    f1_sub = f1[lower:upper]

    g_val = g(1)
    f2_sub = g_val * h(f1_sub, g_val)
    ax2.plot(f1_sub, f2_sub, color=colors[i], label="g=%f" % percent )

plt.legend()
plt.show()



