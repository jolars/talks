using Plots
using LaTeXStrings
using Parquet2
using DataFrames
using StatsPlots
using TableOperations

gr()

default(fontfamily="Computer Modern")

ds = Parquet2.Dataset("data/pgd-vs-cd-lasso.parquet")

obj_fun = function (x)
  return x .- minimum(x)
end

df = ds |>
     TableOperations.select(:solver_name, :data_name, :time, :objective_value) |>
     DataFrame

df = transform(df, :)

df.solver_name[df.solver_name.=="Python-PGD[use_acceleration=True]"] .= "PGD"
df.solver_name[df.solver_name.=="cd"] .= "CD"
df.data_name[df.data_name.=="libsvm[dataset=rcv1.binary]"] .= "RCV1"
df.data_name[df.data_name.=="libsvm[dataset=news20.binary]"] .= "news20"

suboptim(x) = x .- minimum(x) .+ 1e-10

gdf = groupby(df, :data_name)

pls = []

for df in gdf
  title = unique(df.data_name)[1]
  pl = @df df plot(
    :time,
    suboptim(:objective_value),
    group=:solver_name,
    yaxis=:log,
    title = title,
    xlabel="Time (s)",
    ylabel="Suboptimality"
  )
  push!(pls, pl)
end

# pls = [@df df plot(:time, suboptim(:objective_value), group=:solver_name, yaxis=:log, xlabel="Time (s)", title="Same", ylabel="Suboptimality") for df in gdf]
#
plot(
  pls...,
  layout=(2, 1),
  thickness_scaling=0.5,
  left_margin=Plots.cm,
  size=(150, 175),
  top_margin=Plots.mm,
  bottom_margin=0.5Plots.cm
)

path = "figures/cd-vs-pgd.pdf"

savefig(path)

# crop the figure
cmd = `pdfcrop $path $path`
run(cmd)

# @df df2 plot(
#   :time,
#   :objective_value_suboptim,
#   group = (:solver_name, :data_name),
#   yaxis=:log,
#   layout = 2,
#   legend=false,
#   ylabel="Suboptimality",
#   xlabel="Time (s)"
# )
#
#
