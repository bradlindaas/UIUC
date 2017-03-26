library(Quandl)
library(dplyr)
library(xts)
library(lubridate)
library(forecast)
library(dygraphs)

# Start with daily data. Note that "type = raw" will download a data frame.
oil_daily <- Quandl("FRED/DCOILWTICO", type = "raw", collapse = "daily",  
                    start_date="2006-01-01", end_date="2017-02-28")
# Now weekely and let's use xts as the type.
oil_weekly <- Quandl("FRED/DCOILWTICO", type = "xts", collapse = "weekly",  
                     start_date="2006-01-01", end_date="2017-02-28")
# And monthly using xts as the type.
oil_monthly <- Quandl("FRED/DCOILWTICO", type = "xts", collapse = "monthly",  
                      start_date="2006-01-01", end_date="2017-02-28")

# Have a quick look at our three  objects. 
str(oil_daily)

str(oil_weekly)

str(oil_monthly)

index(oil_monthly) <- seq(mdy('01/01/2006'), mdy('02/01/2017'), by = 'months')
head(index(oil_monthly))

dygraph(oil_monthly, main = "Monthly oil Prices")

oil_6month <- forecast(oil_monthly, h = 6)

# Let's have a quick look at the 6-month forecast and the 80%/95% confidence levels. 
oil_6month

plot(oil_6month, main = "Oil Forecast")

oil_forecast_data <- data.frame(date = seq(mdy('03/01/2017'), 
                                           by = 'months', length.out = 6),
                                Forecast = oil_6month$mean,
                                Hi_95 = oil_6month$upper[,2],
                                Lo_95 = oil_6month$lower[,2])

head(oil_forecast_data)

oil_forecast_xts <- xts(oil_forecast_data[,-1], order.by = oil_forecast_data[,1])

# Combine the xts objects with cbind.

oil_combined_xts <- cbind(oil_monthly, oil_forecast_xts)

# Add a nicer name for the first column.

colnames(oil_combined_xts)[1] <- "Actual"

# Have a look at both the head and the tail of our new xts object. Make sure the
# NAs are correct.
head(oil_combined_xts)

tail(oil_combined_xts)

dygraph(oil_combined_xts, main = "Oil Prices: Historical and Forecast") %>%
  # Add the actual series
  dySeries("Actual", label = "Actual") %>%
  # Add the three forecasted series
  dySeries(c("Lo_95", "Forecast", "Hi_95"))

