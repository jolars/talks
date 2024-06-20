library(ggplot2)
library(dplyr)
library(tidyr)
library(tikzDevice)

recode_methods <- function(x) {
  screening_type <- factor(
    x,
    levels = c(
      "hessian",
      "working",
      "celer",
      "blitz",
      "strong",
      "edpp",
      "gap_safe",
      "sasvi"
    ),
    labels = c(
      "Hessian",
      "Working",
      "Celer",
      "Blitz",
      "Strong",
      "EDPP",
      "Gap Safe",
      "Sasvi"
    )
  )
}

rho_labeller <- function(labels, multi_line = TRUE, sep = ":", ...) {
  value <- label_value(labels, multi_line = multi_line)
  out <- paste0("$\\rho = ", value, "$")
  #  list(unname(unlist(out)))
  out
}


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

d_raw <- readRDS("data/efficiency-simulateddata.rds") %>%
  as_tibble()

theme_set(theme_minimal(base_size = 9))

fig_width <- 5.6
fig_width_small <- 3.35
fig_height <- 4.5
fig_height_small <- 1.5

cols <- c(
  "black", "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7"
)

options(
  tikzDocumentDeclaration =
    "\\documentclass[10pt]{beamer}\n\\usepackage{lmodern}\n"
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
  filter(rho == 0.8) %>%
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

d_active_small <-
  d_small %>%
  ungroup() %>%
  group_by(rho, step) %>%
  summarize(avg_active = min(active, na.rm = TRUE))

f <- "figures/hessian-simulateddata-efficiency.tex"
tikz(f, width = 2.8, height = 2.3, standAlone = TRUE)
ggplot(d_small) +
  geom_line(
    aes(x = step, y = avg_active),
    lty = 2,
    data = d_active_small
  ) +
  geom_line(aes(step, screened, color = screening_type)) +
  scale_color_manual(values = cols[-2]) +
  theme(legend.title = element_blank()) +
  scale_y_log10() +
  labs(y = "Number of features", x = "Step")
dev.off()
renderPdf(f)
