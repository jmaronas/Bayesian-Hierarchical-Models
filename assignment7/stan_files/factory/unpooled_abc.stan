//  Author: * Juan Maroñas *
//  This file implements the unpooled model in assignment 7 exercise 2.

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
    y_std[,j] ~ normal(mu[j], sigma[j]);
}

generated quantities {

  // Compute posterior predictive distribution for the sixth machine
  real y_pred = normal_rng(mu[6], sigma[6]);
  y_pred = y_pred * sd(y[,6]) + mean(y[,6]); // undoo scaling so that predictions are on the original range.

}
