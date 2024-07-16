//  Author: * Juan Maroñas Molano *
//  This file implements the correction of Stan code from assignment 7 exercise 1.

data {
  
  int<lower=0> N; // number of data points
  vector[N] x;    // observation year
  vector[N] y;    // observation number of drowned
  real xpred;     // prediction year

  real sigma_beta;  // std for the prior of beta
  real mu_alpha  ;  // mean for the prior of alpha
  real sigma_alpha; // std for the prior of alpha

}

parameters {
  
  real alpha;
  real beta;
  real<lower=0> sigma;
  
}

transformed parameters {
  
  vector[N] mu = alpha + beta*x;
  
}

model {

  beta  ~ normal( 0, sigma_beta  );
  alpha ~ normal( mu_alpha, sigma_alpha );

  y ~ normal(mu, sigma);

}

generated quantities {

  real mu_pred  = alpha + beta * xpred ;
  real ypred    = normal_rng(mu_pred, sigma);

}
