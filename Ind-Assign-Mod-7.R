library(reshape)
library(ggplot2)
library(plyr)
library(reshape)
library(scales)
library(ggthemes)

x <- read.csv (
    "Mod7_Data.csv", 
    na.strings=c("NA","NaN", " ", "..") 
)

plotList <- read.csv("Mod7_Definition-and-Source.csv")

names(x)[5:40] <- c(1980:2015)
data <- subset(x, select=-c(Country.Name, Series.Name))
names(data)[1] <- "Country"
data$Series.Code <- c("GDP Growth", "CPI inflation")
mdata <- melt(data, id=c("Series.Code","Country"), variable.name="Year", value.name="Value")
mdata$variable <- as.Date(mdata$variable, format="%Y")

### Plot 2
p <- ggplot (
    data = mdata 
    ,aes(x = variable, y = value/100, color = Series.Code, group = Series.Code)
)
p + geom_line(aes(), size=2) +
    theme_bw() +
    theme_economist() + scale_colour_economist() +
    ggtitle("Economic Growth and Inflation in the United States (1980 to 2015)") +
    scale_y_continuous(name="",labels=percent) + 
    theme(text = element_text(size=10)) +
    scale_x_date(name = "", date_breaks = "2 years", date_labels = "%Y") +
    theme(legend.title=element_blank())

