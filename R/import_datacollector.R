library(magrittr)

get_minimal_meta <- function (minimal) {
  id <- minimal[minimal$Factor == "Short name or Title", "Value"]
  crop <- stringr::str_sub(id, 1, 2)
  year <- as.integer(stringr::str_sub(id, 5, 8))
  locality <- stringr::str_sub(id, 12, stringr::str_length(id))
  list(id = id, crop = crop, year= year, locality =locality)
}

prepend_meta <- function(db, mm){
  n <- nrow(db)
  pre <- cbind(id  = rep(mm$id, n),
               crop = rep(mm$crop, n),
               program = rep("", n),
               year = rep(mm$year, n),
               locality = rep(mm$locality, n)
  )
  
  
  adf <- cbind(pre, db)
  adf[, 1] <- as.character(adf[, 1])
  adf[, 2] <- as.character(adf[, 2])
  adf[, 3] <- as.character(adf[, 3])
  adf[, 4] <- as.integer(as.character(adf[, 4]))
  adf[, 5] <- as.character(adf[, 5])
  adf
}


import_datacollector <- function(filepath){
  if(!file.exists(filepath)) stop(paste(filepath,"does not exist!"))
  minimal <- readxl::read_excel(filepath, "Minimal")
  mm <- get_minimal_meta(minimal)

  minimal %>% prepend_meta(mm) %>% post_minimal()
  readxl::read_excel(filepath, "Installation")%>%  prepend_meta(mm) %>% post_installation()
  readxl::read_excel(filepath, "Material List")%>%  prepend_meta(mm) %>% post_material_list()
  readxl::read_excel(filepath, "Soil_analysis")%>%  prepend_meta(mm) %>% post_soil_analysis()
  readxl::read_excel(filepath, "Weather_data")%>%  prepend_meta(mm) %>% post_weather_data()
  readxl::read_excel(filepath, "Crop_management")%>%  prepend_meta(mm) %>% post_crop_management()
  readxl::read_excel(filepath, "Var List")%>%  prepend_meta(mm) %>% post_var_list()
  readxl::read_excel(filepath, "Fieldbook")%>%  prepend_meta(mm) %>% post_fieldbook()
}
