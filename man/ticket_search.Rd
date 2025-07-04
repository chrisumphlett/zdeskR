% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ticket_search.R
\name{ticket_search}
\alias{ticket_search}
\title{Returns ticket data for a provided Zendesk search query}
\usage{
ticket_search(email_id, token, subdomain, query)
}
\arguments{
\item{email_id}{Zendesk Email Id (username).}

\item{token}{Zendesk API token.}

\item{subdomain}{Your organization's Zendesk sub-domain.}

\item{query}{Zendesk search query to execute.}
}
\value{
Data Frame with user details
}
\description{
It takes your Email Id, authentication token, sub-domain and search query
and returns all the tickets that meet the search criteria. 100 tickets are
returned at a time. If your search query has many results, the function
may run for a long time as it goes through each page of results.
}
\details{
It's not a good practice to write down these authentication
parameters in your code. There are various methods and
packages available that are more secure; this package
doesn't require you to use any one in particular.
}
\examples{
\dontrun{
search_results <- ticket_search(email_id, token, subdomain,
query = "query=satisfaction:goodwithcomment updated>24hours")
}
}
\references{
\url{https://developer.zendesk.com/api-reference/ticketing/
ticket-management/search/#list-search-results}
}
