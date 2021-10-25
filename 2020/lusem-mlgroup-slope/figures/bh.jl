using Plots
using Random
using PGFPlotsX
using LaTeXStrings
using Distributions

Random.seed!(0)

n = 50

dist = Beta(0.3, 0.3)

q = 0.1

p = sort(rand(dist, n))

ivq = (1:n)*q/n

iv = (1:n)/n

plot(iv, ivq)
scatter!(iv, p)

pl = @pgf Axis(
    Plot(Coordinates(iv, ivq)),
    LegendEntry("BH"),
    PlotInc(Coordinates(iv, p)),
    LegendEntry("OSCAR")
)
pl
