# generate data
beta <- 0.09
n <- 60
temp <- data.frame(y = exp(beta * seq(n)) + rnorm(n), x = seq(n))

# plot data
plot(temp$x, temp$y)

# fit non-linear model
mod <- nls(y ~ exp(a + b * x), data = temp, start = list(a = 0, b = 0))

# add fitted curve
lines(temp$x, predict(mod, list(x = temp$x)))