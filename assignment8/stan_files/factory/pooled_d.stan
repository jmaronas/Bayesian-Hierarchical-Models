//  Author: * Juan Maroñas *
//  This file implements the pooled model in assignment 7 exercise 2 part d. We change the prior over hyperparameters

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
  mu ~ normal(0,10);
  sigma ~ gamma(1,1);

  // likelihood
  y_std ~ normal( mu , sigma );

}

generated quantities {

  // Compute log predictive density \log p(y*|0s) per each datapoint and per each sample
  vector[N*J] log_lik;
  for ( i in 1:N*J ){
        log_lik[ i ] = normal_lpdf( y_std[i] | mu, sigma );
  }


}
