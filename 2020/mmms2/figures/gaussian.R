library(strong.SLOPE.simulations)
library(tidyverse)
library(lattice)
library(tactile)
library(latticeExtra)

sim_gaussian_correlated <- sim_efficiency_gaussian_correlated %>%
  mutate(rho = as.factor(rho)) %>%
  rename(active = active_true,
         screened = active_screened)

thm <- tactile.theme(c(8, 4))
thm <- modifyList(thm, list(superpose.line = list(col = c(1, 1), lty = c(1, 2))))

pdf("figures/gaussian.pdf", width = 5, height = 2.4)
xyplot(screened + active ~ sigma | rho,
       data = sim_gaussian_correlated,
       grid = TRUE,
       layout = c(3, 1),
       xlab = expression(sigma/max((sigma))),
       ylab = "number of predictors",
       lattice.options = ,
       xlim = rev(extendrange(sim_gaussian_correlated$sigma)),
       par.settings = thm,
       type = "l",
       strip = strip.custom(strip.names = c(TRUE, TRUE),
                            var.name = expression(rho)),
       auto.key = list(points = FALSE, lines = TRUE, columns = 2))
dev.off()
