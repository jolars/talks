library(readr)
library(dplyr)
library(tidyr)
library(here)
library(ggplot2)
library(cowplot)
library(tikzDevice)

source(here("R", "utils.R"))

options(
  tikzDocumentDeclaration =
    "\\documentclass[10pt]{beamer}\n"
)

d_raw <- read_rds(here("results", "realdata-path-accuracy.rds"))

d <-
  d_raw %>%
  filter(method == "grid") %>%
  select(-family, -method, -time, -new_active_target) %>%
  unnest(c(step, new_active)) %>%
  group_by(dataset) %>%
  mutate(new_active_cumsum = cumsum(new_active)/sum(new_active))

pl <- ggplot(d, aes(step, new_active_cumsum)) +
  geom_line() +
  facet_wrap("dataset") + 
  theme_minimal(base_size = 9) +
  labs(x = "Step", y = "Active Predictors")

file <- here("figures", "grid-paths.tex")

tikz(file, width = 4.3, height = 1.6, standAlone = TRUE)
print(pl)
dev.off()

renderPdf(file)
