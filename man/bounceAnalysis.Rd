\name{bounceAnalysis}
\alias{bounceAnalysis}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Bounce Analysis
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
bounceAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise = T)
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
    StartDate <- as.Date(StartDate)
    EndDate <- as.Date(EndDate)
    CompareStartDate <- StartDate - (EndDate - StartDate) - 1
    CompareEndDate <- EndDate - (EndDate - StartDate) - 1
    query.list <- Init(start.date = toString(StartDate), end.date = toString(EndDate), 
        dimensions = "ga:date", metrics = "ga:sessions,ga:bounces", 
        max.results = 1000, sort = "ga:date", table.id = ViewID)
    ga.query <- QueryBuilder(query.list)
    ga.data <- GetReportData(ga.query, token, split_daywise = SplitDaywise)
    ga.data$bounceRate <- ga.data$bounces/ga.data$sessions
    query.list.compare <- Init(start.date = toString(CompareStartDate), 
        end.date = toString(CompareEndDate), dimensions = "ga:date", 
        metrics = "ga:sessions,ga:bounces", max.results = 1000, 
        sort = "ga:date", table.id = ViewID)
    ga.query.compare <- QueryBuilder(query.list.compare)
    ga.data.compare <- GetReportData(ga.query.compare, token, 
        split_daywise = SplitDaywise)
    ga.data.compare$bounceRate <- ga.data.compare$bounces/ga.data.compare$sessions
    ga.data$date <- as.Date(ga.data$date, "\%Y\%m\%d")
    ga.data.compare$date <- as.Date(ga.data.compare$date, "\%Y\%m\%d")
    df <- ga.data[order(ga.data$date), ]
    df.compare <- ga.data.compare[order(ga.data.compare$date), 
        ]
    df.compare$date <- as.Date(df.compare$date) + (EndDate - 
        StartDate + 1)
    mergedData <- sqldf("select date, bounceRate as BounceRate, 'Compared' as gr from [df.compare] as c \n                    union all\n                    select date, bounceRate as BounceRate, 'Actual' as gr from [df] as a")
    g1 <- ggplot(data = NULL, aes(x = date, y = bounceRate)) + 
        geom_line(data = df, colour = "#CC0000") + geom_line(data = df.compare, 
        colour = "#000099")
    g2 <- ggplot(data = mergedData, aes(x = gr, y = BounceRate)) + 
        geom_boxplot()
    print(g1)
    print(g2)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
