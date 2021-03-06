% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BayesSUR.R
\docType{package}
\name{BayesSUR}
\alias{BayesSUR}
\title{main function of the package}
\usage{
BayesSUR(
  Y,
  X,
  X_0 = NULL,
  data = NULL,
  outFilePath = "",
  nIter = 10000,
  burnin = 5000,
  nChains = 2,
  covariancePrior = "HIW",
  gammaPrior = "",
  betaPrior = "independent",
  gammaSampler = "bandit",
  gammaInit = "MLE",
  mrfG = NULL,
  standardize = TRUE,
  standardize.response = TRUE,
  maxThreads = 2,
  output_gamma = TRUE,
  output_beta = TRUE,
  output_G = TRUE,
  output_sigmaRho = TRUE,
  output_pi = TRUE,
  output_tail = TRUE,
  output_model_size = TRUE,
  output_model_visit = FALSE,
  output_CPO = FALSE,
  output_Y = TRUE,
  output_X = TRUE,
  hyperpar = list(),
  tmpFolder = "tmp/"
)
}
\arguments{
\item{Y, X, X_0}{vectors of indexes (with respect to the data matrix) for the outcomes, the covariates to select and the fixed covariates respectively if data is either a path to a file or a matrix;
if the 'data' argument is not provided, these needs to be matrices containing the data instead.}

\item{data}{a data frame if using \code{formula}. If not using \code{formula}, it is either a matrix/dataframe or the path to (a plain text) data file with variables on the columns and observations on the rows}

\item{outFilePath}{path to where the output files are to be written. The default path is the currect working directory.}

\item{nIter}{number of iterations for the MCMC procedure.}

\item{burnin}{number of iterations (or fraction of iterations) to discard at the start of the chain. Default is 0.}

\item{nChains}{number of parallel chains to run.}

\item{covariancePrior}{string indicating the prior for the covariance $C$; it has to be either "HIW" for the hyper-inverse-Wishar (which will result in a sparse covariance matrix),
"IW" for the inverse-Wishart prior ( dense covariance ) or "IG" for independent inverse-Gamma on all the diagonal elements and 0 otherwise. See the details for the model specification}

\item{gammaPrior}{string indicating the gamma prior to use, either "hotspot" for the Hotspot prior of Bottolo (2011), "MRF" for the Markov Random Field prior or "hierarchical" for a simpler hierarchical prior. See the details for the model specification}

\item{betaPrior}{string indicating the beta prior to use, either "independent" for the independent spike-and-slab prior or "reGroup" for the random effects for \code{X_0} and independent spike-and-slab priors for other predictors}

\item{gammaSampler}{string indicating the type of sampler for gamma, either "bandit" for the Thompson sampling inspired samper or "MC3" for the usual $MC^3$ sampler}

\item{gammaInit}{gamma initialisation to either all-zeros ("0"), all ones ("1"), randomly ("R") or (default) MLE-informed ("MLE").}

\item{mrfG}{either a matrix or a path to the file containing the G matrix for the MRF prior on gamma (if necessary)}

\item{standardize}{logical flag for X variable standardization. Default is standardize=TRUE. The coefficients are returned on the standardized scale.}

\item{standardize.response}{Standardization for the response variables. Default is standardize.response=TRUE.}

\item{maxThreads}{maximum threads used for parallelization. Default is 2.}

\item{output_gamma}{allow ( \code{TRUE} ) or suppress ( \code{FALSE} ) the output for  gamma. See the return value below for more information.}

\item{output_beta}{allow ( \code{TRUE} ) or suppress ( \code{FALSE} ) the output for beta. See the return value below for more information.}

\item{output_G}{allow ( \code{TRUE} ) or suppress ( \code{FALSE} ) the output for G. See the return value below for more information.}

\item{output_sigmaRho}{allow ( \code{TRUE} ) or suppress ( \code{FALSE} ) the output for sigmaRho. See the return value below for more information.}

\item{output_pi}{allow ( \code{TRUE} ) or suppress ( \code{FALSE} ) the output for pi. See the return value below for more information.}

\item{output_tail}{allow ( \code{TRUE} ) or suppress ( \code{FALSE} ) the output for tail (hotspot tail probability). See the return value below for more information.}

\item{output_model_size}{allow ( \code{TRUE} ) or suppress ( \code{FALSE} ) the output for model_size. See the return value below for more information.}

\item{output_model_visit}{allow ( \code{TRUE} ) or suppress ( \code{FALSE} ) the output for all visited models over the MCMC iterations. Default is \code{FALSE}. See the return value below for more information.}

\item{output_CPO}{allow ( \code{TRUE} ) or suppress ( \code{FALSE} ) the output for *; possible outputs are gamma, G, beta, sigmaRho, pi, tail (hotspot tail probability), model_size, CPO. See the return value below for more information.}

\item{output_Y}{allow ( \code{TRUE} ) or suppress ( \code{FALSE} ) the output for responses dataset Y.}

\item{output_X}{allow ( \code{TRUE} ) or suppress ( \code{FALSE} ) the output for predictors dataset X.}

\item{hyperpar}{a list of named hypeparameters to use instead of the default values. Valid names are mrf_d, mrf_e, a_sigma, b_sigma, a_tau, b_tau, nu, a_eta, b_eta, a_o, b_o, a_pi, b_pi, a_w and b_w.
Their default values are a_w=2, b_w=5, a_omega=1, b_omega=1, a_o=2, b_o=p-2, a_pi=2, b_pi=1, nu=s+2, a_tau=0.1, b_tau=10, a_eta=0.1, b_eta=1, a_sigma=1, b_sigma=1, mrf_d=-3 and mrf_e=0.03. See the vignette for more information.}

\item{tmpFolder}{the path to a temporary folder where intermediate data files are stored (will be erased at the end of the chain) default to local tmpFolder}
}
\value{
An object of class "BayesSUR":
\itemize{
\item status - the running status
\item input - a list of all input parameters by the user
\item output - a list of the all output filenames:
\itemize{
\item "\code{*_logP_out.txt}" - contains each row for the \eqn{1000t}-th iteration's log-likelihoods of parameters, i.e., Tau, Eta, JunctionTree, SigmaRho, O, Pi, Gamma, W, Beta and data conditional log-likelihood depending on the models.
\item "\code{*_gamma_out.txt}" - posterior mean of the latent indicator matrix.
\item "\code{*_pi_out.txt}" - posterior mean of the predictor effects (prospensity) by decomposing the probability of the latent indicator.
\item "\code{*_hotspot_tail_p_out.txt}" - posterior mean of the hotspot tail probability. Only available for the hotspot prior on the gamma.
\item "\code{*_beta_out.txt}" - posterior mean of the coefficients matrix.
\item "\code{*_G_out.txt}" - posterior mean of the response graph. Only available for the HIW prior on the covariance.
\item "\code{*_sigmaRho_out.txt}" - posterior mean of the transformed parameters. Not available for the IG prior on the covariance.
\item "\code{*_model_size_out.txt}" - contains each row for the\eqn{1000t}-th iteration's model sizes of the multiple response variables.
\item "\code{*_model_visit_g_out.txt}" - contains each row for the nonzero indices of the vectorized estimated graph matrix for each iteration.
\item "\code{*_model_visit_gamma_out.txt}" - contains each row for the nonzero indices of the vectorized estimated gamma matrix for each iteration.
\item "\code{*_CPO_out.txt}" - the (scaled) conditional predictive ordinates (CPO).
\item "\code{*_CPOsumy_out.txt}" - the (scaled) conditional predictive ordinates (CPO) with joint posterior predictive of the response variables.
\item "\code{*_WAIC_out.txt}" - the widely applicable information criterion (WAIC).
\item "\code{*_Y.txt}" - responses dataset.
\item "\code{*_X.txt}" - predictors dataset.
\item "\code{*_X0.txt}" - fixed predictors dataset.
}
\item call - the matched call.
}
}
\description{
Main function of the package. Fits a range of models introduced in the package vignette \code{BayesSUR.pdf}. Returns an object of S3 class BayesSUR.
There are three options for the prior on the residual covariance matrix (i.e., independent inverse-Gamma, inverse-Wishart and hyper-inverse Wishart)
and three options for the prior on the latent indicator variable (i.e., independent Bernoulli, hotspot and Markov random field).
So there are nine models in total. See details for their combinations.
}
\details{
The arguments \code{covariancePrior} and \code{gammaPrior} specify the model HRR, dSUR or SSUR with different gamma prior. Let \eqn{\gamma_{jk}} be latent indicator variable of each coefficient and \eqn{C} be covariance matrix of response variables.
The nine models specified through the arguments \code{covariancePrior} and \code{gammaPrior} are as follows.
\tabular{cccc}{
                \tab \eqn{\gamma_{jk}}~Bernoulli \tab \eqn{\gamma_{jk}}~hotspot \tab \eqn{\gamma_{jk}}~MRF \cr
  \eqn{C}~indep \tab HRR-B                       \tab HRR-H                     \tab HRR-M           \cr
  \eqn{C}~IW    \tab dSUR-B                      \tab dSUR-H                    \tab dSUR-M          \cr
  \eqn{C}~HIW   \tab SSUR-B                      \tab SSUR-H                    \tab SSUR-M
}
}
\examples{

data("example_eQTL", package = "BayesSUR")
hyperpar <- list( a_w = 2 , b_w = 5 )
set.seed(9173)
fit <- BayesSUR(Y = example_eQTL[["blockList"]][[1]],
                X = example_eQTL[["blockList"]][[2]],
                data = example_eQTL[["data"]], outFilePath = tempdir(),
                nIter = 100, burnin = 50, nChains = 2, gammaPrior = "hotspot",
                hyperpar = hyperpar, tmpFolder = "tmp/", output_CPO=TRUE)

## check output
# show the summary information
summary(fit)

# show the estimated beta, gamma and graph of responeses Gy
\donttest{
estimators <- getEstimator(fit, estimator=c("beta","gamma","Gy"))
plot(estimators)

plot(estimators, fig.tex = TRUE)
system(paste(getOption("pdfviewer"), "ParamEstimator.pdf"))
}

}
\references{
Banterle M, Bottolo L, Richardson S, Ala-Korpela M, Jarvelin MR, Lewin A (2018). \emph{Sparse variable and covariance selection for high-dimensional seemingly unrelated Bayesian regression.} bioRxiv: 467019.

Banterle M#, Zhao Z#, Bottolo L, Richardson S, Lewin A\*, Zucknick M\* (2019). \emph{BayesSUR: An R package for high-dimensional multivariate Bayesian variable and covariance selection in linear regression.} URL: https://github.com/mbant/BayesSUR/tree/master/BayesSUR/vignettes/vignettes.pdf
}
