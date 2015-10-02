## Extraction
void_snps_stats <- function(x) {
  a <- names(x)[ !(names(x) %in% snpstatnames) ]
  x[,a]
} 

void_ped_stats <- function(x) {
  a <- names(x)[ !(names(x) %in% pedstatnames) ]
  x[,a]
} 

setMethod("[", signature(x="bed.matrix",i="numeric",j="missing", drop="missing"), 
    function( x, i, j) {    
      x@bed <- .Call('gg_extract_inds_indices', x@bed, i) 
      x@ped <- x@ped[i,]
      x@snps <- void_snps_stats(x@snps)
      x
    } );

setMethod("[", signature(x="bed.matrix",i="logical",j="missing", drop="missing"), 
    function( x, i, j) {    
      x@bed <- .Call('gg_extract_inds_bool', x@bed, i) 
      x@ped <- x@ped[i,]
      x@snps <- void_snps_stats(x@snps)
      x
    } );
  
setMethod("[", signature(x="bed.matrix",i="missing",j="numeric", drop="missing"), 
    function( x, i, j) {    
      x@bed <- .Call('gg_extract_snps_indices', x@bed, j) 
      x@snps <- x@snps[j,]
      x@p <- x@p[j]
      x@mu <- x@mu[j]
      x@sigma <- x@sigma[j]
      x@ped <- void_ped_stats(x@ped)
      x
    } );
  
setMethod("[", signature(x="bed.matrix",i="missing",j="logical", drop="missing"), 
    function( x, i, j) {    
      x@bed <- .Call('gg_extract_snps_bool', x@bed, j)
      x@snps <- x@snps[j,]
      x@p <- x@p[j]
      x@mu <- x@mu[j]
      x@sigma <- x@sigma[j]
      x@ped <- void_ped_stats(x@ped)
      x
    } );
  
setMethod("[", signature(x="bed.matrix",i="logical",j="logical", drop="missing"), 
    function( x, i, j) {    
      x@bed <- .Call('gg_extract_snps_bool', x@bed, j)
      x@snps <- x@snps[j,]
      x@p <- x@p[j]
      x@mu <- x@mu[j]
      x@sigma <- x@sigma[j]

      x@bed <- .Call('gg_extract_inds_bool', x@bed, i) 
      x@ped <- x@ped[i,]
      x@ped <- void_ped_stats(x@ped)
      x@snps <- void_snps_stats(x@snps)
      x
    } );
  

setMethod("[", signature(x="bed.matrix",i="logical",j="numeric", drop="missing"), 
    function( x, i, j) {    
      x@bed <- .Call('gg_extract_snps_indices', x@bed, j) 
      x@snps <- x@snps[j,]
      x@p <- x@p[j]
      x@mu <- x@mu[j]
      x@sigma <- x@sigma[j]

      x@bed <- .Call('gg_extract_inds_bool', x@bed, i) 
      x@ped <- x@ped[i,]
      x@ped <- void_ped_stats(x@ped)
      x@snps <- void_snps_stats(x@snps)
      x
    } );

setMethod("[", signature(x="bed.matrix",i="numeric",j="logical", drop="missing"), 
    function( x, i, j) {    
      x@bed <- .Call('gg_extract_snps_bool', x@bed, j)
      x@snps <- x@snps[j,]
      x@p <- x@p[j]
      x@mu <- x@mu[j]
      x@sigma <- x@sigma[j]

      x@bed <- .Call('gg_extract_inds_indices', x@bed, i) 
      x@ped <- x@ped[i,]
      x@ped <- void_ped_stats(x@ped)
      x@snps <- void_snps_stats(x@snps)
      x
    } );
  

setMethod("[", signature(x="bed.matrix",i="numeric",j="numeric", drop="missing"), 
    function( x, i, j) {    
      x@bed <- .Call('gg_extract_snps_indices', x@bed, j) 
      x@snps <- x@snps[j,]
      x@p <- x@p[j]
      x@mu <- x@mu[j]
      x@sigma <- x@sigma[j]

      x@bed <- .Call('gg_extract_inds_indices', x@bed, i) 
      x@ped <- x@ped[i,]
      x@ped <- void_ped_stats(x@ped)
      x@snps <- void_snps_stats(x@snps)
      x
    } );
