#' Change User Password using Firebase Auth REST API
#'
#' This function changes the password of a user using the Firebase Auth REST API.
#'
#' @param idToken A string representing the Firebase ID token of the user.
#' @param newPassword A string representing the new password.
#' @return A list containing the response, including the updated tokens if successful.
#'
#' @section Common Error Codes:
#' \itemize{
#'   \item INVALID_ID_TOKEN: The provided ID token is invalid.
#'   \item WEAK_PASSWORD: The new password is not strong enough.
#'   \item CREDENTIAL_TOO_OLD_LOGIN_AGAIN: The user needs to sign in again before changing the password.
#' }
#'
#' @examples
#' \dontrun{
#' id_token <- "user-id-token"
#' new_password <- "newsecurepassword"
#' response <- change_password(id_token, new_password)
#' print(response)
#' }
#' @import httr logger
#' @export
change_password <- function(idToken, newPassword) {
  logger::log_appender(logger::appender_file("app.log"))
  logger::log_info("Attempting to change password for user.")
  
  # Retrieve Firebase variables from environment
  project_api_key <- Sys.getenv("FIREBASE_API_KEY")
  if (project_api_key == "") {
    logger::log_error("FIREBASE_API_KEY is not set in the environment.")
    stop("Environment variable FIREBASE_API_KEY is missing.")
  }
  
  # Validate inputs
  if (missing(idToken)) {
    logger::log_error("ID token is missing.")
    stop("'idToken' must be provided.")
  }
  
  if (missing(newPassword)) {
    logger::log_error("New password is missing.")
    stop("'newPassword' must be provided.")
  }
  
  if (nchar(newPassword) < 8) {
    logger::log_error("Password is too weak.")
    stop("'newPassword' must be at least 6 characters long.")
  }
  
  firebase_url <- paste0(
    "https://identitytoolkit.googleapis.com/v1/accounts:update?key=", 
    project_api_key
  )
  
  # Create the request payload
  payload <- list(
    idToken = idToken,
    password = newPassword,
    returnSecureToken = TRUE
  )
  
  # Send the POST request
  response <- httr::POST(
    url = firebase_url,
    body = jsonlite::toJSON(payload, auto_unbox = TRUE),
    encode = "json",
    httr::content_type("application/json")
  )
  
  # Handle response
  if (httr::http_status(response)$category == "Success") {
    content <- httr::content(response, as = "parsed", type = "application/json")
    logger::log_info("Password changed successfully.")
    return(content)
  } else {
    error_message <- httr::content(response, as = "text", type = "application/json")
    logger::log_error("Failed to change password | Error: {error_message}")
    stop("Failed to change password: ", error_message)
  }
}
