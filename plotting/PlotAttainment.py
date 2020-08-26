

import numpy as np
import matplotlib.pyplot as plt

def plot_attainment(F, plt, color="grey"):

    F = F[F[:,1].argsort()]

    plt.plot(F[:,0], F[:,1], ',', color=color)

    connectionstyle = "angle,angleA=-90,angleB=180,rad=0"

    for (i, row) in enumerate(F[0:-1]):

        next_row = F[i+1]
        
        plt.annotate("",
                    xy=(row[0], row[1]), xycoords='data',
                    xytext=(next_row[0], next_row[1]), textcoords='data',
                    arrowprops=dict(arrowstyle="-", color=color,
                                    patchA=None, patchB=None,
                                    connectionstyle=connectionstyle,
                                    ),
                    )






