library(lars)
library(glmnet)
library(tikzDevice)

source("R/utils.R")

n <- 200
p <- 5
rho <- 0.7

set.seed(3)

des <- generateDesign(n, p, rho = rho, rho_type = "auto", beta_type = 3)

X <- des$X
y <- des$y

fit <- lars(X, y)

plot(fit, main = NULL)

beta_hat <- as_tibble(coef(fit))

rownames(beta_hat) <- c(fit$lambda, 0)

library(tidyverse)

beta_hat_long <- 
  beta_hat %>%
  rownames_to_column() %>%
  pivot_longer(-rowname) %>%
  mutate(rowname = as.numeric(rowname)) 

changes <- tibble(lambda = fit$lambda)

fn <- "figures/lasso-path.tex"

tikz(fn, width = 2.1, height = 1.7, standAlone = TRUE)
beta_hat_long |>
  ggplot(aes(rowname, value, color = name)) +
  geom_hline(yintercept = 0, color = "grey") +
  geom_vline(
    aes(xintercept = lambda),
    lty = 3,
    col = "grey",
    data = changes
  ) +
  geom_line() +
  guides(color = "none") +
  labs(x = "$\\lambda$", y = "$\\beta$") +
  theme_classic()
dev.off()
renderPdf(fn)
