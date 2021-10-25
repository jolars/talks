library(SLOPE)
library(tactile)
library(latticeExtra)
library(grid)

set.seed(1)
xy <- SLOPE:::randomProblem(n = 200, p = 20000, amplitude = 0.4, q = 0.01)

fit <- SLOPE(xy$x, xy$y, lambda = "oscar")
coefs <- coef(fit)
nz <- colSums(coefs != 0)
sigma <- as.vector(fit$sigma)

# interpolate
interp <- approx(sigma, nz, n = 10)
sigma_new <- interp$x
nz_new <- floor(interp$y)

pdf("figures/slope-path.pdf", width = 2.7, height = 2.7, pointsize = 8)
trellis.par.set(tactile::tactile.theme(
  c(8, 4),
  superpose.line = list(
    col = 1
  ),
  layout.heights = list(
    axis.top = 3
  ),
  axis.components = list(
    top = list(
      tck = 0
    )
  )
))

plot(fit, auto.key = FALSE, alpha = 0.3, lty = 1,
     panel = function(x, y, ...) {
       panel.xyplot(x, y, ...)
       xscale <- convertX(unit(0:1, "npc"), "native", valueOnly=TRUE)
       yscale <- convertY(unit(0:1, "npc"), "native", valueOnly=TRUE)
       pushViewport(viewport(clip = "off",
                             xscale = xscale, yscale = yscale))
       panel.axis(side = "top",
                  labels = as.character(nz_new),
                  at = sigma_new,
                  rot = 0,
                  outside = TRUE)
       panel.text(mean(sigma_new),
                  0.85,
                  labels = "number of nonzero coefficients",
                  rot = 0,
                  outside = TRUE)
       popViewport()
     })
dev.off()
