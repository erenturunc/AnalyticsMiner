pageBusinessAnalysis <- function(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise = T){
  
  checkPackages("RGoogleAnalytics","httpuv", "ggplot2", "scales", "sqldf")
  library(httpuv)
  library(ggplot2)
  library(RGoogleAnalytics)
  library(scales)
  library(sqldf)
  
  token <- Auth(ClientID,ClientSecret)
  ValidateToken(token)
  
  ###Page Business Efficiency Analysis - START###
  
  query.list <- Init(start.date = toString(StartDate),
                     end.date = toString(EndDate),
                     dimensions = "ga:pageTitle",
                     metrics = "ga:uniquePageviews,ga:pageviews,ga:entranceRate,ga:bounceRate,ga:avgTimeOnPage,ga:pageValue",
                     max.results = 1000,
                     sort = "-ga:uniquePageviews",
                     table.id = ViewID)
  
  ga.query <- QueryBuilder(query.list)
  
  ga.data <- GetReportData(ga.query, token, split_daywise = SplitDaywise)
  
  quartiles <- quantile(ga.data$uniquePageviews)
  
  sqlQuery <- paste("select * from [ga.data] where uniquePageviews > ", 
                    as.character(quartiles[2]),
                    ##" and uniquePageviews < ",
                    ##as.character(quantile(topValuedPages$pageValue, 0.9)[1]),
                    "  order by pageValue desc LIMIT 20")
  
  #Eliminating pages in the first quartile, it may be confusing
  topValuedPages <- sqldf(sqlQuery)
  
  ##Eliminating 5 times bigger than median value, it is probably payment pages.
  ##sqlQuery = paste("select * from topValuedPages where pageValue < ", 
  ##                 as.character(quantile(topValuedPages$pageValue, 0.5)[1] * 5),
  ##                 "  order by pageValue desc LIMIT 20")
  ##topValuedPages <- sqldf(sqlQuery)
  
  p1 <- ggplot(data=topValuedPages, aes(x=pageTitle, y=uniquePageviews)) +
    geom_bar(stat="identity", fill="#0072B2") +
    ggtitle("Top Valued Pages Unique Page Views") +
    coord_flip()
  p2 <- ggplot(data=topValuedPages, aes(x=pageTitle, y=pageValue)) +  
    geom_bar(stat="identity", fill="#D55E00") +
    ggtitle("Top Valued Pages Values") +
    coord_flip()
  
  multiplot(p1, p2, cols=2)
  
  ###Page Business Efficiency Analysis - END###
  
}