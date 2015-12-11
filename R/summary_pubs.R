## include code for DT, excel instead of separate functions
summary_pubs <- function( mglist, mg , format, ...){
 if(missing(format)){
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
     
   for(i in 1:n ){

      x <- mglist[[i]]

      if(nrow(x) > 0 ){
        mg3$Citations[i] <-  nrow(x)
         x1 <- table(unlist(strsplit(x$search, "")))

         if("G" %in%  names(x1)){
            n <- x1[names(x1)=="G"]
            mg3$Genome[i] <- n
         }
         if("K" %in%  names(x1)){
            n <- x1[names(x1)=="K"]
            mg3$Keywords[i] <-  n
         }
         if("A" %in%  names(x1)){
            n <- x1[names(x1)=="A"]
            mg3$Accessions[i] <- n
         }
      }
   }
   mg3[, -2]   # drop project ID?
 }else{
    if(tolower(format) %in% c("dt","datatable")){
      summary_DT(mglist, mg, ...)
    }else{
      summary_Excel(mglist, mg, ...)
    }
 }
}
