# write to csv with excel HYPERLINKs

#source("~/Documents/R-packages/moore/R/summary_Excel.R")

summary_Excel <- function( mglist, mg, prefix="", outfile ){

    n <- length(mglist)
     if(nrow(mg)> n){
         mg3 <- subset(mg, Project %in% names(mglist),  c("Project", "ID") )
     }else{
       mg3 <- mg[, c("Project", "ID")]
     }

   mg3$Citations <- 0
   mg3$Genome <-0
   mg3$Keywords <- 0
   mg3$Accessions <- 0
    
   ## add year
    ##  PUB_YEAR:[2004 TO 2020] causes error even with encodings
   src <-  "%20AND%20SRC:MED"
   url <- "http://europepmc.org/search?query="

   for(i in 1:n ){

      x <- mglist[[i]]

      if(nrow(x) > 0 ){
         message("Row ", i)
         t1 <- paste0("Table_", prefix, i, ".html")
         ## link to DTs on Github (or local file?)
        # mg3$Citations[i] <- paste0( '=HYPERLINK("http://cstubben.github.io/genomes/tables/', t1, '", "', nrow(x),'")')     
         mg3$Citations[i] <- nrow(x)
         
         x1 <- table(unlist(strsplit(x$search, "")))

         if("G" %in%  names(x1)){
            n <- x1[names(x1)=="G"]
            # add link
            cite <- mg$cites[i]
            mg3$Genome[i] <- paste0('=HYPERLINK("', url, cite,  '", "',  n,  '")')
         }
         if("K" %in%  names(x1)){
            n <- x1[names(x1)=="K"]
            key <- URLencode(mg$keywords[i])
            mg3$Keywords[i] <-  paste0('=HYPERLINK("', url, '(', key,  ')', src , '", "',  n,  '")') 
         }
         if("A" %in%  names(x1)){
            n <- x1[names(x1)=="A"]
            accs <- URLencode( mg$accs[i])
            mg3$Accessions[i] <- paste0('=HYPERLINK("', url, '(', accs,  ')', src, '", "',  n,  '")') 
         }
      }
  }
    
   n <- !is.na(mg3$ID)
   mg3$ID[n] <- paste0('=HYPERLINK("http://www.ncbi.nlm.nih.gov/bioproject/',  mg3$ID[n], '", "',  mg3$ID[n],  '")')

   if(missing(outfile)){
       mg3
   }else{
      message("Writing tsv to ", outfile)
    write.table(mg3, file=outfile, sep="\t", quote=FALSE, row.names=FALSE)

  }
 
}
