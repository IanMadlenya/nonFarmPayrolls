require(ggplot2);
require(scales);
require(plyr);

load("payroll.RData");

csv<-
  c(
    seasonallyAdjusted="seasonallyAdjustedNonfarmPayrolls.csv"
    ,unadjusted="unadjustedNonfarmPayrolls.csv");

chart.titles<-
  c(
    seasonallyAdjusted="Seasonally Adjusted Nonfarm Payrolls"
    , unadjusted="Unadjusted Nonfarm Payrolls"
    , Both="Nonfarm Payrolls");

measures<-
  c("Value"="Jobs (in 000's)", "diff"="Jobs Created (in 000's)");

time.units<-
  c("Year"="Year", "Year_Mo"="Months");

plotchart<-
  function(input){
    
    df<-
      payroll.data[[input$employmentData]]$monthly
    
    time<-
      "Year";
    
    prefix<-
      "annual";
    
    if(input$conditionedPanels=="2"){
      time<-
        "Year_Mo";
      
      prefix<-
        "monthly";
    }
    
    data.set<-
      paste(prefix, "data", sep=".");
    
    year<-
      paste(prefix, "year", sep=".");
    
    measure<-
      paste(prefix, "measure", sep=".");
    
    fill<-
      paste(prefix, "fill", sep=".");
    
    if(input[[data.set]][1] !="Both"){
      
      df<-
        df[df$data == input[[data.set]][1] , ];
        
    }
    
    df$Year_Mo<-
      paste(df$Year, df$Period, sep="\n");
  
    
    df$dff[1]<-
      0;
    
    df$diff[ 2:nrow(df) ]<-
      df$Value[2:nrow(df)] - df$Value[1:nrow(df)-1 ];
    
    df<-
      df[df$Year>=input[[year]][1] & df$Year<=input[[year]][2] ,  ];

    if(time=="Year"){  
          
      df<-
        df[df$Period == "M12",]
    } 
    
    if(input$monthly.view=="YoY"){
      df$Period<-
        factor(df$Period, levels=unique(df$Period), ordered=TRUE );
    }
    
    chart.title<-
      chart.titles[input[[data.set]][1]];
    
    response<-
      (ggplot(df)
       + ggtitle( chart.title ));

    x<-
      time;
    
    if(input$monthly.view=="YoY"){ x<-"Year";}


    
    if(input[[fill]][1]=="Neither"){ 
      response<-
        (response + geom_bar(stat="identity", aes_string(x=x, y=input[[measure]][1]), fill="steel blue"));
    } else {
      response<-
        (response + geom_bar(stat="identity", aes_string(x=x, y=input[[measure]][1], fill=input[[fill]][1])));
    }
    
    if(input[[data.set]][1]=="Both" & input$monthly.view=="Sequential"){
      response<-
        (response + facet_wrap( ~ data, nrow=2));
    }
    
    if(input$monthly.view=="YoY"){
      response<-
        (response + facet_wrap( ~ Period, ncol=3));
    }
    
    
   response<-
      (response
      + scale_y_continuous(measures[input[[measure]][1] ], labels=comma)
      + theme_bw()
      + theme(legend.position="bottom")
      );
   
   if(prefix=="monthly" & input$monthly.view=="Sequential"){
     
     mo<-
       unique(df$Year_Mo);
     
     mo.breaks<-
       mo[seq(3,length(mo),3)];
     
     response<-
       (response + scale_x_discrete(name=time.units[time], labels=mo.breaks, breaks=mo.breaks));
   }
   
   
   return(response);
  }


fn<-
  function(input, output){
    
    output$chart<-
      renderPlot(plotchart(input=input));
    
    output$ad<-
      renderText("<em>Meaningful Solutions LLC</em>")
    
  }

shinyServer( fn );