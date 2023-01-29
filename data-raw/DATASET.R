## EA wbid raw data from EA catchment explorer - REDUCE SIZE OF DATASET TO STORE IT IN r
# aa = read.csv("../../Downloads/England_classifications.csv") |>
#   dplyr::rename(
#     RBD = River.Basin.District,
#     OC = Operational.Catchment,
#     name = Water.Body,
#     WBID = Water.Body.ID,
#     MC = Management.Catchment
#   )
# saveRDS(aa,"data-raw/England_classifications.rds")

aa = readRDS("data-raw/England_classifications.rds")
ea_wbid_raw_data = distinct(aa,WBID,.keep_all = TRUE)
usethis::use_data(ea_wbid_raw_data, overwrite = TRUE)

## Reasons Dataframe
download_url = "https://environment.data.gov.uk/catchment-planning/WaterBody/GB70810015/rnags.csv"
temp_path = tempdir()
dir.create(temp_path)
river_output = paste0(temp_path, river_wbid, ".csv")
download.file(download_url, river_output)

river_class = read.csv(river_output) |> rename(
  RBD = River.Basin.District,
  OC = Operational.Catchment,
  name = Water.Body,
  WBID = Water.Body.ID,
  MC = Management.Catchment
)
file.remove(river_output)
reasons = river_class[0, ]
usethis::use_data(reasons, overwrite = TRUE)
