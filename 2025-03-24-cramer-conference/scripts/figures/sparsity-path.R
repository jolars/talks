library(glmnet)
library(here)

# Create an empty plot with appropriate dimensions
p_values <- c(10, 50, 100)


for (i in 1:3) {
  filename <- here("figures", paste0("sparsity-path-", i, ".pdf"))
  pdf(
    filename,
    width = 1.8,
    height = 3.05,
    pointsize = 7
  )
  set.seed(1931)

  if (i == 1) {
    par(mar = c(4, 5, 1, 1))
  } else {
    par(mar = c(4, 2, 1, 1))
  }

  n <- 20
  p <- p_values[i]
  k <- 10

  x <- matrix(rnorm(n * p), n, p)
  beta <- rep(0, p)
  ind <- sample(1:p, k)
  beta[ind] <- rnorm(k)

  y <- x %*% beta + rnorm(n)

  fit <- glmnet(x, y, nlambda = 50)

  coefs <- coef(fit)

  # Extract lambda sequence and coefficients
  lambdas <- fit$lambda
  coef_matrix <- as.matrix(coefs)[-1, ] # Remove intercept row

  plot(
    1,
    type = "n",
    xlim = c(1, length(lambdas)),
    ylim = c(0.5, max(p_values) + 0.5),
    xlab = "Step",
    ylab = if (i == 1) expression(beta != 0) else "",
    axes = FALSE
  )

  # ord <- order(apply(coef_matrix, 1, which), decreasing = TRUE)
  ord <- order(
    apply(coef_matrix, 1, function(x) which(x != 0)[1]),
    decreasing = FALSE
  )

  coef_matrix <- coef_matrix[ord, ]

  if (i == 1) {
    axis(2, at = pretty(1:max(p_values)))
  }

  axis(1, at = pretty(seq_along(lambdas)))

  # Plot rectangles for non-zero coefficients
  for (i in 1:nrow(coef_matrix)) {
    for (j in 1:ncol(coef_matrix)) {
      col <- if (coef_matrix[i, j] != 0) "black" else "light grey"
      rect(
        j - 0.5,
        i - 0.5,
        j + 0.5,
        i + 0.5,
        col = col,
        border = "white",
        lwd = 0.5
      )
    }
  }

  text(
    length(lambdas) * 0.85,
    max(p_values) * 0.91,
    bquote(p == .(p)),
    pos = 3
  )

  dev.off()
}
