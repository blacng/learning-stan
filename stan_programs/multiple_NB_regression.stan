functions {
  /*
  * Alternative to neg_binomial_2_log_rng() that 
  * avoids potential numerical problems during warmup
  */
  int neg_binomial_2_log_safe_rng(real eta, real phi) {
    real gamma_rate = gamma_rng(phi, phi / exp(eta));
    if (gamma_rate >= exp(20.79))
      return -9;
      
    return poisson_rng(gamma_rate);
  }
}
data {
  int<lower=1> N;
  vector<lower=0>[N] traps;
  vector<lower=0,upper=1>[N] live_in_super;
  vector[N] log_sq_foot;
  int<lower=0> complaints[N];
}
parameters {
  real alpha;
  real beta;
  real beta_super;
  real<lower=0> inv_phi;
  // declare 1/phi as parameter
}
transformed parameters {
  // calculate phi
  real phi = inv(inv_phi);
  // OR real phi = 1/inv_phi;
}
model {
  vector[N] eta = alpha + beta * traps + beta_super * live_in_super
                                  + log_sq_foot;
                             
  // change to negative binomial (neg_binomial_2_log) 
  complaints ~ neg_binomial_2_log(eta, phi);
  // complaints ~ poisson_log(eta);   
  
  alpha ~ normal(log(4), 1);
  beta ~ normal(-0.25, 1);
  beta_super ~ normal(-0.5, 1);
   // prior on inv_phi
  inv_phi ~ normal(0, 1);
} 
generated quantities {
  int y_rep[N];
  for (n in 1:N) {
    real eta_n = alpha + beta * traps[n] + beta_super * live_in_super[n] 
                  + log_sq_foot[n];
    y_rep[n] = neg_binomial_2_log_safe_rng(eta_n, phi);
  }
  
}

