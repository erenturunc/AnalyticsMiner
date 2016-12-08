landingPageAnalysis <- function(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise = T){
  
  checkPackages("RGoogleAnalytics","httpuv", "ggplot2", "scales", "sqldf")
  library(httpuv)
  library(ggplot2)
  library(RGoogleAnalytics)
  library(scales)
  library(sqldf)
  
  token <- Auth(ClientID,ClientSecret)
  ValidateToken(token)
  
  ###Landing Pages Analysis - START###
  query.list <- Init(start.date = toString(StartDate),
                     end.date = toString(EndDate),
                     dimensions = "ga:landingPagePath,ga:source",
                     metrics = "ga:sessions,ga:entranceRate,ga:bounceRate,ga:avgTimeOnPage,ga:pageValue",
                     max.results = 1000,
                     sort = "-ga:sessions",
                     table.id = ViewID)
  
  ga.query <- QueryBuilder(query.list)
  
  ga.data <- GetReportData(ga.query, token, split_daywise = SplitDaywise)
  
  data_cntByPath <- sqldf("select landingPagePath, sum(sessions) as cnt from [ga.data] group by landingPagePath")
  data_cntByPath_firstQrtEliminated <- sqldf(paste("select * from data_cntByPath where cnt > ", as.character(quantile(data_cntByPath$cnt)[2]), " order by cnt desc"))
  
  #data_TopPagesBySessions <- sqldf("select * from [ga.data] where landingPagePath in (select landingPagePath from data_cntByPath_firstQrtEliminated)")
  
  data_bestPagesByBounceRate <- sqldf("select landingPagePath, sum(sessions/bounceRate) as Score from [ga.data] where landingPagePath in (select landingPagePath from data_cntByPath_firstQrtEliminated) group by landingPagePath order by Score desc LIMIT 20")
  data_worstPagesByBounceRate <- sqldf("select landingPagePath, sum(sessions/bounceRate) as Score from [ga.data] where landingPagePath in (select landingPagePath from data_cntByPath_firstQrtEliminated) group by landingPagePath order by Score asc LIMIT 20")
  
  dataSet1 <- sqldf("select *, (sessions/bounceRate) as bounceScore from [ga.data] where landingPagePath in (select landingPagePath from data_bestPagesByBounceRate)")
  dataSet2 <- sqldf("select *,  (sessions/bounceRate) as bounceScore from [ga.data] where landingPagePath in (select landingPagePath from data_worstPagesByBounceRate)")
  
  g1 <- ggplot(data=dataSet1, aes(x=landingPagePath, y=bounceScore, fill=source)) +
    geom_bar(stat="identity") +
    #scale_y_log10() +
    coord_flip()
  
  g2 <- ggplot(data=dataSet2, aes(x=landingPagePath, y=bounceScore, fill=source)) +
    geom_bar(stat="identity") +
    #scale_y_log10() +
    coord_flip()
	
  print(g1)
  print(g2)
  ###Landing Pages Analysis - END###
  
}