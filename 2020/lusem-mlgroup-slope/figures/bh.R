set.seed(1)

p <- 25
n <- 1000

q <- 0.1
sigma <- 1
X <- matrix(rnorm(n*p), n)
X <- scale(X, scale = apply(X, 2, norm, "2"))

beta <- sort(rbeta(p, 0.3, 0.3), decreasing = TRUE)*5
y <- X %*% beta + rnorm(n, 0, sigma^2)

beta_hat <- sort(abs(crossprod(X, y)), decreasing = TRUE)

qi <- (1:p)*q/(2*p)

i_bh <- which(beta_hat/sigma > qnorm(1 - qi))
i_bh <- i_bh[length(i_bh)]
l <- c(rep("accept", i_bh), rep("reject", p - i_bh))
i <- 1:p

library(tactile)
library(latticeExtra)

pdf("figures/bh.pdf", width = 3, height = 3)

trellis.par.set(tactile.theme(c(8, 4)))
trellis.par.set(superpose.symbol = list(pch = 19, col = c(1, "dark gray")))

xyplot(beta_hat ~ 1:p, group = l,
       ylab = expression(group("|", hat(beta), "|")),
       xlab = expression(i),
       auto.key = list(x = 0.70, y = 0.95),
       panel = function(...) {
         panel.lines(i, qnorm(1 - qi), col = 1, lty = 2)
         panel.text(21, 2.3, expression(sigma*Phi^{-1}*bgroup("(", 1 - frac(iq, 2*p),")")))
         panel.xyplot(...)
       })
dev.off()
knitr::plot_crop("figures/bh.pdf")
