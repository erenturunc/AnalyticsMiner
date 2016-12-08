\name{AnalyticsMiner-package}
\alias{AnalyticsMiner-package}
\alias{AnalyticsMiner}
\docType{package}
\title{
Data Mining on Google Analytics Report
~~ package title ~~
}
\description{
AnalyticsMiner help you to analyze your Google Analytics report and give you an overview about what is happening on your web site.

For now, package provides the following analyzes but we are plannig to improve it very fast :)

Bounce Analysis. Compares with the previous period and shows a boxplot on daily bounce rates.
Device Performance Analysis. Gives different metrics over time by device categories.
Internal Search Analysis. Shows top searched keywords by traffic source
Landing Page Analysis. Shows landing pages with the highest and lowest bounce score by their traffic sources.
Mobile Landing Page Analysis. Shows mobile landing pages with the highest and lowest bounce score by their traffic sources.
Page Business Analysis. Shows top valued pages with their traffic
Source Analysis. Gives and overview about your acqusition channels.

~~ A concise (1-5 lines) description of the package ~~
}
\details{
\tabular{ll}{
Package: \tab AnalyticsMiner\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2016-12-07\cr
License: \tab GNU General Public License.\cr
}
~~ An overview of how to use the package, including the most important functions ~~
}
\author{
Eren Turunc : <erenturunc@gmail.com>
~~ The author and/or maintainer of the package ~~
}
\references{
~~ Literature or other references for background information ~~
}
~~ Optionally other standard keywords, one per line, from file KEYWORDS in the R documentation directory ~~
\keyword{ package }
\seealso{
~~ Optional links to other man pages, e.g. ~~
~~ \code{\link[<pkg>:<pkg>-package]{<pkg>}} ~~
}
\examples{
~~ simple examples of the most important functions ~~

ClientID <- "Google Analytics API OAuth Client ID"
ClientSecret <- "Google Analytics API Client Secret Key"
ViewID <- "Analytics View ID E.g. ga:11111111"
StartDate <- "2016-10-01"
EndDate <- "2016-10-30"
SplitDaywise <- F

bounceAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise)
sourceAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise)
pageBusinessAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise)
internalSearchAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise)
landingPageAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise)
mobileLandingPageAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise)
devicePerformanceAnalysis(ClientID, ClientSecret, ViewID, StartDate, EndDate, SplitDaywise)

}
