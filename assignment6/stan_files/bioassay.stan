//  Author: * Juan Maroñas Molano *
//  This file implements the bioassay problem from Bayesian Data Analysis book. This a generalized linear model with a Gaussian prior over the linear parameters
//  and a binomial likelihood for the data, with parameter theta = inv_logit( alpha + beta * x) and y ~ Binomial( n, theta ), where n,y,x are data.
//  The parameters from the prior can be feed as arguments to the model. This could also be hardcoded in the transformed data module.

// Input data to Stan. Can be data, hyperprior parameters etc.
data {
      // Prior distribution
      vector[2]   prior_mean; // the vector where the prior mean is specified.
      matrix[2,2] prior_cov ; // the prior covariance. We don't check its possitive semidefinite and let stan do that for us.

      // Data information
      int <lower = 1> N;                     // Number of observations.
      array[N] int <lower = 1> n;            // Number of trials
      array[N] int <lower = 0, upper = n> y; // Number of trials being 1.

      vector[N] x;                           // Inputs to the model.
}

// Parameters over where MCMC is performed: in this case alpha beta which are kept in a vector
parameters {
      vector[2] alpha_beta;
}

// Parameters that are obtained from the MCMC draws
transformed parameters{
      vector[N] theta; // A parameter corresponds to each datapoint x
      theta = alpha_beta[1] + alpha_beta[2] * x ;
}

// Specifies likelihood and prior distributions
model {
      // Prior over the parameters of the model
      alpha_beta ~ multi_normal( prior_mean, prior_cov );

      // Likelihood
      y ~ binomial_logit( n, theta );
}
