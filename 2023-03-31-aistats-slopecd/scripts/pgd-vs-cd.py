import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from labellines import labelLines

from pythesis.utils import save_fig


def suboptim(x):
    return x - np.min(x) + 1e-10


data = pd.read_parquet("data/pgd-vs-cd-lasso.parquet")
data = data.filter(items=["data_name", "objective_value", "solver_name", "time"])

data["solver_name"].replace("Python-PGD[use_acceleration=True]", "PGD", inplace=True)
data["solver_name"].replace("cd", "CD", inplace=True)


news20 = data.query("data_name == 'libsvm[dataset=news20.binary]'").copy()
rcv1 = data.query("data_name == 'libsvm[dataset=rcv1.binary]'").copy()

news20["objective_value"] = suboptim(news20["objective_value"])
rcv1["objective_value"] = suboptim(rcv1["objective_value"])
# news20["objective_value"] = news20["objective_value"] - np.min(news20["objective_value"])

fig, axs = plt.subplots(
    1, 2, figsize=(3.5, 1.8), sharey=True, constrained_layout=True, edgecolor="white"
)

for key, grp in news20.groupby(["solver_name"]):
    axs[0].semilogy(grp["time"], grp["objective_value"], label=key)

for key, grp in rcv1.groupby(["solver_name"]):
    axs[1].semilogy(grp["time"], grp["objective_value"], label=key)

axs[0].set_title("news20")
axs[0].set_ylabel("Suboptimality")

axs[1].set_title("RCV1")

fig.supxlabel("Time (s)")

for i in range(2):
    labelLines(axs[i].get_lines())

path = "paper5-cd-vs-pgd.pdf"

save_fig(path)

plt.close("all")
