#library(tidyverse)
library(stringr)
library(magrittr)
library(lubridate)
library(here)


#' Import highlights into Evernote
#'
#' @param  list List of highlights (get them with import_bookmarks())
#' @param  note_num Note number from the highlight list
#' @param exe_path Path for Evernote executable
#' @param inbox_folder Evernote notebook where to save the notes
#' @return Enex notes are saved and command prompt is run
#' @importFrom magrittr "%>%"
#' @export
export_note_EN_enex <- function(list,
  note_num,
  exe_path = "C:/Users/jose_sanz/AppData/Local/Apps/Evernote/Evernote/ENScript.exe",
  inbox_folder = "[Inbox]"){
  ls <- list
  num <- note_num
  enex_folder <- system.file(file.path("temp_enex"),package = "diigo2en")

  title <- ls[["title"]][[num]] %>%
    stringr::str_replace_all("&","and") %>% #Avoid errors caused by including & in the title
    strtrim(250 - 12) %>%  # Limit characters in title
    paste0(" [From Diigo]")

  updated_at <- ls[["updated_at"]][[num]] %>%
    lubridate::ymd_hms(tz = "EET") %>%  #Does timezone matter?
    strftime(format = "%Y%m%dT%H%M%SZ")

  url <- ls[["url"]][[num]] %>%
    stringr::str_extract("([^\\=]*)") # Cut the url where there are = signs

  aq <- function(text) paste0('"',text,'"')


  note_text_lines <- ls[["annotations"]][[num]]$content
  note_text <- paste0("<div>",note_text_lines ,"</div>",collapse = "") %>%
    stringr::str_replace_all("<br>","<br/>") %>%  #Avoid unclosed <br> tags
    stringr::str_replace_all('(class|font)="[^"]*"',"")


  note_text_br_closed <- paste0(note_text,"</br>")

  enex_text <- glue::glue('
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE en-export SYSTEM "http://xml.evernote.com/pub/evernote-export2.dtd">
    <en-export export-date="20200428T103521Z" application="Evernote/Windows" version="6.x">
    <note>
    <title> {title} </title>
    <content><![CDATA[<?xml version="1.0" encoding="utf-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
    <en-note>
    {note_text}
    </en-note>]]>
    </content>
    <created>{updated_at}</created>
    <note-attributes>
    <author>jmechavesanz</author>
    <source>Clearly</source>
    <source-url> {url} </source-url>
    </note-attributes>
    </note>
    </en-export>')

  cat(enex_text,file = paste0(enex_folder,"/","note_",num,".enex"))
  file_path <- list.files(path = paste0(enex_folder),
    pattern = paste0("note_",num,".enex"),full.names = TRUE)

  command <- paste0(exe_path," importNotes  /s ",aq(file_path)," /n ",aq(inbox_folder))
  system(command)

}

