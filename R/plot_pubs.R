# cumulative sum in year_ts = TRUE
plot_pubs <- function(x, search, sum=TRUE, log=TRUE, main= "", ylabel="Total citations" ){
    if(!missing(search )){
        #plot by project, so "*" will have one point and not work
        if(!search %in% c( "G", "K", "A")) stop("search should be G, K or A")  
        x <- lapply(x, function(x) x[grepl(search, x$search, fixed=TRUE),] )
   }
   # drop no matches (or ldply adds id column)
   x <- x[sapply(x, nrow)>0]
   # could allow option for years, but if sum=TRUE, then all years are needed!
    maxYear <- format(Sys.Date(), "%Y")
    minYear <- min(unlist( sapply(x, "[[", "pubYear")) )
   y <-  do.call("cbind", lapply(x, function(x) as.xts(year_ts(x, minYear, maxYear, sum ))))
   # replace dot with space in names like  Alteromonas.macleodii.EZ55
   dimnames(y)[[2]] <- names(x)
   ## PLOT
   dygraph( y, main = main ) %>%
     dyAxis("x" , rangePad=15 , drawGrid=FALSE, axisLabelFormatter = "function(d){ return d.getFullYear() }") %>% 
     dyAxis("y" , rangePad=5, label = ylabel, drawGrid=FALSE)  %>%
     dyOptions(logscale= log )  %>%
     dyHighlight(highlightSeriesOpts = list(strokeWidth = 3))  %>%
     dyLegend(width=350) %>%
     dyCSS( system.file("extdata", "dygraph1.css", package = "rMoore"))

}


