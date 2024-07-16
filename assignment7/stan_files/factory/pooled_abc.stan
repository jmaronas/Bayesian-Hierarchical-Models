//  Author: * Juan Maroñas *
//  This file implements the pooled model in assignment 7 exercise 2.

data {

  int<lower=0> N;
  int<lower=0> J;
  matrix[N,J]  y; // cannot be array of vectors otherwise when normalizing cannot use - since is not defined between arrays and scalars.

}

transformed data {

  vector[N*J] y_resh; // to reshape the matrix into a vector
  y_resh = to_vector(y);

  // normalize the data so that standard prior is correctly specified.
  vector [N*J] y_std;

  y_std = (y_resh - mean(y_resh)) / sd(y_resh);

}

parameters {

  real mu;
  real<lower=0> sigma;

}

model {

  // priors
  mu ~ normal(0,1);
  sigma ~ inv_chi_square(10);

  // likelihood
  y_std ~ normal( mu , sigma );

}

generated quantities {

  // Compute posterior predictive distribution for the sixth machine
  real y_pred = normal_rng(mu, sigma);
  y_pred = y_pred * sd(y) + mean(y); // undoo scaling so that predictions are on the original range.

}
