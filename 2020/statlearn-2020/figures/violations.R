library(strong.SLOPE.simulations)
library(tidyverse)
library(lattice)
library(tactile)
library(latticeExtra)

d_violations_gaussian_correlated <-
  as_tibble(sim_violations_gaussian_correlated) %>%
  mutate(p = as.factor(p),
         method = as.factor(method)) %>%
  group_by(method, p, sigma_ratio) %>%
  arrange(desc(sigma_ratio)) %>%
  summarise(mean_viol = mean(n_violations > 0)) %>%
  filter(method != "safe")

thm <- tactile.theme(c(8, 4))

pdf("figures/violations.pdf", width = 5, height = 1.8)
xyplot(mean_viol ~ sigma_ratio | p,
       layout = c(5, 1),
       type = "h",
       col = 1,
       lex = 0.5,
       xlim = c(1.25, 0.008),
       strip = strip.custom(strip.names = c(T, T)),
       auto.key = list(lines = TRUE, points = FALSE, columns = 2),
       xscale.components = xscale.components.log,
       scales = list(x = list(log = "e")),
       par.settings = thm,
       xlab = expression(sigma/max((sigma))),
       ylab = "fraction of fits with violations",
       data = d_violations_gaussian_correlated)
dev.off()
