check_db_structure <- function(db_path){
  
}

clear_db <- function(con){
  dbRemoveTable(con, "crops")
  dbRemoveTable(con, "fieldbooks")
  dbRemoveTable(con, "programs")
  dbRemoveTable(con, "phases")
}

post_crop <- function(path, short, full, genus, species){
  if(is.null(path)) return(FALSE)
  db <- RSQLite::dbConnect(RSQLite::SQLite(), path)
  sql <- paste("INSERT INTO crops(crop_id, crop_name, genus, species) VALUES('",
                    short,"', '",
                    full,"', '",
                    genus, "', '", 
                    species,"')",
               sep="")
  res <- dbSendQuery(db, sql)
  dbDisconnect(db)
}


post_program <- function(path, crop_id, program_id, program_name, description){
  if(is.null(path)) return(FALSE)
  db <- RSQLite::dbConnect(RSQLite::SQLite(), path)
  sql <- paste("INSERT INTO programs(crop_id, program_id, program_name, description) VALUES('",
               crop_id,"', '",
               program_id,"', '",
               program_name, "', '", 
               description,"')",
               sep="")
  res <- dbSendQuery(db, sql)
  dbDisconnect(db)
}


post_program_phase <- function(path, crop_id, program_id, phase_id, phase_name, desciption){
  if(is.null(path)) return(FALSE)
  db <- RSQLite::dbConnect(RSQLite::SQLite(), path)
  sql <- paste("INSERT INTO phases(crop_id, program_id, phase_id, phase_name, description) VALUES('",
               crop_id,"', '",
               program_id,"', '",
               phase_id, "', '", 
               phase_name, "', '", 
               description,"')",
               sep="")
  res <- dbSendQuery(db, sql)
  dbDisconnect(db)
  
}

post_fieldbook <- function(fieldbook, path, crop_id, program_id, phase_id){
  if(is.null(path)) return(FALSE)
  db <- RSQLite::dbConnect(RSQLite::SQLite(), path)
  sql <- paste("INSERT INTO phases(crop_id, program_id, phase_id, phase_name, description) VALUES('",
               crop_id,"', '",
               program_id,"', '",
               phase_id, "', '", 
               phase_name, "', '", 
               description,"')",
               sep="")
  res <- dbSendQuery(db, sql)
  dbDisconnect(db)
  
}

# post_germplasm

# post_location

# post_variable

# post_factor

# post_template


#' init_db
#' 
#' initialize the database
#' 
#' @param path path to master directory
#' @return logical TRUE for success
#' @export
init_db <- function(path = NULL) {
  if(is.null(path)) return(FALSE)
  db <- RSQLite::dbConnect(RSQLite::SQLite(), path)
  if(!dbExistsTable(db, "crops")){
    dbSendQuery(conn = db,
                "CREATE TABLE crops
                (id INTEGER PRIMARY KEY,
                crop_id TEXT,
                crop_name TEXT,
                genus TEXT,
                species TEXT
                )")
    post_crop(path, "PT", "potato", "Solanum", "tuberosum" )
    post_crop(path, "SP", "sweetpotato", "Ipomoea", "batatas" )
    post_crop(path, "CS", "cassava", "Manihot", "esculentum" )
    
    
  }
  
  if(!dbExistsTable(db, "programs")){
    dbSendQuery(conn = db,
                "CREATE TABLE programs
                (id INTEGER PRIMARY KEY,
                crop_id TEXT,
                program_id TEXT,
                program_name TEXT,
                description TEXT
                )")
    post_program(path, "PT", "YL", "Yield", "some text")
  }
  
  if(!dbExistsTable(db, "phases")){
    dbSendQuery(conn = db,
                "CREATE TABLE phases
                (id INTEGER PRIMARY KEY,
                crop_id TEXT,
                program_id TEXT,
                phase_id TEXT,
                phase_name TEXT,
                description TEXT
                )")
    post_program(path, "PT", "YL", "Yield", "some text")
  }
  
  
    
  if(!dbExistsTable(db, "fieldbooks")){
    dbSendQuery(conn = db,
                "CREATE TABLE fieldbooks
                (id INTEGER PRIMARY KEY,
                fb_name TEXT,
                crop_id TEXT,
                program_id TEXT,
                phase_id TEXT,
                subtype TEXT,
                version TEXT,
                imported TEXT,
                modified TEXT
                )")
    
  }
  
  if(!dbExistsTable(db, "germplasm_list")){
    dbSendQuery(conn = db,
                "CREATE TABLE germplasm_list
                (id INTEGER PRIMARY KEY,
                germplasm_list_id TEXT,
                germplasm_list_name TEXT,
                crop_id TEXT,
                germplasm_list_type TEXT,
                description TEXT
                )")
  }
  
  if(!dbExistsTable(db, "germplasm")){
    dbSendQuery(conn = db,
                "CREATE TABLE germplasm
                (id INTEGER PRIMARY KEY,
                germplasm_id TEXT,
                stock_id TEXT,
                germplasm_name TEXT,
                crop_id TEXT,
                germplasm_list_id TEXT,
                pedigree TEXT,
                origin TEXT,
                vines_per_plot TEXT,
                description TEXT
                )")
    
  }
  
  
}

register_crop <- function(con, crop) {
  
}
