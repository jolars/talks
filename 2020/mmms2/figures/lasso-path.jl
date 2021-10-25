using GLMNet
using Colors
using PGFPlotsX
using Random
Random.seed!(123);

n = 100
p = 10

X = randn(Float64, (n, p))
beta = randn(Float64, p)

y = X*beta + randn(n)

path = glmnet(X, y, intercept = false, standardize = false)
m = size(path.betas, 2)
lambda = path.lambda

grad = Array{Float64, 2}(undef, p, m)

for i in 1:m
    grad[:, i] = X' * (X*path.betas[:, i] - y)/n
end

pl = plot(lambda, grad[1, :])

for i in 2:p
    plot!(pl, lambda, grad[i, :])
end
pl


k = 4

@pgf axis = Axis(
    {
        xlabel = raw"$\lambda$",
        ylabel = raw"$\nabla g(\hat\beta)$",
        width = raw"8.5cm",
        ymax = 2.4,
        ymin = -2.4,
        xmax = 2.4
    },
    VLine({ dashed }, lambda[k]),
    VLine({ dashed }, lambda[k-1]),
    #HLine({}, 2*lambda[k] - lambda[k-1]),
    #HLine({}, -2*lambda[k] + lambda[k-1]),
    Plot({dotted}, Coordinates([(0,0), (4, 4)])),
    Plot({dotted}, Coordinates([(0,0), (4, -4)])),
    [raw"\node ", {"left"}, " at ", Coordinate(lambda[k], -2), raw"{$\lambda^{(k)}$};"],
    [raw"\node ", {"right"}, " at ", Coordinate(lambda[k-1], -2), raw"{$\lambda^{(k-1)}$};"],
    [raw"\draw ", {"decorate","decoration={brace}","xshift=2pt"},
     Coordinate(lambda[k-1],2*lambda[k] - lambda[k-1]),
     "--",
     Coordinate(lambda[k-1],-2*lambda[k] + lambda[k-1]),
     raw"node [right,black,midway]{\footnotesize strong bound};]"]
)
@pgf for (i, col) in enumerate(distinguishable_colors(p))
    pl = Plot(
        {
            color = col
        },
        Table([lambda, grad[i, :]])
    )
    push!(axis, pl)
end

axis
pgfsave("figures/lasso-path.tikz", axis)
