% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_read_years}
\alias{fars_read_years}
\title{fars_read_years}
\usage{
fars_read_years(years)
}
\arguments{
\item{years}{years as a number, or a list of numbers,
in form of integer of character}

\item{MONTH}{selected month}
}
\value{
This function returns a list in which each item is correspond to
a year, each item is a dataframe containing two columns: Month and year
}
\description{
This function gets years and fetches datasets corresponding to the
given years
}
\examples{
\dontrun{fars_read_years("2013")}
\dontrun{fars_read_years(2013)}
\dontrun{fars_read_years(c(2013,2014))}

}
