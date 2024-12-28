#' Change User Email using Firebase Auth REST API
#'
#' This function changes the email address of a user using the Firebase Auth REST API.
#'
#' @param idToken A string representing the Firebase ID token of the user.
#' @param newEmail A string representing the new email address.
#' @param returnSecureToken Optional boolean. If TRUE, returns a new ID and refresh token.
#' @return A list containing the updated user data and new tokens if requested.
#'
#' @section Common Error Codes:
#' \itemize{
#'   \item INVALID_ID_TOKEN: The provided ID token is invalid.
#'   \item EMAIL_EXISTS: The email address is already in use by another account.
#'   \item INVALID_EMAIL: The email address is not valid.
#'   \item CREDENTIAL_TOO_OLD_LOGIN_AGAIN: The user needs to sign in again before changing email.
#' }
#'
#' @examples
#' \dontrun{
#' id_token <- "user-id-token"
#' new_email <- "newemail@example.com"
#' result <- change_email(id_token, new_email)
#' }
#' @import httr logger
#' @export
change_email <- function(idToken, newEmail, returnSecureToken = FALSE) {
  logger::log_appender(logger::appender_file("app.log"))
  logger::log_info("Attempting to change user email")
  
  # Retrieve Firebase variables from environment
  project_api_key <- Sys.getenv("FIREBASE_API_KEY")
  if (project_api_key == "") {
    logger::log_error("FIREBASE_API_KEY is not set in the environment.")
    stop("Environment variable FIREBASE_API_KEY is missing.")
  }
  
  # Validate inputs
  if (missing(idToken) || !is.character(idToken) || nchar(idToken) == 0) {
    logger::log_error("ID token is missing or invalid.")
    stop("'idToken' must be a non-empty string.")
  }
  
  if (missing(newEmail) || !is.character(newEmail) || nchar(newEmail) == 0) {
    logger::log_error("New email is missing or invalid.")
    stop("'newEmail' must be a non-empty string.")
  }
  
  firebase_url <- paste0(
    "https://identitytoolkit.googleapis.com/v1/accounts:update?key=", 
    project_api_key
  )
  
  # Create the request payload
  payload <- list(
    idToken = idToken,
    email = newEmail,
    returnSecureToken = returnSecureToken
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
    logger::log_info("Successfully changed email to: {newEmail}")
    return(content)
  } else {
    # Fallback for non-JSON error responses
    error_message <- tryCatch({
      httr::content(response, as = "text", type = "application/json")
    }, error = function(e) {
      httr::http_status(response)$message
    })
    
    logger::log_error("Failed to change email | Error: {error_message}")
    stop("Failed to change email: ", error_message)
  }
}
