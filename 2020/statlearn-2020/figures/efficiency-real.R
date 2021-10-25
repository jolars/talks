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

d_efficiency_violations_real <- sim_efficiency_violations_real_data
colnames(d_efficiency_violations_real) <-
  c("dataset",
    "response",
    "n",
    "p",
    "penalty",
    "violations",
    "screened",
    "active",
    "unique",
    "KKT")
d_efficiency_violations_real_frac <-
  as_tibble(d_efficiency_violations_real) %>%
  mutate(fraction = active/p,
         screened = screened/p,
         active = active/p,
         response = fct_recode(response,
                               OLS = "gaussian",
                               logistic = "binomial"))

thm <- tactile.theme(c(8, 4))
thm <- modifyList(thm, list(superpose.line = list(col = 1, lty = c(1, 2))))

pdf("figures/efficiency-real.pdf", width = 5, height = 3)
p <- xyplot(screened + active ~ penalty | response + dataset,
            ylab = "fraction of predictors",
            xlab = "penalty index",
            par.settings = thm,
            auto.key = list(lines = TRUE, points = FALSE, space = "top",
                            columns = 2),
            data = d_efficiency_violations_real_frac,
            type = "l")
useOuterStrips(p)
dev.off()
