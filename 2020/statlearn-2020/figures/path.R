library(SLOPE)


fit <- SLOPE(heart$x, heart$y)
pdf("figures/path.pdf", width = 2.4, height = 2.2)
plot(fit, auto.key = FALSE,
     par.settings = tactile::tactile.theme(fontsize = c(8, 4)))
dev.off()
