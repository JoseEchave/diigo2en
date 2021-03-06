#' Import to Evernote all the new highlights
#'
#' Runs import_bookmarks() functions, filters new highlights and exports them to evernote with export_note_EN_enex() function
#'
#' @return Notes imported to Evernote
#' @export
#'
run_batch <- function(){
  date_txt_file <- system.file(file.path("last_updated","last_batch_run_date.txt"),package = "diigo2en")
data <- import_bookmarks()

#Define bookmarks without highlights
data$list_empty <- purrr::map_lgl(data[["annotations"]],~length(.x$content) == 0)

#Choose only new bookmarks (based on last EVERNOTE import date)
  last_update <- lubridate::ymd_hms(readr::read_file(date_txt_file),tz = "Europe/Helsinki")

#Since the notes are ordered by descending date we can just import the ones from 1:n
data_filt <- data[lubridate::ymd_hms(data$updated_at,tz = "Europe/Helsinki") > last_update &
    data$readlater == "no" & data$list_empty == FALSE,]

# Import batch of notes
purrr::walk(1:NROW(data_filt),~export_note_EN_enex(data_filt,.x))

#Save date of last run
cat(as.character(Sys.time()),file = date_txt_file)

# Delete enex files

enex_files <- list.files(path = system.file(file.path("temp_enex"),package = "diigo2en"),
  pattern = ".enex",full.names = TRUE)

file.remove(enex_files)

}
