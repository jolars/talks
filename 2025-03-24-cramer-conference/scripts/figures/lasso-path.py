import matplotlib.pyplot as plt
import numpy as np
from matplotlib.colors import ListedColormap
from sklearn import datasets, linear_model

from pythesis.utils import FULL_WIDTH, PAL, save_fig, set_default_plot_settings

set_default_plot_settings()

diabetes = datasets.load_diabetes()
X = diabetes.data
y = diabetes.target

alphas, _, coefs = linear_model.lars_path(X, y, method="lasso", verbose=True)

coefs = coefs[:, 0:5]
alphas = alphas[0:5]

xx = np.sum(np.abs(coefs.T), axis=1)
xx /= xx[-1]

fig = plt.figure(figsize=(2, 1.4), layout="constrained")
ax = fig.gca()

ymin = np.min(coefs)
ymax = np.max(coefs)
plt.vlines(xx, ymin, ymax, linestyle="dotted", color="lightgrey")

cmap = ListedColormap(PAL)

for i in range(coefs.shape[0]):
    plt.plot(xx, coefs[i], color=PAL[i])

plt.xlabel(r"$\lambda$")
plt.ylabel(r"$\hat{\boldsymbol{\beta}}$")

save_fig("paper3-lasso-path.pdf")

plt.close("all")
