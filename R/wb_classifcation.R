#' Get ecological classification data for a specified catchment and geography
#'
#' @param string NAME OF CLASSFICATION AREA E.G. RIVER TILL, THAMES,
#' @param column CLASSIFICATION TYPE E.G. OC (Operation Catchment) | MC (Management Catchment) | RBD (River Basin District). See more detail at https://environment.data.gov.uk/catchment-planning/
#' @return ECOLOGICAL CLASSIFICATION OF AREA


#### FUNCTION TO GET SF FEATURES OF WATERBODY
get_wb_classification = function(string, #### STRING = NAME OF CLASSFICATION AREA
                                 column) #### COLUMN  = CLASSIFICATION TYPE E.G. OC | MC | RBD
{
  #### LOAD WBID SCHEMA FROM CDE PACKAGE
  source("R/data.r")
  wbids = ea_wbid_raw_data
  #### LOGICAL OPERATOR FOR RIVER MINE
  if (column == "OC") {
    wb = wbids |> subset(OC == string)
  } # OPERATIONAL CATCHMENT
  if (column == "MC") {
    wb = wbids |> subset(MC == string)
  } # MANAGMENT CATCHMENT
  if (column == "RBD") {
    wb = wbids |> subset(RBD == string)
  }
  if (column == "WB") {
    wb = wbids |> subset(WBID == string)
  }# RIVER BASIN DISTRICT
  if (column != "OC" &
      column != "MC" & column != "RBD" & column != "WB") {
    message("Woops, looks like you declared an invalid column type. Please try E.G. OC | MC | RBD")
  } else{
    #### LOOP THROUGH GEOJSON DOWNLOAD
    suppressWarnings(for (i in 1:nrow(wb)) {
      ##### EA CATCHMNET API CALL
      url = "https://environment.data.gov.uk/catchment-planning/WaterBody/"
      notation = wb$WBID[i]
      download_url = paste0(url, notation, "/classifications.csv")

      #### SET OUTPUT PATH
      river_wbid = wb$WBID[i]
      temp_path = tempdir()
      dir.create(temp_path)
      river_output = paste0(temp_path, river_wbid, ".csv")

      #### DOWNLOOAD FILE, AT LEAST TRY TO
      tryCatch(
        expr = {
          download.file(download_url, river_output)
        },
        error = function(e) {
          message("Unable to download River Please check column and string are correct")
        }
      )

      river_class = read.csv(river_output) |> rename(RBD = River.Basin.District, OC = Operational.Catchment,name = Water.Body, WBID = Water.Body.ID,MC=Management.Catchment)
      names(river_class)[names(river_class) == "Water.Body.ID"] = "WBID"

      wb = rbind(river_class, wb)

      #### REMOPVE DOWNLOADED FILE
      file.remove(river_output)
    })
    return(wb)
  }
}
