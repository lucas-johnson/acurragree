#' ssd
#' 
#' sum of square difference
#' 
#' @param x a vector of numeric values
#' @param y a vector of numeric values
#' @param na.rm boolean flag indicating whether or not to remove NA values from
#'   computation
#'   
#' @return numeric value
#'
#' @examples
ssd <- function(x, y, na.rm = F) {
    assertthat::assert_that(length(x) == length(y))
    return(sum((x - y) ^ 2, na.rm = na.rm ))
}

#' msd
#' 
#' Mean squared difference
#'
#' @inheritParams ssd
#'
#' @return numeric value
#'
#' @examples
msd <- function(x, y, na.rm = F) {
    
    assertthat::assert_that(length(x) == length(y))
    if (na.rm) {
        xy <- vec_narm(x, y)
        x <- xy$x
        y <- xy$y
    }
    n <- length(x)
    ssd(x, y, na.rm = na.rm) / n
}

#' spod
#'
#' Sum of potential difference 
#'
#' @inheritParams ssd
#'
#' @return numeric value
#'
#' @examples
spod <- function(x, y, na.rm = F) {
    
    assertthat::assert_that(length(x) == length(y))
    if (na.rm) {
        xy <- vec_narm(x, y)
        x <- xy$x
        y <- xy$y
    }
    xbar <- mean(x)
    ybar <- mean(y)
    diff_xbar <- abs(x - xbar)
    diff_ybar <- abs(y - ybar)
    sum(
        (abs(xbar - ybar) + diff_xbar) * (abs(xbar - ybar) + diff_ybar)
    )
}

#' Unsystematic sum of product-difference
#'
#' @inheritParams spod
#'
#' @return numeric value
#'
#' @examples
spdu <- function(x, y, na.rm = F) {
    
    assertthat::assert_that(length(x) == length(y))
    if (na.rm) {
        xy <- vec_narm(x, y)
        x <- xy$x
        y <- xy$y
    }
    gmfr_xy <- gmfr(x, y, na.rm)
    sum(
        abs(x - gmfr_xy$x) * abs(y - gmfr_xy$y)
    )
}


#' mpdu
#' 
#' Unsystematic mean product-difference.
#'
#' @inheritParams spdu
#'
#' @return numeric value
#'
#' @examples
mpdu <- function(x, y, na.rm = F) {
    
    assertthat::assert_that(length(x) == length(y))
    if (na.rm) {
        xy <- vec_narm(x, y)
        x <- xy$x
        y <- xy$y
    }
    n <- length(x)
    spdu(x, y, na.rm = na.rm) / n
}

#' pud
#' 
#' Percentage of unsystematic difference
#'
#' @inheritParams mpdu
#'
#' @return numeric value bounded \[0, 1\]
#' @export
#'
#' @examples
pud <- function(x, y, na.rm = F) {
    mpdu(x, y, na.rm = na.rm) / msd(x, y, na.rm = na.rm)
}

#' spds
#' 
#' Systematic sum of product-difference
#'
#' @inheritParams spdu
#'
#' @return numeric value
#'
#' @examples
spds <- function(x, y, na.rm = F) {
    
    assertthat::assert_that(length(x) == length(y))
    ssd(x, y, na.rm = na.rm) - spdu(x, y, na.rm = na.rm)
}

#' mpds
#'
#' Systematic mean product-difference
#' 
#' @inheritParams spds
#'
#' @return numeric value
#'
#' @examples
mpds <- function(x, y, na.rm = F) {
    
    assertthat::assert_that(length(x) == length(y))
    if (na.rm) {
        xy <- vec_narm(x, y)
        x <- xy$x
        y <- xy$y
    }
    n <- length(x)
    spds(x, y, na.rm = na.rm) / n
}

#' psd
#' 
#' Percentage of systematic difference
#'
#' @inheritParams mpds
#'
#' @return numeric value bounded \[0, 1\]
#' 
#' @export
#'
#' @examples
psd <- function(x, y, na.rm = F) {
    
    mpds(x, y, na.rm = na.rm) / msd(x, y, na.rm = na.rm)
}

#' ac
#' 
#' Compute agreement coefficient (AC) following Ji and Gallo 2006
#' 
#' AC is bounded between 0 and 1 where 1 represents perfect agreement and 0
#' represents no agreement.
#' 
#' @inheritParams spds
#' 
#' @return a numeric value bounded \[0, 1\]
#' @export
#'
#' @examples
ac <- function(x, y, na.rm = F) {
    1 - (ssd(x, y, na.rm = na.rm) / spod(x, y, na.rm = na.rm))
}


#' acs
#' 
#' Compute systematic agreement coefficient (ACs) following Ji and Gallo 2006
#' 
#' ACs is bounded between 0 and 1 where 1 represents perfect agreement and 0
#' represents no agreement.
#'
#' @inheritParams ac
#'
#' @return a numeric value bounded \[0, 1\]
#' @export
#'
#' @examples
acs <- function(x, y, na.rm = F) {
    
    1 - (spds(x, y, na.rm = na.rm) / spod(x, y, na.rm = na.rm))
}

#' acu
#' 
#' Compute unsystematic agreement coefficient (ACu) following Ji and Gallo 2006
#' 
#' ACu is bounded between 0 and 1 where 1 represents perfect agreement and 0
#' represents no agreement.
#'
#' @inheritParams ac
#' 
#' @return a numeric value bounded \[0, 1\]
#' @export
#'
#' @examples
acu <- function(x, y, na.rm = F) {
    
    1 - (spdu(x, y, na.rm = na.rm) / spod(x, y, na.rm = na.rm))
}
