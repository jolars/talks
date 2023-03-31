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

generateDesign <- function(n,
                           p,
                           family = c("gaussian", "binomial"),
                           density = 1,
                           rho = 0,
                           s = 5,
                           rho_type = c("constant", "auto"),
                           beta_type = 1,
                           snr = 2) {
  family <- match.arg(family)
  rho_type <- match.arg(rho_type)

  s <- min(s, p)
  beta <- double(p)

  if (density != 1 && rho > 0) {
    stop("when density != 1, 'rho' must be 0")
  }

  if (beta_type == 1) {
    ind <- round(seq(1, p, length.out = s))
    beta[ind] <- 1
  } else if (beta_type == 2) {
    beta[1:s] <- 1
  } else if (beta_type == 3) {
    beta[1:s] <- seq(10, 0.5, length = s)
  } else if (beta_type == 4) {
    beta[1:s] <- 1
    beta[(s + 1):p] <- 0.5^(1:(p - s))
  }

  if (density == 1) {
    X <- matrix(rnorm(n * p), n)
  } else {
    X <- Matrix::rsparsematrix(n, p, density)
  }

  if (rho != 0) {
    if (rho_type == "auto") {
      inds <- 1:p
      Sigma <- rho^abs(outer(inds, inds, "-"))
      U <- chol(Sigma)

      X <- X %*% t(U)
      sigma <- sqrt((t(beta) %*% Sigma %*% beta) / snr)
    } else if (rho_type == "constant") {
      X <- matrix(rnorm(n), n, p) * sqrt(rho) +
        sqrt(1 - rho) * matrix(rnorm(n*p), n, p)
      sigma <- sqrt((rho * sum(beta)^2 + (1 - rho) * sum(beta^2)) / snr)
    }
  } else {
    Sigma <- diag(p)
    sigma <- sqrt((t(beta) %*% Sigma %*% beta) / snr)
  }

  y <- as.vector(X %*% beta) + as.vector(sigma) * rnorm(n)

  if (family == "binomial") {
    y <- (sign(y) + 1) / 2
  }

  list(X = X, y = y)
}

recode_methods <- function(x) {
  screening_type = factor(
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

color_palette <- function(name = c("wong", "tableau"), n = NULL) {
  name <- match.arg(name)

  wong <- c(
    "#999999",
    "#E69F00",
    "#56B4E9",
    "#009E73",
    "#F0E442",
    "#0072B2",
    "#D55E00",
    "#CC79A7"
  )
  
  tableau <- c(
    "#4e79a7",
    "#f28e2b",
    "#e15759",
    "#76b7b2",
    "#59a14f",
    "#edc948",
    "#b07aa1",
    "#ff9da7",
    "#9c755f",
    "#bab0ac"
  ) 

  pal <- switch(name, wong = wong, tableau = tableau)

  if (is.null(n)) {
    n <- length(pal)
  }

  if (n > length(pal)) {
    stop("longer length than pal")
  }

  pal[seq_len(n)]
}
