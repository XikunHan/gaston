#include <Rcpp.h>
#include <RcppParallel.h>
#include <iostream>
#include <ctime>
#include "matrix4.h"
#include "loubar.h"

using namespace Rcpp;
using namespace RcppParallel;


struct paraPro2 : public Worker {
  const matrix4 & A;
  const std::vector<double> mu;
  const std::vector<double> sd;
  const size_t ncol;
  const size_t true_ncol;
  const size_t r;
  double * v;
  //output
  double * vA;

 //constructeur
  paraPro2(matrix4 & A, std::vector<double> mu, std::vector<double> sd, size_t r, double * v) 
          : A(A), mu(mu), sd(sd), ncol(A.ncol), true_ncol(A.true_ncol), v(v), r(r) {
    vA = new double[r*ncol];
    std::fill(vA, vA+r*ncol, 0);
  }
  //constructeur pour le split
  paraPro2(paraPro2 & Q, Split) : A(Q.A), mu(Q.mu), sd(Q.sd), ncol(Q.ncol), 
           true_ncol(Q.true_ncol), v(Q.v), r(Q.r) {
    vA = new double[r*ncol];
    std::fill(vA, vA+r*ncol, 0);
  }

  // destructeur
  ~paraPro2() { 
    delete [] vA; 
  }
  
  //worker
  void operator()(size_t beg, size_t end) {
    double gg[4];
    gg[3] = 0;
    for(size_t i = beg; i < end; i++) {
      double sd_ = (sd[i]==0)?1:sd[i];
      double mu_ = mu[i];
      gg[0] = -mu_/sd_;
      gg[1] = (1-mu_)/sd_;
      gg[2] = (2-mu_)/sd_;
      for(size_t c = 0; c < r; c++) {
        size_t k = c*ncol;
        for(size_t j = 0; j < true_ncol; j++) {
          uint8_t x = A.data[i][j];
          for(int ss = 0; ss < 4 && (4*j + ss) < ncol; ss++) {
            vA[k++] += v[A.nrow*c+i]*gg[x&3];
            x >>= 2;
          }
        }
      }
    }
  }

  // join
  void join(const paraPro2 & Q) {
    std::transform(vA, vA + r*ncol, Q.vA, vA, std::plus<double>());
    // autrement dit : vA += vA.K;
  }

};


//[[Rcpp::export]]
NumericMatrix m4_loading_to_pc_ms(XPtr<matrix4> p_A, const std::vector<double> & mu, const std::vector<double> & sd, 
                                  NumericMatrix & v) {
  int n = p_A->nrow; // nb snps
  int m = p_A->ncol; // nb inds
  if(n != v.nrow()) stop("Dimensions mismatch");
  int r = v.ncol();

  paraPro2 X(*p_A, mu, sd, r, v.begin());
  parallelReduce(0, n, X);

  NumericMatrix R(m,r);
  std::copy(X.vA, X.vA+m*r, R.begin());

  return R;
}

RcppExport SEXP gg_m4_loading_to_pc_ms(SEXP p_ASEXP, SEXP muSEXP, SEXP sdSEXP, SEXP vSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< XPtr<matrix4> >::type p_A(p_ASEXP );
        Rcpp::traits::input_parameter< const std::vector<double>& >::type mu(muSEXP );
        Rcpp::traits::input_parameter< const std::vector<double>& >::type sd(sdSEXP );
        Rcpp::traits::input_parameter< NumericMatrix& >::type v(vSEXP );
        NumericMatrix __result = m4_loading_to_pc_ms(p_A, mu, sd, v);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}

