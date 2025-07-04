% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_ticket_audits.R
\name{get_ticket_audits}
\alias{get_ticket_audits}
\title{Get Zendesk Ticket Audits}
\usage{
get_ticket_audits(email_id, token, subdomain, ticket_id)
}
\arguments{
\item{email_id}{Zendesk Email Id (username).}

\item{token}{Zendesk API token.}

\item{subdomain}{Your organization's Zendesk sub-domain.}

\item{ticket_id}{Integer with Zendesk ticket id.}
}
\value{
a Data Frame containing first 100 audits for the ticket, with the
events as a nested data frame in each row.
}
\description{
This function takes your Email Id, authentication token,
sub-domain and ticket id as parameters and gets the first 100 audits.
Pagination to get additional audits was not set up in the first version
of this function.
}
\details{
It's not a good practice to write down these authentication
parameters in your code. There are various methods and
packages available that are more secure; this package
doesn't require you to use any one in particular.
}
\examples{
\dontrun{
all_tickets <- get_ticket_audits(email_id, token, subdomain,
  ticket_id = 123456
)
}
}
\references{
\url{https://developer.zendesk.com/api-reference/ticketing/
tickets/ticket_audits/}
}
