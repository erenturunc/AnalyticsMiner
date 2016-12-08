sourceAnalysis <- function(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise = T){
  
  checkPackages("RGoogleAnalytics","httpuv", "ggplot2", "scales", "sqldf")
  library(httpuv)
  library(ggplot2)
  library(RGoogleAnalytics)
  library(scales)
  library(sqldf)
  
  token <- Auth(ClientID,ClientSecret)
  ValidateToken(token)
  
  ###All Traffic Sources Analysis - START###
  query.list <- Init(start.date = StartDate,
                     end.date = EndDate,
                     dimensions = "ga:sourceMedium,ga:userType",
                     metrics = "ga:users,ga:avgPageLoadTime,ga:bounceRate,ga:pageviewsPerSession,ga:searchSessions,ga:goalConversionRateAll,ga:goalCompletionsAll",
                     max.results = 100,
                     sort = "-ga:users",
                     table.id = ViewID)
  
  ga.query <- QueryBuilder(query.list)
  
  ga.data <- GetReportData(ga.query, token, split_daywise = SplitDaywise)
  
  ga.data.top <- sqldf("select sourceMedium, SUM(users) as users from [ga.data] group by sourceMedium order by users desc LIMIT 20")
  ga.data.graph <- sqldf("select * from [ga.data.top] as t  Inner join [ga.data] as d on t.sourceMedium = d.sourceMedium")
  
  p1 <- ggplot(data=ga.data.graph, aes(x=sourceMedium, y=users, fill=userType)) +
    geom_bar(stat="identity") +
    coord_flip()
	
  print(p1)
  
  ###All Traffic Sources Analysis - END###
  
}