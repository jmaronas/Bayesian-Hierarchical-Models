//  Author: * Juan Maroñas *
//  This file implements the hierarchical model in assignment 7 exercise 2.

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
  sigma_0 ~ inv_chi_square(10);
  tau     ~ inv_chi_square(10);
  mu_0    ~ normal(0,1);

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

  // Compute posterior predictive distribution for the sixth machine
  real y_pred = normal_rng(mu[6], sigma);
  y_pred = y_pred * sd(y[,6]) + mean(y[,6]); // undoo scaling so that predictions are on the original range.

}
