
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
maxtime <- 6000
# We generate a noise vector for subsequent analysis

startNoise <- jitter(rep(0,maxtime), 1)

genTimeSeries <- function(maxtime, mu, noiseparm, eps) {
  tseries <- matrix(ncol = 3, nrow = maxtime )
  colnames(tseries) <- c("u", "v", "t")
  #we'll set x0 = 0.5, unlike the thesis set
   x0 <- 0.5
  
  for ( i in 1:maxtime) {
    x1 <- mu * x0 * (1 - x0) + noiseparm * eps[i]
    x2 <- mu * x1 * (1 - x1) - noiseparm * eps[i]
 #   # a rigorous treatment would check for out of bounds values here
    tseries[i,] <- cbind(x1, x0, i)
    x0 <- x2
  }
 as.data.frame(tseries[-c(1:100),])
}
 
#timeSeries0 <- genTimeSeries(maxtime, input$mu, input$noiseLevel, startNoise)
currentNoise <- startNoise
shinyServer(function(input, output) {
  oldLine <- 0.66
  output$nullPLot <- renderPlot({ 
                          input$noiseRecalc
                          currentNoise <<- jitter(rep(0,maxtime), 1)
                          })
   
  output$responsePlot <- renderPlot({
    localMu <- 2.95 + 0.25 * input$mu
    timeSeries0 <- genTimeSeries(maxtime, localMu, input$noiseLevel, currentNoise)
    
   plot(c(0,maxtime +100), c(0.4,0.9), pch = "", 
        main = paste(eval(maxtime - 100), 
                     " Steps at ",
                     eval(input$mu ),
                     " Rn and ",
                     eval(input$noiseLevel),
                     "noise"),
        xlab = "Time Step",
        ylab = "Population Fraction (0,1)")
#   lines(timeSeries0$t, timeSeries0$v, col = "blue")
   lines(timeSeries0$t, timeSeries0$u, col = "green")
    abline(h = oldLine, col = "grey")
    oldLine <<- mean(timeSeries0$u )
  })
    
  })
  

