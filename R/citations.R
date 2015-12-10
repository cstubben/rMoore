## source("~/Documents/R-packages/rMoore/R/citations.R")

## requires Project,  cites, keywords and accs columns!

citations <- function( mg, year=2004){
    if(!is.data.frame(mg)) stop("A data.frame is required")
    if(!all(c("cites", "keywords", "accs") %in% names(mg)) ) stop("Columns named cites, keywords and accs are required")
    n <- nrow(mg)
    
    pubs <- vector("list", n)
    names(pubs) <- mg$Project
    
    for(i in 1:n){
       x <- vector("list")
      ## GENOME publication
       cite <- mg$cites[i]
       message("ROW ", i, ". ", mg$Project[i])
      if( cite!=""){
        id1 <- paste0( "EXT_ID:", gsub("[^0-9]", "", cite))
        message("Searching ", id1 )
        x1 <-  search_lite( id1 ) 
        x$`*` <- x1     

        message("Searching ", cite)
        x2 <- search_lite( cite )
        x$G <- x2
      }
         
      key <- mg$keywords[i]
      if(key !=""){
         key2 <- gsub("%27", '"' , key)
         message("Searching ", key2)
         x3 <- search_lite( key )
         x$K <- x3
      }
      accs <- mg$accs[i]
      if(accs!=""){
         message("Searching ", accs)
         x4 <- search_lite( accs )
         x$A <- x4
      }

      ## COMBINE
      y <- ldply(x, "rbind", .id="id")
      n1 <- nrow(y)
      ## drop dates before 2004
      if( n1 > 0) {
         y  <-  subset(y, pubYear >= year)
         if(n1 > nrow(y) ) message("Dropped ", n1 - nrow(y), " pubs before ", year)
      }
      z <- ddply(y, names(y)[-1], summarize, search = paste(id, collapse=''))
      ## sort by pmid?
      z  <- z[order(z$pmid),]
      rownames(z) <- NULL
      pubs[[i]]<- z
  }
    if(length(pubs)==1) pubs <- pubs[[1]]
    pubs
}


