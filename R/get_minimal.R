get_resource<- function(id, tbl){
  hdb <- Sys.getenv("HIDAPDB")
  con <- RSQLite::dbConnect(RSQLite::SQLite(), hdb)
  if(RSQLite::dbExistsTable(con, tbl)){
    sql = paste0("SELECT * FROM ",tbl," WHERE id = '",id,"'")
    dbq = dbGetQuery(con, sql)
  } else {
    return(NULL)
  }
  RSQLite::dbDisconnect(con)
  dbq
}

get_minimal <- function(id){
  get_resource(id, "minimal")
}

get_installation <- function(id){
  get_resource(id, "installation")
}

get_material_list <- function(id){
  get_resource(id, "material_list")
}

get_soil_analysis <- function(id){
  get_resource(id, "soil_analysis")
}

get_weather_data <- function(id){
  get_resource(id, "weather_data")
}

get_crop_management <- function(id){
  get_resource(id, "crop_management")
}

get_var_list <- function(id){
  get_resource(id, "var_list")
}

get_fieldbook <- function(id){
  get_resource(id, "fieldbook")
}

get_fieldtrial <- function(id){
  list(Minimal = get_minimal(id)[, -c(1:5)],
       Installation = get_installation(id)[, -c(1:5)],
       Material_list = get_material_list(id)[, -c(1:5)],
       Soil_analysis = get_soil_analysis(id)[, -c(1:5)],
       Weather_data = get_weather_data(id)[, -c(1:5)],
       Crop_management = get_crop_management(id)[, -c(1:5)],
       Var_list = get_var_list(id)[, -c(1:5)],
       Fieldbook = get_fieldbook(id)[, -c(1:5)]
       )
}


