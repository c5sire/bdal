#library(shiny)

#' app_view_study
#'
#' Creates a shiny widget to display the study in tabular form.
#' 
#' @param data a data.frame
#' @return character a string; default is 'Hello, world!'
#' @author Reinhard Simon
#' @family study, app
#' @export
app_view_study <- function(data) {
  #stopifnot(is.character(name))
  
  shinyApp(
    ui = fluidPage( 
      dataTableOutput('mytable1')
    ),
    server = function(input, output) {
      output$mytable1 <- renderDataTable({
        data # this gets the data.frame
      }, options = list(lengthMenu = c(5, 20, 50), pageLength = 20))
    },
    options = list(height = 500)
  )
} 
