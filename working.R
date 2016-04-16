library(reshape)
library(ggplot2)
library(plyr)
library(reshape)
library(scales)

x <- read.csv (
    "Team-1-Data.csv", 
    na.strings=c("NA","NaN", " ", "..") 
    )

plotList <- read.csv("Team-1-Definition-and-Source.csv")

names(x)[5:40] <- c(1980:2015)
data <- subset(x, select=-c(Country.Name, Series.Name))
names(data)[1] <- "Country"
mdata <- melt(data, id=c("Series.Code","Country"), variable.name="Year", value.name="Value")


### Plot 1
p <- ggplot (
    data = mdata[ which(mdata$Series.Code==plotList$Code[1]), ] 
    ,aes(x = variable, y = value, color = Country, group = Country)
)
p + geom_line(aes(), size=2) +
    theme_bw() +
    ggtitle(plotList$Indicator.Name[1]) +
    labs(x="Year",y="") +
    theme(text = element_text(size=20), axis.text.x = element_text(angle=90, vjust=1)) +
    scale_y_log10(labels=dollar) + # This creates a log scale for Plot 1 only
    annotation_logticks(side = "l")  
#    scale_x_continuous(limits=c(0,100), breaks=seq(1980,2015, by = 2))

