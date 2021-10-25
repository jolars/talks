using Plots
using PGFPlotsX
using LaTeXStrings

f(x, λ) = sign(x)*clamp(abs(x) - λ, 0, Inf)

x = range(-2, 2, length = 100)

pl = @pgf Axis(
    {
        xlabel = L"x",
        ylabel = L"S(x;\lambda)",
        xmin = -3,
        xmax = 3
    },
    Plot(
        {
            no_marks,
            gray
        },
        Expression("0.0")
    ),
    Plot(
        {
            no_marks,
        },
        Coordinates(x, sign.(x).*clamp.(abs.(x) .- 0.5, 0, Inf))
    )
)

pgfsave("figures/soft-thresholding.tikz", pl)