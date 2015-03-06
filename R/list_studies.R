#' list_studies
#'
#' List all studies for a given crop and database.
#' 
#' Currently returns a list of short hand name for display and full path name. The latter 
#' may change in a future revision.
#'
#' @param crop a crop name
#' @param database path
#' @return list of study names and access paths
#' @author author
#' @family study
#' @export
list_studies <- function(crop = "potato", 
                         database = "D:/DataCollector/DC4RT/data") {
  stopifnot(is.character(crop))
  stopifnot(is.character(database))
  files <- list.files(file.path(database,crop), recursive = TRUE)
  studies <- basename(files)
  studies <- stringr::str_replace_all(studies, ".xlsx", "")                         
  path <- file.path(database, crop, files)
  list(study = studies, path = path)
}

