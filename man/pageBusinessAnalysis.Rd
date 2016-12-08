\name{pageBusinessAnalysis}
\alias{pageBusinessAnalysis}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Page Business Analysis
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
pageBusinessAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise = T)
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
        dimensions = "ga:pageTitle", metrics = "ga:uniquePageviews,ga:pageviews,ga:entranceRate,ga:bounceRate,ga:avgTimeOnPage,ga:pageValue", 
        max.results = 1000, sort = "-ga:uniquePageviews", table.id = ViewID)
    ga.query <- QueryBuilder(query.list)
    ga.data <- GetReportData(ga.query, token, split_daywise = SplitDaywise)
    quartiles <- quantile(ga.data$uniquePageviews)
    sqlQuery <- paste("select * from [ga.data] where uniquePageviews > ", 
        as.character(quartiles[2]), "  order by pageValue desc LIMIT 20")
    topValuedPages <- sqldf(sqlQuery)
    p1 <- ggplot(data = topValuedPages, aes(x = pageTitle, y = uniquePageviews)) + 
        geom_bar(stat = "identity", fill = "#0072B2") + ggtitle("Top Valued Pages Unique Page Views") + 
        coord_flip()
    p2 <- ggplot(data = topValuedPages, aes(x = pageTitle, y = pageValue)) + 
        geom_bar(stat = "identity", fill = "#D55E00") + ggtitle("Top Valued Pages Values") + 
        coord_flip()
    multiplot(p1, p2, cols = 2)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
