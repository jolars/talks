import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from labellines import labelLines


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

plt.close("all")

plt.rcParams["text.usetex"] = True
plt.rcParams["font.size"] = 8

fig, axs = plt.subplots(2, 1, figsize=(1.8, 2.4), sharex=True, constrained_layout=True)

for key, grp in news20.groupby(["solver_name"]):
    axs[0].semilogy(grp["time"], grp["objective_value"], label=key)

for key, grp in news20.groupby(["solver_name"]):
    axs[1].semilogy(grp["time"], grp["objective_value"], label=key)

axs[0].set_title("news20")

axs[1].set_title("RCV1")
axs[1].set_xlabel("Time (s)")

fig.supylabel("Suboptimality")

for i in range(2):
    labelLines(axs[i].get_lines(), align=True)

# ax.plot(glmnet["end"], glmnet["downloads"], label = "glmnet")
# ax.plot(slope["end"], slope["downloads"], label = "SLOPE")
#
# ax.set_ylabel("Downloads")
# ax.set_xlabel("Time")

plt.show(block=False)

path = "figures/cd-vs-pgd.pdf"

fig.savefig(path, bbox_inches="tight", pad_inches=0.01)

