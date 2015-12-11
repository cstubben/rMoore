
unique_pubs <- function(x, ...){

   x<- suppressMessages( combine_pubs(x, ...) )
   # drop search column
   x <- x[ , -14]
   y <- ddply(x, names(x)[-1], summarize, n=length(project), projects = paste(project, collapse=', '))
   message(nrow(y), " rows")
   y

}
