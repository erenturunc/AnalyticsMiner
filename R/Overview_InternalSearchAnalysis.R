internalSearchAnalysis <- function(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise = T){
  
  checkPackages("RGoogleAnalytics","httpuv", "ggplot2", "scales", "sqldf")
  library(httpuv)
  library(ggplot2)
  library(RGoogleAnalytics)
  library(scales)
  library(sqldf)
  
  token <- Auth(ClientID,ClientSecret)
  ValidateToken(token)
  
  ###Internal Site Search Analysis - START###  
  query.list <- Init(start.date = toString(StartDate),
                     end.date = toString(EndDate),
                     dimensions = "ga:searchKeyword,ga:source",
                     metrics = "ga:searchUniques,ga:searchExitRate,ga:searchResultViews,ga:searchRefinements,ga:totalEvents,ga:goalCompletionsAll",
                     max.results = 1000,
                     sort = "-ga:searchUniques",
                     table.id = ViewID)
  
  ga.query <- QueryBuilder(query.list)
  
  ga.data <- GetReportData(ga.query, token, split_daywise = SplitDaywise)
  
  topSearchedKeywords <- sqldf("select searchKeyword, sum(searchUniques) as searchUniques from [ga.data] group by searchKeyword order by searchUniques desc LIMIT 20")
  
  sqlQuery <- "select * from [ga.data] WHERE searchKeyword IN (select searchKeyword from topSearchedKeywords)"
  topSearchedKeywordsWithSources <- sqldf(sqlQuery)
  
  g1 <- ggplot(data=topSearchedKeywordsWithSources, aes(x=searchKeyword, y=searchUniques, fill=source)) +
    geom_bar(stat="identity") +
    coord_flip()
	
  print(g1)
  
  ###Internal Site Search Analysis - END###
  
}