setwd('/home/rstudio/UIUC/')
fname <- "AMRC.csv"
AMRC <- read.csv(fname, header = TRUE)

library(relaimpo)

names(AMRC)[4]<-"CAGR_19"

fit <- glm(Price~LT_CAGR+WACC+CAGR_19+Decay, data=AMRC)
boot <- boot.relimp(fit, b = 1000, type = c("first"), rank = TRUE,  diff = TRUE, rela = TRUE)
booteval.relimp(boot) # print result
plot(booteval.relimp(boot,sort=TRUE)) # plot result
