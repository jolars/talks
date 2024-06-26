library(tibble)
library(tidyr)
library(dplyr)
library(forcats)
library(lattice)
library(latticeExtra)
library(tactile)
library(tikzDevice)
library(ggplot2)

source("R/utils.R")

theme_set(theme_minimal(base_size = 9))

d_raw <- readRDS("results/simulateddata.rds") %>%
  filter(screening_type != "strong") %>%
  mutate(
    screening_type = recode(
      screening_type,
      "hessian" = "Hessian",
      "working" = "Working",
      "gap_safe" = "Gap Safe",
      "edpp" = "EDPP"
    ),
    rho = as.factor(rho),
    np = paste0("$n=", n, "$, $p=", p, "$"),
    np = reorder(np, p),
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
    se = sd(time / n())
  ) %>%
  mutate(
    hi = meantime + se,
    lo = meantime - se,
    rel_time = meantime / min(meantime)
  ) %>%
  drop_na(meantime)

cols <- c(
  "#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7"
)

file <- "figures/simulateddata-timings.tex"
tikz(file, width = 4.3, height = 2.5, standAlone = TRUE)
ggplot(d1, aes(
  rho,
  rel_time,
  fill = screening_type
)) +
  geom_col(position = "dodge", col = 1) +
  facet_wrap(c("family", "np"), nrow = 1) +
  scale_fill_manual(values = cols[1:5]) +
  labs(
    fill = "Screening",
    x = "Correlation ($\\rho$)",
    y = "Time"
  ) +
  theme(legend.position = c(0.1, 0.7), legend.title = element_blank())
dev.off()

renderPdf("figures/simulateddata-timings.tex")
