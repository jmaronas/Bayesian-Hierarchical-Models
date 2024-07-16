//  Author: * Whoever did assignment 7 *
//  This file implements the bad model from exercise 2 in assignment 7.

data {

  int<lower=0> N;
  int<lower=0> J;
  vector[J] y[N];
}

parameters {

  vector[J] mu;
  vector<lower=0>[J] sigma;
}

model {

  // priors
  for (j in 1:J){
    mu[j] ~ normal(0, 1);
    sigma[j] ~ inv_chi_square(10);
  }

  // likelihood
  for (j in 1:J)
    y[,j] ~ normal(mu[j], sigma[j]);
}

generated quantities {

  real ypred;

  // Compute predictive distribution
  // for the first machine
  ypred = normal_rng(mu[1], sigma[1]);

}
