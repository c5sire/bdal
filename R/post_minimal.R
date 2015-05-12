update_vals <- function(vals){
  out = character(length(vals))
  for(i in seq_along(colnames(vals))) {
    out[i] = paste(colnames(vals)[i], " = '", vals[[i]], "'", sep="")
  }
  paste(out, collapse = ", ")
}

insert_vals <- function(vals){
  out = character(length(vals))
  for(i in seq_along(colnames(vals))) {
    out[i] = paste("'", vals[[i]], "'", sep="")
  }
  paste(out, collapse = ", ")
  
}

update_resource <- function(adf, tbl, id_col){
  hdb <- Sys.getenv("HIDAPDB")
  if(nrow(adf)==0) return(TRUE)
  con <- RSQLite::dbConnect(RSQLite::SQLite(), hdb)
  # if table does not yet exist just drop in the new one
  if(!RSQLite::dbExistsTable(con, tbl)){
    return(post_resource(adf, tbl, hdb))
  }
  id = unique(adf$id)[1]
  # if table does exist check if anything for id is present; 
  # Order of following statements matters!
  if(RSQLite::dbExistsTable(con, tbl)){
    
    sql = paste0("SELECT * FROM ",tbl," WHERE id = '",id,"'")
    #sql = paste0("DELETE FROM minimal WHERE id = '",mm$id,"'")
    dbq = dbGetQuery(con, sql)
    # if not drop in table
    if(nrow(dbq) == 0) {
      return(post_resource(adf, tbl, hdb))
    }
  }
  
  # if table and id exist; id = fieldbook ID
  if(RSQLite::dbExistsTable(con, tbl)){
    
    sql = paste0("SELECT * FROM ",tbl," WHERE id = '",id,"'")
    dbq = dbGetQuery(con, sql)
    # get all Factor names for this fieldbook id and compare with those from adf
    fac_db <- dbq[[id_col]]
    fac_tb <- adf[[id_col]]
    # for those present in db and adf -> update
    fac_cm = fac_tb[fac_tb %in% fac_db]
    for(i in seq_along(fac_cm)) {
      mval <- adf[adf[[id_col]] == fac_cm[i], ]
      mval <- update_vals(mval)
      sql <- paste("UPDATE ",tbl," SET ",mval, " WHERE (id = '", id, "' AND ",
                   id_col," = '",
                   fac_cm[i], "')", sep="")
      print(sql)
      res <- RSQLite::dbSendQuery(con, sql)
    }
    # for those only present in adf -> insert
    fac_cm = fac_tb[!fac_tb %in% fac_db]
    for(i in seq_along(fac_cm)) {
      mval <- adf[adf$Factor==fac_cm[1], ]
      cols <- paste(colnames(mval), collapse = ", ")
      vals <- insert_vals(mval)
      sql <- paste("INSERT INTO ",tbl," (",cols,") VALUES (",
                    vals,")", sep="")
      res <- RSQLite::dbSendQuery(con, sql)
    }
    RSQLite::dbDisconnect(con)
  }
  TRUE
}



post_minimal <- function(adf){
  hdb <- Sys.getenv("HIDAPDB")
  update_resource(adf, "minimal", "Factor")
}

post_installation <- function(adf){
  hdb <- Sys.getenv("HIDAPDB")
  update_resource(adf, "installation", "Factor")
}

post_material_list <- function(adf){
  hdb <- Sys.getenv("HIDAPDB")
  if(nrow(adf)==0) stop("No data for material list!")
  nms <- c("numeration", "control", "genotype", "variety_name", "clone_code", "family_id", 
           "female_id", "female_code","male_id", "male_code", "seed_source", "other_trials", 
           "previous_trials")
  colnames(adf)[6:length(adf)] <- nms
  
  update_resource(adf, "material_list", "numeration")
}

post_soil_analysis <- function(adf){
  hdb <- Sys.getenv("HIDAPDB")
  if(nrow(adf)==0) return(TRUE)
  update_resource(adf, "soil_analysis", "Variables")
}

post_weather_data <- function(adf){
  hdb <- Sys.getenv("HIDAPDB")
  if(nrow(adf)==0) return(TRUE)
  row_id <- 1:nrow(adf)
  
  adf <- cbind(adf[, 1:6], row_id, adf[, 7:ncol(adf)])
  nms <- c("row_id","obs_date", "obs_hour", "precip", "tavg", "tmin", "tmax", 
           "rh", "rad","pressure", "dew_point", "wind_speed", "gust", 
           "wind_direction")
  colnames(adf)[6:length(adf)] <- nms
  
  update_resource(adf, "material_list", "row_id")
}

post_crop_management <- function(adf){
  hdb <- Sys.getenv("HIDAPDB")
  if(nrow(adf)==0) return(TRUE)
  row_id <- 1:nrow(adf)
  
  adf <- cbind(adf[, 1:6], row_id, adf[, 7:ncol(adf)], stringsAsFactors = FALSE)
  nms <- c("row_id","action_category", "action_type", "action_date", "operator", "observations", 
           "ingredient", 
           "concentration", "dose","uncertainty")
  colnames(adf)[6:length(adf)] <- nms
  
  update_resource(adf, "crop_management", "row_id")
}

post_var_list <- function(adf){
  hdb <- Sys.getenv("HIDAPDB")
  if(nrow(adf)==0) return(TRUE)
  nms <- c("variables","abbreviation", "fieldbook", "summarize", "analyze", "sel_direction", 
           "sel_weight", "min", "q1", "median", "mode", "q3", "max", "mean", "sd", "nval", "nmiss")
  colnames(adf)[6:length(adf)] <- nms
  
  update_resource(adf, "var_list", "row_id")
}

post_fieldbook <- function(adf){
  hdb <- Sys.getenv("HIDAPDB")
  if(nrow(adf)==0) return(TRUE)
  update_resource(adf, "fieldbook", "PLOT")
}


