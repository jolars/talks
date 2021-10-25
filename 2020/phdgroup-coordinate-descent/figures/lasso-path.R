library(lars)
library(glmnet)
library(RColorBrewer)

set.seed(4)

n <- 1000
p <- 8

X <- matrix(rnorm(n*p), n)
b <- rnorm(p)
y <- X %*% b + rnorm(n)

res <- lars(X, y)
beta <- res$beta
lambda <- c(res$lambda, 0)

pdf("figures/lasso-path.pdf", width = 3.8, height = 3.2, pointsize = 8)
plot(NULL,
     xlim = extendrange(lambda),
     ylim = extendrange(beta),
     xlab = expression(lambda),
     ylab = expression(beta))
col <- brewer.pal(p, "Dark2")
abline(h = 0, col = "grey")

for (i in 1:ncol(beta)) {
  lines(lambda, beta[, i], col = col[i])
}
dev.off()
knitr::plot_crop("figures/lasso-path.pdf")

