
## write datatables and lib/  TO CURRENT DIRECTORY
# add options to set directory, change file and table names , output bib_format

write_pubs <- function( x, prefix="" ){

   for(i in 1: length(x) ){
      x1 <- x[[i]]
      if(nrow(x1) > 0 ){
         file1 <- paste0( "Table_", prefix, i, ".html")
         message("Writing ", names(x)[[i]], " to ", file1)
         ## add label to caption
         cap <- paste0("Table ", i, ". ", attr(x1, "caption"))
         x2 <- DT_format(x1)
         x2$search <- x1$search    # add search
         y <- datatable(x2, escape = c(4) , rownames=FALSE,
         caption = htmltools::tags$caption( style = 'text-align: left;', htmltools::p(cap)) )
         DT::saveWidget(y, file1, selfcontained=FALSE, libdir= "lib")  
      }
  }
}
