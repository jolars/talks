using Plots
using PGFPlotsX
using Distributions
using LaTeXStrings

n = 350
p = 100

x = 1:p
bh = zeros(p)
gaussian = zeros(p)
oscar = zeros(p)

s = 0

d = Normal()

for i in 1:p
    bh[i] = quantile(d, 1 - 0.2*i/(2*p))
    oscar[i] = 0.01*(p - i) + 1.5
    if (i == 1)
        gaussian[i] = bh[i]
    else
        gaussian[i] = min(gaussian[i-1], bh[i]*sqrt(1 + s/(n-i)))
    end
    global s += gaussian[i]^2
end

pl = @pgf Axis(
    {
        "no marks",
    },
    PlotInc(Coordinates(x, bh)),
    LegendEntry("BH"),
    #PlotInc(Coordinates(x, oscar)),
    #LegendEntry("OSCAR"),
    PlotInc(Coordinates(x, gaussian)),
    LegendEntry("Gaussian")
)

pgfsave("figures/lambda-paths.tikz", pl)
