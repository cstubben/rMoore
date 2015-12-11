combine_pubs<- function(x, search ){
    if(!missing(search )){
        if(!search %in% c("*", "G", "K", "A")) stop("search should be *, G, K or A")  
        x <- lapply(x, function(x) x[grepl(search, x$search, fixed=TRUE),] )
    }
    # drop no matches (or ldply adds id column)
    x <- x[sapply(x, nrow)>0]
    y <- ldply(x, "rbind", .id="project")
    message(nrow(y), " rows")
    y
}
