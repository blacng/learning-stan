// This is my first stan regression code
// rstan:::lookup("rpois") - to lookup stan equivalent function

// The Data 
data {
  /*
  This is a multiline comment
  */
  int<lower = 0> N; // Number of Observations
  int<lower = 0> complaints[N]; 
  vector<lower = 0> [N] traps;  
  
// real<lower = 0> traps[N]- I couldn't a linear regression with this
// vector[N] x[K] - I could do a linear regression with this
// matrix[N,N] m[K]
// Anything in stan could be an array
}

parameters {
  real alpha;
  real beta;
}

transformed parameters {
  // could have declared eta here to save its values
}

model {
  // temporary variable because it's in model block
  vector[N] eta = alpha + beta * traps;
  // complaints ~ poisson(exp(eta));
  complaints ~ poisson_log(exp(eta));
  
  alpha ~ normal(log(4), 1); 
  beta ~ normal(-0.25, 1);
// imagine a counter at the top target = 0;
// we want it to = P(y|theta)p(theta)
// this is to evaluate density functions not the sample
// target += normal_lpdf(alpha|log(4)), 1
}

generated quantities {
  int y_rep[N];
  for (n in 1:N) {
    y_rep[n] = poisson_log_rng(alpha + beta * traps[n]);
  }
}
