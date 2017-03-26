library(quantmod)
library(forecast)

tckrs <- c("WMT", "AMRC", "SPY", "DJIA", "^TYX")
getSymbols(tckrs, from = "2012-03-03", to = "2017-3-3")

# get only the closing prices
WMT.Close <- WMT[,4]
AMRC.Close <- AMRC[,4]
SPY.Close <- SPY[,4]
DJIA.Close <- DJIA[,4]
TYX.Close <- TYX[,4]

# divide every daily entry by the first observation 
WMT1 <- as.numeric(WMT.Close[1])
AMRC1 <- as.numeric(AMRC.Close[1])
SPY1 <- as.numeric(SPY.Close[1])
DJIA1 <- as.numeric(DJIA.Close[1])
TYX1 <- as.numeric(TYX.Close[1])

WMT <- (WMT.Close/WMT1)*10000
AMRC <- (AMRC.Close/AMRC1)*10000
SPY <- (SPY.Close/SPY1)*10000
DJIA <- (DJIA.Close/DJIA1)*10000
TYX <- (TYX.Close/TYX1)*10000

#merge this into one basket of data
basket <- cbind(AMRC, SPY, DJIA, TYX)
zoo.basket <- as.zoo(basket)

# Set a color scheme:
#tsColor <- rainbow(ncol(zoo.basket))
tsColor <- c("red", "blue", "green", "black")

# Plot the overlayed series
plot(x = zoo.basket, ylab = "Cumulative Return of $10,000", main = "Cumulative Returns",
     col = tsColor, screens = 1, xlab="")

# Set a legend in the upper left hand corner to match color to return series
legend(x = "topleft", legend = c("Ameresco", "S&P 500", "Dow Jones", "30 Y T-bill"), lty = 1,col = tsColor)


