# file prefix for links, default "" = Table_1.html or  "m" = Table_m1.html 
# should add attributes to citations output and not require mg table as input..

summary_DT <- function( mglist, mg, prefix="", caption = "" , outfile ){

   n <- length(mglist)
   if(nrow(mg)> n){
         mg3 <- subset(mg, Project %in% names(mglist),  c("Project", "ID", "PubMed") )
   }else{
       mg3 <- mg[, c("Project", "ID", "PubMed")]
   }
   mg3$Publication <- ""
   mg3$Citations <- 0
   mg3$Genome <-0
   mg3$Keywords <- 0
   mg3$Accessions <- 0
     
   ## Link counts may include some results before 2004, since adding PUB_YEAR:[2004 TO 2020]
   ##  to query changes to [2004 to 2020] in DT and query fails
   src <-  "%20AND%20SRC:MED"
   url <- "http://europepmc.org/search?query="
    
   for(i in 1:n ){
      x <- mglist[[i]]
      if(nrow(x) > 0 ){
       #  message("Row ", i)
         file1 <- paste0("Table_", prefix, i, ".html")
         ## ON GitHub
           #  mg3$Citations[i] <- paste0( '<a href="http://cstubben.github.io/genomes/tables/', file1, '">', nrow(x), '</a>')
         # current directory
        mg3$Citations[i] <- paste0( '<a href="', file1, '">', nrow(x), '</a>')
         
         if( ! is.na(mg3$PubMed[i] ) ){
            mg3$Publication[i] <- bib_format(subset(x, grepl("*", search, fixed=TRUE)))
         }
         x1 <- table(unlist(strsplit(x$search, "")))

         if("G" %in%  names(x1)){
            n <- x1[names(x1)=="G"]
            # add link
            cite <- mg$cites[i]
            mg3$Genome[i] <- paste0('<a href="', url, cite,  '">',  n,  '</a>')
         }
         if("K" %in%  names(x1)){
            n <- x1[names(x1)=="K"]
            key <- URLencode(mg$keywords[i])
            mg3$Keywords[i] <-  paste0('<a href="', url, '(', key,  ')', src , '">',  n,  '</a>') 
         }
         if("A" %in%  names(x1)){
            n <- x1[names(x1)=="A"]
            accs <- URLencode( mg$accs[i])    
            mg3$Accessions[i] <- paste0('<a href="', url, '(', accs,  ')', src, '">',  n,  '</a>') 
         }
      }
   }
   ## link Bioproject ID and Pubmed
   n <- !is.na(mg3$PubMed)
   mg3$PubMed[n] <-   paste0('<a href="http://europepmc.org/abstract/MED/',  mg3$PubMed[n], '">', mg3$PubMed[n],  '</a>')
   n <- !is.na(mg3$ID)
   mg3$ID[n] <-   paste0('<a href="http://www.ncbi.nlm.nih.gov/bioproject/',  mg3$ID[n], '">', mg3$ID[n],  '</a>')
   ## 
   #mg3

   # Only display first 100 characters of publication
   y <- datatable(mg3, escape = c(1,5),  caption=caption, options = list(columnDefs = list(list(
   targets =4,
    render = JS(
      "function(data, type, row, meta) {",
      "return type === 'display' && data.length > 100 ?",
      "'<span title=\"' + data + '\">' + data.substr(0, 100) + '...</span>' : data;",
    "}")
    ))))

   if(missing(outfile)){
       y
   }else{
      message("Writing DT to ", outfile)
      DT::saveWidget(y, outfile, selfcontained=FALSE, libdir= "lib")  
  }

}
