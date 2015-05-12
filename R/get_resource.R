#' get_resource
#' 
#' reads a data frame in a local database
#' 
#' @aliases get_resource
#' @export
#' @param tbl a table in a local database
#' @param db path to a local database
#' @return a dataframe
#' @author Reinhard Simon
get_resource <- function(tbl, db){
  if(!file.exists(db)) stop(paste(db, "does not exist!"))
  con <- RSQLite::dbConnect(RSQLite::SQLite(), db)
  tbl <- RSQLite::dbReadTable(con, tbl)
  RSQLite::dbDisconnect(con)
  tbl
}

