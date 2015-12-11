## requires Project,  cites, keywords and accs columns
citations <- function( mg, year=2004){
    
   if(!is.data.frame(mg)) stop("A data.frame is required")
   if(!all(c("cites", "keywords", "accs") %in% names(mg)) ) stop("Columns named cites, keywords and accs are required")
   n <- nrow(mg)
    
   pubs <- vector("list", n)
   names(pubs) <- mg$Project
    
   for(i in 1:n){
      x <- vector("list")
      ## ADD caption as attribute 
      name <- mg$Project[i]
      isMG <-  grepl("metagenome", name, ignore.case=TRUE)
      cap <- paste0("Publications mentioning the ", name)
      cap <- paste0(cap, ifelse(isMG,  ".", " genome.") )
      cap <- paste0(cap, " Last column lists searches in Europe PMC for")
        
      ## GENOME publication
      cite <- mg$cites[i]
      message("ROW ", i, ". ", name)
      if( cite!=""){
         cap <- paste0(cap, ifelse(isMG, " Metagenome", " Genome"))
         cap <- paste0(cap, " paper citations using ", cite, " and")  
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
         key2 <- gsub("%22", '"' , key)
         cap <- paste0(cap, " Keywords using ", key2)
         message("Searching ", key2)
         x3 <- search_lite( key )
         x$K <- x3
      }
      accs <- mg$accs[i]
        # skip "", " ", or NA
      if(nchar(accs) > 2  ){
         cap <- paste0(cap, " and Accessions using ", accs) 
         message("Searching ", accs)
         x4 <- search_lite( accs )
         x$A <- x4
      }
      cap <- paste0(cap, ".")
      
      ## COMBINE
      y <- ldply(x, "rbind", .id="id")
      n1 <- nrow(y)
      ## drop dates before 2004  (or run search with PUB_YEAR:[2004 TO 2020] ?)
      if( n1 > 0) {
         y  <-  subset(y, pubYear >= year)
         if(n1 > nrow(y) ) message("Dropped ", n1 - nrow(y), " pubs before ", year)   
         z <- ddply(y, names(y)[-1], summarize, search = paste(id, collapse=''))
         if( nrow(z) > 0){
            ## sort by pmid?
            z  <- z[order(z$pmid),]
            rownames(z) <- NULL
            attr(z, "caption") <- cap
            attr(z, "date") <- Sys.Date()
            pubs[[i]]<- z
        }else{
           pubs[[i]] <- data.frame()    #empty data.frame or leave null?
        }
      }
     # Sys.sleep(sample(1:3, 1))  # not sure how many queries/second are allowed at Europe PMC?
   }
   #if(length(pubs)==1) pubs <- pubs[[1]]
   pubs
}


