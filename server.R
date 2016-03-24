require(ggplot2);
require(scales);
require(plyr);



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
    if(input$annual.close | input$monthly.close){stopApp()}
    

    
    df.1<-
      read.csv(file=csv[1], stringsAsFactor=FALSE);
    
    df.1$data<-
      "seasonallyAdjusted";
    
    df.1$prelim[(nrow(df.1) - 1):nrow(df.1)]<-
      "P"

    df.2<-
      read.csv(file=csv[2], stringsAsFactor=FALSE);
    
    df.2$data<-
      "unadjusted";
    
    df.2$prelim[(nrow(df.2) - 1):nrow(df.2)]<-
      "P"
    
    df<-
      rbind(df.1, df.2);
    
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
        #df[df$data == input$data,];
    }
    
    df$Year_Mo<-
      paste(df$Year, df$Period, sep="\n");
  
    
    df$dff[1]<-
      0;
    
    df$diff[ 2:nrow(df) ]<-
      df$Value[2:nrow(df)] - df$Value[1:nrow(df)-1 ];
    
    
    #df$prelim[1:nrow(df)-2]<-
    #  "A"
    

    
    df<-
      df[df$Year>=input[[year]][1] & df$Year<=input[[year]][2] ,  ];
      #df[df$Year>=input$year[1] & df$Year<=input$year[2] ,  ];
    
    #if(input$time=="Year"){
    if(time=="Year"){  
      
      df<-
        ddply(df
              , c("Year", "data")
              , function(x){
                  response<-
                    sum(x[, c(input[[measure]][1])], na.rm=TRUE);
                  
                  names(response)<-
                    input[[measure]][1];
                  
                  return(response);
                  });
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
        (response + geom_bar(stat="identity", aes_string(x=x, y=input[[measure]][1])));
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