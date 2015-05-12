#' post_resource
#' 
#' saves a data frame in a local database
#' 
#' @aliases post_resource
#' @export
#' @param adf a data frame
#' @param tbl a table in a local database
#' @param db path to a local database
#' @param overwrite default is FALSE
#' @param append default is TRUE
#' @return boolean TRUE for success
#' @author Reinhard Simon
post_resource <- function(adf, tbl, db, overwrite=FALSE, append=TRUE ){
  if(!file.exists(db)) stop(paste(db, "does not exist!"))
  con <- RSQLite::dbConnect(RSQLite::SQLite(), db)
  RSQLite::dbWriteTable(con, value = adf, name = tbl, overwrite = overwrite,
                        append = append)
  RSQLite::dbDisconnect(con)
}

