\name{gcitations}
\alias{citations}
\title{ Moore project citations }
\description{ Get citations of genome projects funded by the Gordon and Betty Moore Foundation }
\usage{
citations(mg, year = 2004)
}
\arguments{
  \item{mg}{ a Moore project table with search queries in cites, keywords and accs columns }
  \item{year}{  exclude results prior to year, default 2004 }
}
\details{  Runs searches at Europe PMC for papers citing the genome publication, matching keywords or mentioning accessions.  Also,  combines the results into a single `data.frame` to merge publications found by mutliple searches.   

}
\value{ a list of data.frames }
%\references{ }
\author{ Chris Stubben }
\note{ The `search` column contains abbreviations for the search criteria, where *=genome paper, G=cites Genome paper, K=matches Keywords, and A=mentions Accession }

%\seealso{ }
\examples{
\dontrun{
data(mg)
citations(mg[4:6,])
}
}
\keyword{ methods }

