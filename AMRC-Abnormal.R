library(quantmod)
library(forecast)

tckrs <- c("AMRC")
DCF_high <- 10.84
DCF_low <- 8.00
AMRC_Open <- 13.39

# Create the run up to acquisition announcement
beta <- 0.09
n <- 60
abnormal_bump <- data.frame(bump = exp(beta * seq(n)) + rnorm(n))
bump1 <- abnormal_bump[nrow(abnormal_bump),]
abnormal_bump <- (abnormal_bump/bump1)


getSymbols(tckrs, from = "2016-8-03", to = "2017-3-3")

# get only the closing prices
AMRC <- AMRC[,4]
AMRC_last <- as.numeric(AMRC[nrow(AMRC)])
abnormal_bump_low <- (abnormal_bump*(DCF_low-AMRC_last))
abnormal_bump_high <- (abnormal_bump*(DCF_high-AMRC_last))


blank_rows <- data.frame(bump = rep(0,times=nrow(AMRC)-nrow(abnormal_bump)))
abnormal_bump_low <- rbind(blank_rows,abnormal_bump_low)
abnormal_bump_high <- rbind(blank_rows,abnormal_bump_high)

AMRC$bump_low <- abnormal_bump_low$bump
AMRC$bump_high <- abnormal_bump_high$bump

AMRC$forecast_low <- AMRC$AMRC.Close +AMRC$bump_low
AMRC$forecast_high <- AMRC$AMRC.Close +AMRC$bump_high


#merge this into one basket of data
basket <- cbind(AMRC$forecast_low, AMRC$forecast_high, AMRC$AMRC.Close)
zoo.basket <- as.zoo(basket)

# Set a color scheme:
#tsColor <- rainbow(ncol(zoo.basket))
tsColor <- c("blue", "green","red", "black")

# Plot the overlayed series
plot(x = zoo.basket, ylab = "Stock Price", main = "Acquisition Scenarios, Impact on Stock Price",
     col = tsColor, screens = 1, xlab="", ylim=c(1,14))
abline(h=AMRC_Open, col = "red", lty=2)


# Set a legend in the upper left hand corner to match color to return series
legend(x = "topleft", legend = c("Low Range Valuation", "High range Valuation", "Ameresco, No Acquisition"), lty = 1,col = tsColor)



