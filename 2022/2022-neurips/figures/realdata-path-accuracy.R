library(readr)
library(dplyr)
library(tidyr)
library(here)
library(ggplot2)
library(cowplot)

d_raw <- read_rds(here("results", "realdata-path-accuracy.rds"))

options(
  tikzDocumentDeclaration =
    "\\documentclass[10pt]{beamer}\n"
)

d1 <-
  d_raw %>%
  select(-new_active_target) %>%
  unnest(c(step, new_active))

d2 <-
  d_raw %>%
  select(-new_active) %>%
  unnest(c(step, new_active_target))

pl <- ggplot(d1, aes(step, new_active_cumsum, color = method)) +
  geom_line(
    aes(step, new_active_target_cumsum),
    inherit.aes = FALSE,
    data = d2
  ) +
  geom_line() +
  facet_wrap("dataset")


d <- tibble(
  method = rep(c("adaptive", "grid"),
    times = c(
      length(fit_adaptive$lambda),
      length(fit_standard$lambda)
    )
  ),
  new_active = c(
    cumsum(fit_adaptive$new_active),
    cumsum(fit_standard$new_active)
  ),
  step = c(
    seq_len(length(fit_adaptive$lambda)),
    seq_len(length(fit_standard$lambda))
  )
)

target <- tibble(
  desired_active = cumsum(fit_adaptive$new_active_target),
  step = 1:length(desired_active)
)

ggplot(d, aes(step, new_active, color = method)) +
  geom_line(aes(step, desired_active),
    inherit.aes = FALSE,
    data = target, lty = 2
  ) +
  geom_line() +
  theme_half_open() +
  labs(x = "Step", y = "Active Predictors")
