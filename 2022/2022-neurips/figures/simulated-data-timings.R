library(tibble)
library(tidyr)
library(dplyr)
library(tikzDevice)
library(ggplot2)

source("R/utils.R")

theme_set(theme_minimal(base_size = 9))

options(
  tikzDocumentDeclaration =
    "\\documentclass[10pt]{beamer}\n"
)

fig_width <- 4.3
fig_height <- 2.5

conf_level <- 0.05

d_raw <- readRDS("results/simulateddata.rds") %>%
  filter(
    !(screening_type %in% c("strong", "edpp", "gap_safe")),
    converged == TRUE
  ) %>%
  mutate(
    screening_type = recode_methods(screening_type),
    rho = as.factor(rho),
    np = paste0("$n=", n, "$, $p=", p, "$"),
    np = reorder(np, p),
    family = recode(
      family,
      "gaussian" = "Least-Squares",
      "binomial" = "Logistic"
    )
  ) %>%
  select(np, n, p, rho, family, screening_type, time) %>%
  unnest(time)

d1 <-
  d_raw %>%
  mutate(
    screening_type = as.factor(screening_type),
    family = as.factor(family)
  ) %>%
  group_by(np, rho, family, screening_type) %>% 
  summarize(
    meantime = mean(time),
    se = sd(time) / sqrt(n()),
    ci = qnorm(1 - conf_level/2) * se
  ) %>%
  mutate(
    hi = meantime + ci,
    lo = meantime - ci,
    rel_time = meantime / min(meantime),
    hi = hi / min(meantime),
    lo = lo / min(meantime)
  ) %>%
  drop_na(meantime)

cols <- c(
  "#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7"
)

file <- "figures/simulateddata-timings.tex"
tikz(file, width = fig_width, height = fig_height, standAlone = TRUE)
ggplot(d1, aes(
  rho,
  rel_time,
  fill = screening_type
)) +
  geom_col(position = position_dodge(0.9), col = 1) +
  geom_errorbar(
    aes(ymin = lo, ymax = hi),
    position = position_dodge(0.9),
    width = 0.25
  ) +
  facet_wrap(c("family", "np"), nrow = 1) +
  scale_fill_manual(values = cols[1:5], guide = guide_legend(ncol = 4)) +
  labs(
    fill = "Screening",
    x = "Correlation ($\\rho$)",
    y = "Time (relative)"
  ) +
  theme(
    legend.position = c(0.7, 0.91),
    legend.title = element_blank(),
    panel.grid.major.x = element_blank(),
    legend.key.size = unit(0.9, "line")
  ) 
dev.off()
renderPdf(file)


