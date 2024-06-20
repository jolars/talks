library(tidyverse)
library(lattice)
library(tactile)
library(ggplot2)
library(latticeExtra)
library(directlabels)
library(tikzDevice)

renderPdf <- function(x) {
  wd <- getwd()
  on.exit({
    setwd(wd)
  })

  path <- normalizePath(dirname(x))

  full_file_path <- tools::file_path_as_absolute(x)
  file_wo_ext <- tools::file_path_sans_ext(basename(x))

  pdf_file <- paste0(file_wo_ext, ".pdf")

  # work in a temporary directory to avoid dealing with latex log files
  tmp_dir <- tempdir()
  setwd(tmp_dir)

  tools::texi2pdf(full_file_path)
  knitr:::plot_crop(pdf_file)
  file.copy(pdf_file, file.path(path, pdf_file), overwrite = TRUE)
}


load("data/strong-gaussian.rda")

options(
  tikzDocumentDeclaration =
    "\\documentclass[10pt]{beamer}\n\\usepackage{lmodern}\n"
)

sim_gaussian_correlated <-
  sim_efficiency_gaussian_correlated %>%
  mutate(rho = as.factor(rho)) %>%
  filter(rho == 0.2) %>%
  rename(
    Active = active_true,
    Screened = active_screened
  ) %>%
  select(sigma, screened, active) %>%
  pivot_longer(cols = c(screened, active), names_to = "type", values_to = "n")

f <- "figures/strong-efficiency-gaussian.tex"
tikz(f, width = 2.4, height = 2, standAlone = TRUE)
ggplot(sim_gaussian_correlated, aes(x = sigma, y = n, color = type, linetype = type)) +
  geom_line() +
  labs(
    x = "Regularization strength",
    y = "Number of features"
  ) +
  ylim(-100, 5050) +
  xlim(rev(extendrange(sim_gaussian_correlated$sigma))) +
  scale_linetype_manual(values = c("dashed", "solid")) +
  scale_color_manual(values = c("black", "dark orange")) +
  theme(legend.position = c(0.8, 0.9)) +
  labs(color = NULL, linetype = NULL)
dev.off()
renderPdf(f)
