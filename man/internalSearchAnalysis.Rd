\name{internalSearchAnalysis}
\alias{internalSearchAnalysis}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Internal Search Analysis
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
internalSearchAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise = T)
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
        dimensions = "ga:searchKeyword,ga:source", metrics = "ga:searchUniques,ga:searchExitRate,ga:searchResultViews,ga:searchRefinements,ga:totalEvents,ga:goalCompletionsAll", 
        max.results = 1000, sort = "-ga:searchUniques", table.id = ViewID)
    ga.query <- QueryBuilder(query.list)
    ga.data <- GetReportData(ga.query, token, split_daywise = SplitDaywise)
    topSearchedKeywords <- sqldf("select searchKeyword, sum(searchUniques) as searchUniques from [ga.data] group by searchKeyword order by searchUniques desc LIMIT 20")
    sqlQuery <- "select * from [ga.data] WHERE searchKeyword IN (select searchKeyword from topSearchedKeywords)"
    topSearchedKeywordsWithSources <- sqldf(sqlQuery)
    g1 <- ggplot(data = topSearchedKeywordsWithSources, aes(x = searchKeyword, 
        y = searchUniques, fill = source)) + geom_bar(stat = "identity") + 
        coord_flip()
    print(g1)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
