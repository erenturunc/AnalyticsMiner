\name{devicePerformanceAnalysis}
\alias{devicePerformanceAnalysis}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Device Performance Analysis
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
devicePerformanceAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise = T)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ClientID}{
%%     ~~Describe \code{ClientID} here~~
}
  \item{ClientSecret}{
%%     ~~Describe \code{ClientSecret} here~~
}
  \item{ViewID}{
%%     ~~Describe \code{ViewID} here~~
}
  \item{StartDate}{
%%     ~~Describe \code{StartDate} here~~
}
  \item{EndDate}{
%%     ~~Describe \code{EndDate} here~~
}
  \item{SplitDaywise}{
%%     ~~Describe \code{SplitDaywise} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (ClientID, ClientSecret, ViewID, StartDate, EndDate, 
    SplitDaywise = T) 
{
    checkPackages("RGoogleAnalytics", "httpuv", "ggplot2", "scales", 
        "sqldf")
    library(httpuv)
    library(ggplot2)
    library(RGoogleAnalytics)
    library(scales)
    library(sqldf)
    token <- Auth(ClientID, ClientSecret)
    ValidateToken(token)
    query.list <- Init(start.date = toString(StartDate), end.date = toString(EndDate), 
        dimensions = "ga:date,ga:deviceCategory", metrics = "ga:sessions,ga:uniquePageviews,ga:goalCompletionsAll,ga:uniquePurchases,ga:transactionRevenue", 
        max.results = 10000, sort = "ga:date", table.id = ViewID)
    ga.query <- QueryBuilder(query.list)
    ga.data <- GetReportData(ga.query, token, split_daywise = SplitDaywise)
    ga.data$date <- as.Date(ga.data$date, format = "\%Y\%m\%d")
    p_sessions <- ggplot(ga.data, aes(x = date, y = sessions, 
        group = deviceCategory, color = deviceCategory)) + geom_line() + 
        labs(title = "Sessions by date", x = "Dates", y = "Sessions") + 
        theme_classic()
    p_sessions <- p_sessions + theme(axis.text.x = element_text(angle = 90, 
        hjust = 1))
    p_sessions <- p_sessions + theme_classic()
    p_sessions <- p_sessions + stat_smooth(method = "lm")
    p_uniquePageviews <- ggplot(ga.data, aes(x = date, y = uniquePageviews, 
        group = deviceCategory, color = deviceCategory)) + geom_line() + 
        labs(title = "Unique PageViews by date", x = "Dates", 
            y = "Unique PageViews") + theme_classic()
    p_uniquePageviews <- p_uniquePageviews + theme(axis.text.x = element_text(angle = 90, 
        hjust = 1))
    p_uniquePageviews <- p_uniquePageviews + theme_classic()
    p_uniquePageviews <- p_uniquePageviews + stat_smooth(method = "lm")
    p_goalCompletionsAll <- ggplot(ga.data, aes(x = date, y = goalCompletionsAll, 
        group = deviceCategory, color = deviceCategory)) + geom_line() + 
        labs(title = "Goal completions by date", x = "Dates", 
            y = "Goal Completions") + theme_classic()
    p_goalCompletionsAll <- p_goalCompletionsAll + theme(axis.text.x = element_text(angle = 90, 
        hjust = 1))
    p_goalCompletionsAll <- p_goalCompletionsAll + theme_classic()
    p_goalCompletionsAll <- p_goalCompletionsAll + stat_smooth(method = "lm")
    p_uniquePurchases <- ggplot(ga.data, aes(x = date, y = uniquePurchases, 
        group = deviceCategory, color = deviceCategory)) + geom_line() + 
        labs(title = "Purchases by date", x = "Dates", y = "Purchase") + 
        theme_classic()
    p_uniquePurchases <- p_uniquePurchases + theme(axis.text.x = element_text(angle = 90, 
        hjust = 1))
    p_uniquePurchases <- p_uniquePurchases + theme_classic()
    p_uniquePurchases <- p_uniquePurchases + stat_smooth(method = "lm")
    p_transactionRevenue <- ggplot(ga.data, aes(x = date, y = transactionRevenue, 
        group = deviceCategory, color = deviceCategory)) + geom_line() + 
        labs(title = "Revenue by date", x = "Dates", y = "Revenue") + 
        theme_classic()
    p_transactionRevenue <- p_transactionRevenue + theme(axis.text.x = element_text(angle = 90, 
        hjust = 1))
    p_transactionRevenue <- p_transactionRevenue + theme_classic()
    p_transactionRevenue <- p_transactionRevenue + stat_smooth(method = "lm")
    multiplot(p_sessions, p_uniquePageviews, p_goalCompletionsAll, 
        p_uniquePurchases, p_transactionRevenue, cols = 2)
    data_mobile <- sqldf("select * from [ga.data] where deviceCategory == 'mobile'")
    model_mobile <- lm(formula = sessions ~ date, data = data_mobile)
    predictionDate_mobile = data.frame(date = c("20161101", "20161102"))
    predictionDate_mobile$date <- as.Date(predictionDate_mobile$date, 
        format = "\%Y\%m\%d")
    predictedValues_mobile = predict(model_mobile, predictionDate_mobile)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
