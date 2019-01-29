// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// R2SSUR_internal
int R2SSUR_internal(const std::string& dataFile, const std::string& blockFile, const std::string& structureGraphFile, const std::string& outFilePath, unsigned int nIter, unsigned int nChains, const std::string& method, const std::string& gammaSampler, const std::string& gammaInit, bool usingGPrior);
RcppExport SEXP _R2SSUR_R2SSUR_internal(SEXP dataFileSEXP, SEXP blockFileSEXP, SEXP structureGraphFileSEXP, SEXP outFilePathSEXP, SEXP nIterSEXP, SEXP nChainsSEXP, SEXP methodSEXP, SEXP gammaSamplerSEXP, SEXP gammaInitSEXP, SEXP usingGPriorSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::string& >::type dataFile(dataFileSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type blockFile(blockFileSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type structureGraphFile(structureGraphFileSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type outFilePath(outFilePathSEXP);
    Rcpp::traits::input_parameter< unsigned int >::type nIter(nIterSEXP);
    Rcpp::traits::input_parameter< unsigned int >::type nChains(nChainsSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type method(methodSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type gammaSampler(gammaSamplerSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type gammaInit(gammaInitSEXP);
    Rcpp::traits::input_parameter< bool >::type usingGPrior(usingGPriorSEXP);
    rcpp_result_gen = Rcpp::wrap(R2SSUR_internal(dataFile, blockFile, structureGraphFile, outFilePath, nIter, nChains, method, gammaSampler, gammaInit, usingGPrior));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_R2SSUR_R2SSUR_internal", (DL_FUNC) &_R2SSUR_R2SSUR_internal, 10},
    {NULL, NULL, 0}
};

RcppExport void R_init_R2SSUR(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}