library(strong.SLOPE.simulations)
library(tidyverse)
library(lattice)
library(tactile)
library(latticeExtra)
library(directlabels)

tmp <- sim_performance_alg %>%
  group_by(rho, alg) %>%
  summarise(xbar = mean(time),
            n = n(),
            se = sd(time)/sqrt(n()),
            lo = xbar - qt(0.975, n-1)*se,
            hi = xbar + qt(0.975, n-1)*se)

pdf("figures/algorithms.pdf", width = 3, height = 3)
pl <- xyplot(xbar ~ rho,
             groups = alg,
             type = "l",
             xlab = expression(rho),
             ylab = "time (s)",
             lower = tmp$lo,
             upper = tmp$hi,
             data = tmp,
             prepanel = prepanel.ci,
             par.settings = tactile.theme(c(8, 4)),
             auto.key = list(space = "right",
                             lines = TRUE,
                             points = FALSE),
             panel = function(...) {
               panel.ci(...)
               panel.xyplot(...)
             })
direct.label(pl, "angled.boxes")
dev.off()
