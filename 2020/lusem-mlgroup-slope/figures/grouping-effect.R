library(glmnet)
library(SLOPE)
library(tidyverse)
library(lattice)
library(latticeExtra)
library(tactile)

thm <- tactile::tactile.theme(c(8, 4))

p <- 20
n <- 100

Sigma <- matrix(0, p, p)

rho <- 0.9

Sigma[1:5, 1:5] <- rho
Sigma[6:10, 6:10] <- rho
Sigma[1:5, 6:10] <- -rho
Sigma[6:10, 1:5] <- -rho

diag(Sigma) <- 1

x <- mvtnorm::rmvnorm(n, sigma = Sigma)

beta <- double(p)
beta[1:5] <- 1
beta[1:5] <- -1
beta[11:20] <- 0.01

y <- x %*% beta + rnorm(n)

slope_fit <- SLOPE(x, y, lambda = "bh", path_length = 100, scale = "sd")
lasso_fit <- glmnet(x, y)

s <- coef(slope_fit)[-1, ]
l <- coef(lasso_fit)[-1, ]
d <- tidyr::pivot_longer(tibble::as_tibble(as.matrix(l)), everything())

d <- data.frame(beta = c(as.double(l), as.double(s)),
                var = rep(1:p, times = ncol(l) + ncol(s)),
                pen = c(rep(1:ncol(l), each = p), rep(1:ncol(s), each = p)),
                mod = rep(c("lasso", "SLOPE"), times = c(ncol(l)*p, ncol(s)*p)))
nm <- "figures/grouping-effect.pdf"
pdf(nm, width = 3.3, height = 5)
trellis.par.set(thm)
xyplot(beta ~ pen | mod, groups = var, data = d, type = "l",
       xlab = "step",
       layout = c(1, 2), ylab = expression(hat(beta)))
dev.off()
knitr::plot_crop(nm)

#plot(slope_fit)

#plot(lasso_fit)


cols <- colorRampPalette(RColorBrewer::brewer.pal(11, "RdBu"), interpolate = "spline")(99)
cols <- cols[15:85]
cols[50] <- "white"

pdf("figures/grouping-effect-sigma.pdf", width = 3, height = 3)
trellis.par.set(thm)
levelplot(Sigma, col.regions = cols, xlab = expression(Sigma), ylab = expression(Sigma))
dev.off()
knitr::plot_crop("figures/grouping-effect-sigma.pdf")
