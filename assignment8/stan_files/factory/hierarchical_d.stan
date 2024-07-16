//  Author: * Juan Maroñas *
//  This file implements the hierarchical model in assignment 7 exercise 2 with a more non-informative hyperprior.

data {

  int<lower=0> N;
  int<lower=0> J;
  matrix[N,J]  y; // cannot be array of vectors otherwise when normalizing cannot use - since is not defined between arrays and scalars.
}

transformed data {
  // normalize the data so that standard prior is correctly specified.
  matrix[N,J] y_std;

  for (j in 1:J){
    y_std[,j]  = (y[,j] - mean(y[,j]))  / sd(y[,j]);
  }
}

parameters {

  // likelihood parameters
  vector[J] mu;
  real<lower=0> sigma;

  // prior parameters
  real mu_0;
  real<lower=0> sigma_0;
  real<lower=0> tau;
}

model {

  // hyperpriors distributions
  sigma_0 ~ gamma(1,1);
  tau     ~ gamma(1,1);
  mu_0    ~ normal(0,10);

  // priors
  sigma ~ inv_chi_square( tau );
  for (j in 1:J){
    mu[j] ~ normal(mu_0, sigma_0);
  }

  // likelihood
  for (j in 1:J)
    y_std[,j] ~ normal(mu[j], sigma);
}

generated quantities {

  // Compute log predictive density \log p(y*|0s) per each datapoint and per each sample
  vector[N*J] log_lik;
  for (j in 1:J){
      for (n in 1:N){
        log_lik[ n + j*N - N ] = normal_lpdf( y_std[n,j] | mu[j], sigma );
      }
  }

}
