//  Author: * Juan Maroñas *
//  This file implements the unpooled model in assignment 8, which also estimates log predictive density in order to estimate loo.

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
    mu[j] ~ normal(0, 10);
    sigma[j] ~ gamma(1,1);
  }

  // likelihood
  for (j in 1:J)
    y_std[,j] ~ normal(mu[j], sigma[j]);
}

generated quantities {

  // Compute log predictive density \log p(y*|0s) per each datapoint and per each sample
  vector[N*J] log_lik;
  for (j in 1:J){
      for (n in 1:N){
        log_lik[ n + j*N - N ] = normal_lpdf( y_std[n,j] | mu[j], sigma[j] );
      }
  }

}
