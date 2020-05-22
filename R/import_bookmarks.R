#' Get hightlihgts from Diigo
#'
#' @param  username Diigo Username (recommended to save username, password and API in Keyring)
#' @param  pwd Diigo password
#' @param  API Diigo API
#' @return List with diigo highlights
#' @importFrom keyring key_get
#' @export
import_bookmarks <- function(username = keyring::key_get("diigo_username",keyring = "Diigo"),
  pwd = keyring::key_get("diigo_pwd",keyring = "Diigo"),
  API = keyring::key_get("diigo_API",keyring = "Diigo")){
  res <- httr::GET("https://secure.diigo.com/api/v2/bookmarks?",
    query = list(key = API,
      user = username,
      count = 60,
      sort = 1,
      filter = "all"),
    httr::authenticate(username, pwd))
   jsonlite::fromJSON(rawToChar(res$content))
}


