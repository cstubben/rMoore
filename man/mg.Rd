\name{mg}
\alias{mg}
\docType{data}
\title{  Marine microbial genome projects   }
\description{ Marine microbial genome projects funded by the Gordon and Betty Moore Foundation grant GBMF521  }
\usage{data("mg")}
\format{
  A data frame with 177 observations on the following 13 variables.
  \describe{
    \item{\code{Project}}{BioProject title}
    \item{\code{ID}}{ BioProject ID}
    \item{\code{WGS}}{ WGS accession prefix }
    \item{\code{GenBank}}{GenBank accession }
    \item{\code{RefSeq}}{ RefSeq accession}
    \item{\code{SRA}}{ SRA study accession }
    \item{\code{PubMed}}{ PubMed ID of genome publication }
    \item{\code{Synonyms}}{ synonyms }
    \item{\code{Investigator}}{ first investigator name }
    \item{\code{Notes}}{ notes }
    \item{\code{cites}}{ genome citation search query }
    \item{\code{keywords}}{ keyword search query }
    \item{\code{accs}}{accession search query }
  }
}
\details{ Created from the \code{marine-genomes-2014-8-7.xlsx} file on the GBMF521 grants page  }
\source{  \url{https://www.moore.org/grants/list/GBMF521} }
%\references{ }
\examples{
\dontrun{
data(mg)
t(mg[5,])
table(is.na(mg$PubMed))
}
}
\keyword{datasets}
