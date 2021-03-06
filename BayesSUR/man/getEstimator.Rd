% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getEstimator.R
\name{getEstimator}
\alias{getEstimator}
\title{extract the posterior mean of the parameters}
\usage{
getEstimator(object, estimator = "gamma", Pmax = 0)
}
\arguments{
\item{object}{an object of class "BayesSUR"}

\item{estimator}{the name of one estimator. Default is the latent indicator estimator "\code{gamma}". Other options "\code{beta}", "\code{Gy}", "\code{CPO}" and "\code{logP}"
correspond the posterior means of coefficient matrix, response graph and conditional predictive ordinate (CPO) respectively}

\item{Pmax}{threshold that truncate the estimator. Default is 0. If the estimator is beta, then beta is truncated based on the latent indicator matrix shresholding at \code{Pmax}}
}
\value{
Return the one estimator from an object of class "BayesSUR". It is the posterior mean of the latent indicator variable if \code{estimator="gamma"}, posterior mean of the regression coefficients
if \code{estimator="beta"}, posterior mean of the response graph if \code{estimator="Gy"} and the CPO if \code{estimator="CPO"},
}
\description{
Extract the posterior mean of the parameters of a "BayesSUR" class object.
}
\examples{
\dontrun{
data("example_eQTL", package = "BayesSUR")
hyperpar <- list( a_w = 2 , b_w = 5 )

set.seed(9173)
fit <- BayesSUR(Y = example_eQTL[["blockList"]][[1]],
                X = example_eQTL[["blockList"]][[2]],
                data = example_eQTL[["data"]], outFilePath = tempdir(),
                nIter = 100, burnin = 50, nChains = 2, gammaPrior = "hotspot",
                hyperpar = hyperpar, tmpFolder = "tmp/" )

## check output
# extract the posterior mean of the coefficients matrix
beta_hat <- getEstimator(fit, estimator="beta")
}
}
