#' get_study
#'
#' Get a section (=sheet) from a study.
#' 
#' @param study path to study
#' @param section section name
#' @return data.frame
#' @author Reinhard Simon
#' @family study
#' @export
get_study <- function(study, section=c("Fieldbook")) {
  stopifnot(is.character(study))
  stopifnot(is.character(section))
  
  openxlsx::read.xlsx(study, sheet = section)
}
