library(SLOPE)
library(directlabels)
library(tactile)

fit <- SLOPE(as.matrix(heart$x), heart$y, q = 0.2, path_length = 100)

pdf("figures/slope-path.pdf", width = 3, height = 4)
trellis.par.set(tactile::tactile.theme(c(8, 4)))
plot(fit, auto.key = FALSE, x_variable = "step")
dev.off()

knitr::plot_crop("figures/slope-path.pdf")
