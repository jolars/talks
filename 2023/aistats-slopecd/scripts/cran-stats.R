library(ggplot2)
library(dlstats)
library(tikzDevice)

data <- cran_stats(c("glmnet", "SLOPE"))

path <- file.path("data", "cran-stats.csv")

write.csv(data, path)

# fig_path <- file.path("figures", "cran-stats.tex")
#
# tikz(fig_path, width = 3, height = 2.5)
# ggplot(data, aes(end, downloads, group = package, color = package)) +
#   geom_line() +
#   theme_minimal(base_size = 9) +
#   theme(legend.position = c(0.15, 0.9)) +
#   scale_y_continuous(labels = scales::comma) +
#   labs(x = "Time", y = "Downloads", color = NULL)
# dev.off()
