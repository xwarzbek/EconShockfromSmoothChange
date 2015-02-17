# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Sudden jumps in a Bi-Stable System"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    sliderInput("noiseLevel",
                "Noise(Arb units):",
                min = 0,
                max = 1,
                value = 0.05),
    sliderInput( "mu",
                 "regeneration coefficient",
                 min = 0,
                 max = 1,
                 value = 0.01,
                 step = 0.005),
    p("Regeneration refers to an internal variable: \n
      for a value, to be investigated, the function is bi-stable"),
    p("Noise is added to potentially induce switching between states"),
    p("The grey line will keep track of the last average value")
#    actionButton("noiseRecalc", "New Random Noise")
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("responsePlot")   
  )
))
