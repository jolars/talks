using Plots
using LaTeXStrings
using CSV
using DataFrames
using StatsPlots
using Dates

gr()

data = CSV.read(open("data/cran-stats.csv"), DataFrame)

default(fontfamily="Computer Modern")

year_fun = x -> Dates.format(Date(Dates.UTD(x)), "yyyy")

@df data plot(
  :end,
  :downloads,
  group=:package,
  size=(170, 130),
  thickness_scaling=0.5,
  xlabel="Time",
  ylabel="Downloads",
  yformatter=:plain
)

plot!(xformatter=year_fun)

path = "figures/cran-stats.pdf"

savefig(path)

# crop the figure
cmd = `pdfcrop $path $path`
run(cmd)
