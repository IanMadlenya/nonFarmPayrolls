
shiny.title<-
  titlePanel("US Nonfarm Payrolls");

shiny.sidebar<-
  sidebarPanel(h3("Options")
               , radioButtons("data"
                              , label="Data"
                              , choices=list("Seasonally Adjusted"="seasonallyAdjusted", "Unadjusted"="unadjusted", "Both"="Both")
                              , selected="seasonallyAdjusted")
               , radioButtons("time", label="Time", choices=list("Year"="Year", "Year & Month"="Year_Mo"), selected="Year_Mo")
               , radioButtons("view", label="View", choices=list("Sequential"="Sequential", "Year Over Year"="YoY"), selected="Sequential")
               , radioButtons("measure", label="Measure", choices=list("Jobs Created"="diff", "Total Number of Jobs"="Value"), selected="diff")
               , radioButtons("fill", label="Fill", choices=list( "Year"="Year", "Month (only when time = Month)"="Period", "Neither"="Neither"), selected="Neither")
               , sliderInput("year", label="Year", min=1939, max=2015, value=c(2012,2014), sep="", step=1)
               , checkboxInput("close", label="Stop Server", value=FALSE)
               );

shiny.main<-
  mainPanel(plotOutput("chart"));

shiny.layout<-
  sidebarLayout( shiny.sidebar, shiny.main );

shiny.page<-
  fluidPage(shiny.title, shiny.layout);

shinyUI(shiny.page);