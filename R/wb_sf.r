#' Fetch GeoJson data for waterbody
#'
#' @param string NAME OF CLASSFICATION AREA E.G. RIVER TILL, THAMES,
#' @param column CLASSIFICATION TYPE E.G. OC | MC | RBD
#' @return Spatial dataframe



get_wb_sf = function(string, #### STRING = NAME OF CLASSFICATION AREA E.G. RIVER TILL
                     column) #### COLUMN  = CLASSIFICATION TYPE E.G. OC | MC | RBD
{
  source("R/data.r")
  wbids = ea_wbid_raw_data
  #### LOGICAL OPERATOR FOR RIVER MINE
  if (column == "OC") {wb = wbids |> subset(OC == string)} # OPERATIONAL CATCHMENT
  if (column == "MC") {wb = wbids |> subset(MC == string)} # MANAGMENT CATCHMENT
  if (column == "RBD") {wb = wbids |> subset(RBD == string)} # RIVER BASIN DISTRICT
  if(column != "OC" & column != "MC" & column != "RBD"){
    message("Woops, looks like you declared an invalid column type. Please try E.G. OC | MC | RBD")
  } else{
    message("Running function:")
    #### SET EMPTY DF TO MERGE INTO
    nrows = 1
    wb_sf = st_sf(id = 1:nrows, geometry = st_sfc(lapply(1:nrows, function(x)
      st_geometrycollection())))
    st_crs(wb_sf) = 4326 #### SET CRS TO MATCH THAT OF THE EA
    wb_sf$name = ""
    wb_sf$id = as.character(wb_sf$id)
    wb_sf = wb_sf |> filter(name == "nun") #### CLEAR ANY VALUES IN DF

    #### LOOP THROUGH GEOJSON DOWNLOAD
    suppressWarnings(
      for (i in 1:nrow(wb)) {
        ##### EA CATCHMNET API CALL
        url = "https://environment.data.gov.uk/catchment-planning/WaterBody/"
        notation = wb$WBID[i]
        download_url = paste0(url, notation, ".geojson")

        #### SET OUTPUT PATH
        river_wbid = wb$WBID[i]
        temp_path = tempdir()
        dir.create(temp_path)
        river_output = paste0(temp_path, river_wbid, ".geojson")

        #### DOWNLOOAD FILE, AT LEAST TRY TO
        tryCatch(
          expr = {
            download.file(download_url, river_output)
          },
          error = function(e) {
            message("Unable to download River Please check column and string are correct")
          }
        )

        river_sf = read_sf(river_output)
        river_sf = river_sf[,"id","name"]

        wb$geometry[i] = river_sf$geometry[1]

        #### REMOPVE DOWNLOADED FILE
        file.remove(river_output)
      }
    )
    return(wb)
  }
}
