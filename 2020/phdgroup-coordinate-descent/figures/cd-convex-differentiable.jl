using Plots
using LaTeXStrings
pyplot()
#pgfplotsx()


f(x, y) = 5*x^2 - 6*x*y + 5*y^2

x = -1.5:0.1:1.5
y = -1.5:0.1:1.5
z = f.(x,y')

contour(x, y, f, legend = false, size = (200, 180), thickness_scaling = 0.8)

x = [-0.5]
y = [-1.5]

k = 1

for i in 1:10
    global x = [x; (6/10)*y[k]]
    global y = [y; y[k]]

    global k += 1

    global y = [y; (6/10)*x[k]]
    global x = [x; x[k]]

    global k += 1
end

plot!(x, y, label = false)
scatter!(x, y, markercolor = :orange, label = false)
xlabel!(L"x_1")
ylabel!(L"x_2")

savefig("figures/cd-convex-differentiable.pdf")

f(x, y) = abs(x + y) + 5*abs(y - x)

x = -1:0.01:1
y = -1:0.01:1
z = f.(x,y')

contour(x, y, f, levels = 12, legend = false, size = (200, 180),
        thickness_scaling = 0.8)
scatter!([-0.8], [-0.8])

xlabel!(L"x_1")
ylabel!(L"x_2")

savefig("figures/cd-non-differentiable.pdf")
