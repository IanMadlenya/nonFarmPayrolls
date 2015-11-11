
shiny.title<-
  headerPanel("U.S. Nonfarm Payrolls");

text.ad<-
  "Copyright 2015 Meaningful Solutions LLC<br/><a href='http://meaningful-solutions.com'>Building Capacity for Your Curiosity</a>";

annual.options<-
  conditionalPanel(condition="input.conditionedPanels==1"
                   , radioButtons("annual.data"
                                  , label="Data"
                                  , choices=list("Seasonally Adjusted"="seasonallyAdjusted", "Unadjusted"="unadjusted", "Both"="Both")
                                  , selected="seasonallyAdjusted")
                   , radioButtons("annual.measure", label="Measure", choices=list("Jobs Created"="diff", "Total Number of Jobs"="Value"), selected="diff")
                   , radioButtons("annual.fill", label="Fill", choices=list( "None"="Neither", "Year"="Year" ), selected="Neither")
                   , sliderInput("annual.year", label="Year", min=1939, max=2015, value=c(2012,2014), sep="", step=1)
                   , checkboxInput("annual.close", label="Stop Server", value=FALSE)
                   );

monthly.options<-
  conditionalPanel(condition="input.conditionedPanels==2"
                   , radioButtons("monthly.data"
                                  , label="Data"
                                  , choices=list("Seasonally Adjusted"="seasonallyAdjusted", "Unadjusted"="unadjusted", "Both"="Both")
                                  , selected="seasonallyAdjusted")
                   , radioButtons("monthly.view", label="View", choices=list("Sequential"="Sequential", "Year Over Year"="YoY"), selected="Sequential")
                   , radioButtons("monthly.measure", label="Measure", choices=list("Jobs Created"="diff", "Total Number of Jobs"="Value"), selected="diff")
                   , radioButtons("monthly.fill", label="Fill", choices=list( "None"="Neither", "Year"="Year", "Month"="Period" ), selected="Neither")
                   , sliderInput("monthly.year", label="Year", min=1939, max=2015, value=c(2012,2014), sep="", step=1)
                   , checkboxInput("monthly.close", label="Stop Server", value=FALSE)
    );

shiny.sidebar<-
  sidebarPanel(annual.options, monthly.options);


annual.tab<-
  tabPanel("Annual", value=1);

monthly.tab<-
  tabPanel("Monthly", value=2);

shiny.tabset<-
  tabsetPanel(annual.tab, monthly.tab, id="conditionedPanels");


shiny.main<-
  mainPanel(shiny.tabset, plotOutput("chart"), HTML(text.ad));

shiny.layout<-
  sidebarLayout( shiny.sidebar, shiny.main );

shiny.page<-
  pageWithSidebar(headerPanel("U.S. Nonfarm Payrolls"), shiny.sidebar, shiny.main);

shinyUI(shiny.page);