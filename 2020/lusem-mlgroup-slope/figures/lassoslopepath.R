library(SLOPE)
library(glmnet)
library(tactile)
library(latticeExtra)
library(tidyverse)

set.seed(1)

n <- 100
p <- 15
rho <- c(0, 0.5, 0.9)
len <- 100

l <- list()
s <- list()

d <- data.frame()

for (i in seq_along(rho)) {
  xy <- SLOPE:::randomProblem(n, p, rho = rho[i], amplitude = 2)

  l <- SLOPE(xy$x, xy$y, lambda = "bh", path_length = len, max_variables = n*2)

  d <- rbind(d,
             data.frame(rho = rho[i],
                        penalty = "lasso",
                        beta = as.vector(coef(l)[-1, ]),
                        coef = 1:p,
                        step = rep(1:ncol(coef(l)), each = p)
             ))

  s <- SLOPE(xy$x, xy$y, lambda = rep(1, p), path_length = len, max_variables = n*2)

  d <- rbind(d,
             data.frame(rho = rho[i],
                        penalty = "SLOPE",
                        beta = as.vector(coef(s)[-1, ]),
                        coef = 1:p,
                        step = rep(1:ncol(coef(s)), each = p)
             ))
}


pl <- xyplot(beta ~ step | rho + penalty, groups = coef, data = d, type = "l",
             ylab = expression(hat(beta)))


pdf("figures/lassoslopepath.pdf", width = 5, height = 2.8)
useOuterStrips(pl, strip = strip.custom(strip.levels = c(T, T)))
dev.off()
knitr::plot_crop("figures/lassoslopepath.pdf")
