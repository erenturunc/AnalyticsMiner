\name{sourceAnalysis}
\alias{sourceAnalysis}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Source Analysis
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
sourceAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise = T)
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
    query.list <- Init(start.date = StartDate, end.date = EndDate, 
        dimensions = "ga:sourceMedium,ga:userType", metrics = "ga:users,ga:avgPageLoadTime,ga:bounceRate,ga:pageviewsPerSession,ga:searchSessions,ga:goalConversionRateAll,ga:goalCompletionsAll", 
        max.results = 100, sort = "-ga:users", table.id = ViewID)
    ga.query <- QueryBuilder(query.list)
    ga.data <- GetReportData(ga.query, token, split_daywise = SplitDaywise)
    ga.data.top <- sqldf("select sourceMedium, SUM(users) as users from [ga.data] group by sourceMedium order by users desc LIMIT 20")
    ga.data.graph <- sqldf("select * from [ga.data.top] as t  Inner join [ga.data] as d on t.sourceMedium = d.sourceMedium")
    p1 <- ggplot(data = ga.data.graph, aes(x = sourceMedium, 
        y = users, fill = userType)) + geom_bar(stat = "identity") + 
        coord_flip()
    print(p1)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
