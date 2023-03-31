library(ggplot2)
library(dplyr)
library(tidyr)
library(tikzDevice)

source("R/utils.R")

d_raw <- readRDS("results/efficiency-simulateddata.rds") %>%
  as_tibble()

options(
  tikzDocumentDeclaration =
    "\\documentclass[10pt]{beamer}\n"
)

theme_set(theme_minimal(base_size = 9))

fig_width <- 4.3
fig_height <- 2.5

cols <- c(
  "black", "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7"
)

rho_labeller <- function(labels, multi_line = TRUE, sep = ":", ...) {
  value <- label_value(labels, multi_line = multi_line)
  out <- paste0("$\\rho = ", value, "$")
  #  list(unname(unlist(out)))
  out
}

d <-
  d_raw %>%
  group_by(family, rho, screening_type, it) %>%
  filter(screened != 0) %>%
  mutate(
    step = seq_along(screened),
    screening_type = recode_methods(screening_type),
    family = recode(
      family,
      "gaussian" = "Least-Squares",
      "binomial" = "Logistic"
    )
  ) %>%
  ungroup() %>%
  group_by(family, rho, screening_type, step) %>%
  summarize(screened = mean(screened), active = mean(active, na.rm = TRUE))

d_small <-
  d %>%
  filter(family == "Least-Squares")

d_active <-
  d %>%
  ungroup() %>%
  group_by(rho, step) %>%
  summarize(avg_active = min(active, na.rm = TRUE))

d_active_small <-
  d_small %>%
  ungroup() %>%
  group_by(rho, step) %>%
  summarize(avg_active = min(active, na.rm = TRUE))

rho_labeller2 <- function(labels, multi_line = TRUE, sep = ":", ...) {
  # value <- label_value(labels, multi_line = multi_line)
  out <- paste0("$\\rho = ", value, "$")
  #  list(unname(unlist(out)))
  out
}

rho_labeller2 <- function(value) paste0("$\\rho = ", value, "$")

f <- "figures/simulateddata-efficiency.tex"
tikz(f, width = fig_width, height = fig_height_small, standAlone = TRUE)
ggplot(d_small) +
  geom_line(
    aes(x = step, y = avg_active),
    size = 1,
    lty = 2,
    data = d_active_small
  ) +
  geom_line(aes(step, screened, color = screening_type), size = 1) +
  scale_color_manual(values = cols[-2]) +
  theme(legend.title = element_blank()) +
  scale_y_log10() +
  facet_grid(~rho, labeller = as_labeller(rho_labeller2)) +
  labs(y = "Predictors", x = "Step")
dev.off()
renderPdf(f)
