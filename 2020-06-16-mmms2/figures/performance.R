library(strong.SLOPE.simulations)
library(tidyverse)
library(lattice)
library(tactile)
library(latticeExtra)

d_perf_sim <- as_tibble(sim_performance_simulated_data) %>%
  mutate(screening = factor(screening,
                            c(T, F),
                            c("screening", "no screening")),
         family = fct_recode(family,
                             OLS = "gaussian",
                             logistic = "binomial"),
         correlation = as.factor(correlation))

thm <- tactile.theme(c(8, 4))
thm <- modifyList(thm, list(plot.symbol = list(col = 1)))

pdf("figures/performance.pdf", width = 5*1.1, height = 3*1.1)
bwplot2(correlation ~ time | family,
        data = d_perf_sim,
        groups = screening,
        layout = c(1, 4),
        xlab = "time (s)",
        ylab = expression(rho),
        strip.left = TRUE,
        strip = FALSE,
        par.settings = thm,
        scales = list(x = list(relation = "free", log = 10)),
        xscale.components = xscale.components.log10ticks,
        auto.key = list(space = "top", columns = 2))
dev.off()
