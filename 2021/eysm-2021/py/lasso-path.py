import numpy as np
import matplotlib.pyplot as plt

from sklearn import linear_model
from sklearn import datasets


def set_size(width, fraction=1):
    """Set figure dimensions to avoid scaling in LaTeX.

    Parameters
    ----------
    width: float
            Document textwidth or columnwidth in pts
    fraction: float, optional
            Fraction of the width which you wish the figure to occupy

    Returns
    -------
    fig_dim: tuple
            Dimensions of figure in inches
    """
    # Width of figure (in pts)
    fig_width_pt = width * fraction

    # Convert from pt to inches
    inches_per_pt = 1 / 72.27

    # Golden ratio to set aesthetic figure height
    # https://disq.us/p/2940ij3
    golden_ratio = (5**.5 - 1) / 2

    # Figure width in inches
    fig_width_in = fig_width_pt * inches_per_pt
    # Figure height in inches
    fig_height_in = fig_width_in * golden_ratio

    fig_dim = (fig_width_in, fig_height_in)

    return fig_dim


plt.style.use('tableau-colorblind10')

X, y = datasets.load_diabetes(return_X_y=True)

lam, ord, coefs = linear_model.lars_path(X, y, method='lasso', verbose=True)

xx = np.sum(np.abs(coefs.T), axis=1)
xx /= xx[-1]

width = 345

fig, ax = plt.subplots(figsize=(4, 3))

plt.plot(xx, coefs.T, linewidth=1)
ymin, ymax = plt.ylim()

#plt.vlines(xx, ymin, ymax, colors="grey", alpha=0.3)
plt.xlabel(
    '$\\frac{\\lVert \\hat \\beta \\rVert_1}{\\max \\lVert \\hat\\beta \\rVert_1}$'
)
plt.ylabel("$\\hat\\beta$")

#plt.show()

plt.savefig("images/lasso-path.pdf", bbox_inches='tight', pad_inches=0)
