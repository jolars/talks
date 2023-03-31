import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib import dates
from labellines import labelLine, labelLines

data = pd.read_csv("data/cran-stats.csv")

data["end"] = pd.to_datetime(data["end"])

glmnet = data.query("package == 'glmnet'").filter(items=["end", "downloads"])
slope = data.query("package == 'SLOPE'").filter(items=["end", "downloads"])

plt.close("all")

plt.rcParams["text.usetex"] = True

plt.rcParams["font.size"] = 8

fig, ax = plt.subplots(1, 1, figsize=(1.7, 1.5))

ax.plot(glmnet["end"], glmnet["downloads"], label = "glmnet")
ax.plot(slope["end"], slope["downloads"], label = "SLOPE")

ax.set_ylabel("Downloads")
ax.set_xlabel("Time")

fig.autofmt_xdate()

labelLines(ax.get_lines(), align=True)

plt.show(block=False)

path = "figures/cran-stats.pdf"

fig.savefig(path, bbox_inches="tight", pad_inches=0.01)

