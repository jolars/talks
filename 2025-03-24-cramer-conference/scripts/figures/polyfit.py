import matplotlib.pyplot as plt
import numpy as np

from pythesis.utils import FULL_WIDTH, PAL, save_fig, set_default_plot_settings

set_default_plot_settings()

pal = PAL

np.random.seed(4)

n = 30
n_new = 5

x = np.random.rand(n)
y = 2 * x + np.random.randn(n) * 0.5

x_new = np.random.rand(n_new)
y_new = 2 * x_new + np.random.randn(n_new) * 0.5

degrees = [0, 1, 2, 4, 8, 16]

n_degrees = len(degrees)

for i, degree in enumerate(degrees):
    fig, axs = plt.subplots(
        1,
        1,
        figsize=(1.9, 1.9),
        sharex=True,
        sharey=True,
        layout="constrained",
    )

    coefficients = np.polyfit(x, y, degree)
    polynomial = np.poly1d(coefficients)

    x_fit = np.linspace(
        np.min(np.hstack([x, x_new])), np.max(np.hstack([x, x_new])), 500
    )
    y_fit = polynomial(x_fit)

    axs.scatter(x, y, color="black")
    axs.scatter(x_new, y_new, color=pal[0])
    axs.plot(x_fit, y_fit, color=pal[1])
    axs.set_title("Degree " + str(degree))
    axs.set_xlabel(r"$\boldsymbol{x}$")
    axs.set_yticklabels([])
    axs.set_xticklabels([])
    axs.set_yticks([])
    axs.set_xticks([])
    axs.set_ylabel(r"$\boldsymbol{y}$")
    axs.set_ylim([-1, 3])

    save_fig(f"polyfit-{i}.pdf")

plt.close("all")
