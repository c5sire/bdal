library(magrittr)



#' get_crop
#' 
#' get crops
#' 
#' @export
get_crop <- function(path = NULL){
#   fn <- file.path(get_dp_path(), "crops")
#   list.dirs(fn, rec=FALSE) %>% basename()
  if(is.null(path)) return(FALSE)
  db <- RSQLite::dbConnect(RSQLite::SQLite(), path)
  data <- dbSendQuery(db, "SELECT crop_name FROM crops")
  data <- dbFetch(data)
  dbDisconnect(db)
  
  data <- unique(data)
  data[, 1]
}

#' get_crop
#' 
#' get crops
#' 
#' @export
get_program <- function(crop){
  fn <- file.path(get_dp_path(), "crops", crop, "programs")
  list.dirs(fn, rec=FALSE) %>% basename()
}

#' get_fieldbook
#'
#' Get a fieldbook.
#' 
#' @param id a fieldbook name
#' @param crop name of crop
#' @param program name of breeding program
#' @param section section name
#' @return list of fieldbooks
#' @author Reinhard Simon
#' @family fieldbook
#' @export
get_fieldbook <- function(fieldbook, crop="", program="", section="") {
  stopifnot(is.character(fieldbook))
  stopifnot(is.character(section))

  out=list()
  
  if(fieldbook=="") {
    fn <- file.path(get_dp_path())
    crops <- get_crop()
    for(i in 1:lenth(fn)){
      out[i] <- get_program(crops[i])
      
      
    }
  }
  out
}
