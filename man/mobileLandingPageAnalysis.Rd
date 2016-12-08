\name{mobileLandingPageAnalysis}
\alias{mobileLandingPageAnalysis}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Mobile Landing Page Analysis
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
mobileLandingPageAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise = T)
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
        dimensions = "ga:landingPagePath,ga:source", metrics = "ga:sessions,ga:entranceRate,ga:bounceRate,ga:avgTimeOnPage,ga:pageValue", 
        filters = "ga:deviceCategory==mobile", max.results = 1000, 
        sort = "-ga:sessions", table.id = ViewID)
    ga.query <- QueryBuilder(query.list)
    ga.data <- GetReportData(ga.query, token, split_daywise = SplitDaywise)
    data_cntByPath <- sqldf("select landingPagePath, sum(sessions) as cnt from [ga.data] group by landingPagePath")
    data_cntByPath_firstQrtEliminated <- sqldf(paste("select * from data_cntByPath where cnt > ", 
        as.character(quantile(data_cntByPath$cnt)[2]), " order by cnt desc"))
    data_bestPagesByBounceRate <- sqldf("select landingPagePath, sum(sessions/bounceRate) as Score from [ga.data] where landingPagePath in (select landingPagePath from data_cntByPath_firstQrtEliminated) group by landingPagePath order by Score desc LIMIT 20")
    data_worstPagesByBounceRate <- sqldf("select landingPagePath, sum(sessions/bounceRate) as Score from [ga.data] where landingPagePath in (select landingPagePath from data_cntByPath_firstQrtEliminated) group by landingPagePath order by Score asc LIMIT 20")
    dataSet1 <- sqldf("select *, (sessions/bounceRate) as bounceScore from [ga.data] where landingPagePath in (select landingPagePath from data_bestPagesByBounceRate)")
    dataSet2 <- sqldf("select *,  (sessions/bounceRate) as bounceScore from [ga.data] where landingPagePath in (select landingPagePath from data_worstPagesByBounceRate)")
    g1 <- ggplot(data = dataSet1, aes(x = landingPagePath, y = bounceScore, 
        fill = source)) + geom_bar(stat = "identity") + coord_flip()
    g2 <- ggplot(data = dataSet2, aes(x = landingPagePath, y = bounceScore, 
        fill = source)) + geom_bar(stat = "identity") + coord_flip()
    print(g1)
    print(g2)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
