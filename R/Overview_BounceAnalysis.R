bounceAnalysis <- function(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise = T){
  
  checkPackages("RGoogleAnalytics","httpuv", "ggplot2", "scales", "sqldf")
  library(httpuv)
  library(ggplot2)
  library(RGoogleAnalytics)
  library(scales)
  library(sqldf)
  
  token <- Auth(ClientID,ClientSecret)
  ValidateToken(token)
  
  ###Bounce Analysis - START###
  
  StartDate <- as.Date(StartDate)
  EndDate <- as.Date(EndDate)
  
  CompareStartDate <- StartDate - (EndDate - StartDate) - 1
  CompareEndDate <- EndDate - (EndDate - StartDate) - 1
  
  ##Actual Data START
  query.list <- Init(start.date = toString(StartDate),
                     end.date = toString(EndDate),
                     dimensions = "ga:date",
                     metrics = "ga:sessions,ga:bounces",
                     max.results = 1000,
                     sort = "ga:date",
                     table.id = ViewID)
  
  ga.query <- QueryBuilder(query.list)
  
  ga.data <- GetReportData(ga.query, token, split_daywise = SplitDaywise)
  ga.data$bounceRate <- ga.data$bounces / ga.data$sessions
  ##Actual Data END
  
  ##Compare Data START
  query.list.compare <- Init(start.date = toString(CompareStartDate),
                             end.date = toString(CompareEndDate),
                             dimensions = "ga:date",
                             metrics = "ga:sessions,ga:bounces",
                             max.results = 1000,
                             sort = "ga:date",
                             table.id = ViewID)
  
  ga.query.compare <- QueryBuilder(query.list.compare)
  
  ga.data.compare <- GetReportData(ga.query.compare, token, split_daywise = SplitDaywise)
  ga.data.compare$bounceRate <- ga.data.compare$bounces / ga.data.compare$sessions
  ##Compare Data END
  
  ##Casting
  ga.data$date <- as.Date(ga.data$date, "%Y%m%d")
  ga.data.compare$date <- as.Date(ga.data.compare$date, "%Y%m%d")
  
  ##Sorting
  df <- ga.data[order(ga.data$date), ]
  df.compare <- ga.data.compare[order(ga.data.compare$date), ]
  df.compare$date <- as.Date(df.compare$date) + (EndDate - StartDate + 1)
  
  mergedData <- sqldf("select date, bounceRate as BounceRate, 'Compared' as gr from [df.compare] as c 
                    union all
                    select date, bounceRate as BounceRate, 'Actual' as gr from [df] as a")
  ##Plotting
  
  g1 <- ggplot(data=NULL,
         aes(x=date, y=bounceRate)) +
    geom_line(data = df, colour="#CC0000") + geom_line(data = df.compare, colour="#000099")
  
  g2 <- ggplot(data=mergedData,
         aes(x=gr, y=BounceRate)) +
    geom_boxplot()
	
  print(g1)
  print(g2)
  
  ###Bounce Analysis - END###
  
}