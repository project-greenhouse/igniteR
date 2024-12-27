#' Get User Data using Firebase Auth REST API
#'
#' This function retrieves user profile data using an ID token via the Firebase 
#' Auth REST API. It retrieves Firebase configuration details from environment 
#' variables.
#'
#' @param idToken A string representing the Firebase ID token of the user.
#' @return A list containing the user profile data. Includes fields such as:
#' \itemize{
#'   \item localId: The unique identifier for the user.
#'   \item email: The user's email address.
#'   \item emailVerified: Boolean indicating if the email is verified.
#'   \item displayName: The user's display name (if set).
#'   \item photoUrl: The user's profile photo URL (if set).
#'   \item createdAt: Timestamp of account creation.
#'   \item lastLoginAt: Timestamp of last login.
#' }
#'
#' @section Common Error Codes:
#' \itemize{
#'   \item INVALID_ID_TOKEN: The provided ID token is invalid.
#'   \item USER_NOT_FOUND: The user corresponding to the ID token was not found.
#'   \item TOKEN_EXPIRED: The provided ID token has expired.
#' }
#'
#' @examples
#' \dontrun{
#' id_token <- "user-id-token"
#' user_data <- get_user(id_token)
#' print(user_data$email)
#' }
#' @import httr logger
#' @export
get_user <- function(idToken) {
  logger::log_appender(logger::appender_file("app.log"))
  logger::log_info("Attempting to retrieve user data")
  
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
  
  firebase_url <- paste0(
    "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=", 
    project_api_key
  )
  
  # Create the request payload
  payload <- list(
    idToken = idToken
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
    
    # Firebase returns user data in a 'users' array, typically with one user
    if (length(content$users) == 1) {
      user_data <- content$users[[1]]
      logger::log_info("Successfully retrieved user data for ID: {user_data$localId}")
      return(user_data)
    } else if (length(content$users) > 1) {
      logger::log_error("Unexpected multiple user records found.")
      stop("Unexpected multiple user records found for the provided ID token.")
    } else {
      logger::log_error("No user data found for the provided ID token.")
      stop("No user data found.")
    }
  } else {
    # Fallback for non-JSON error responses
    error_message <- tryCatch({
      httr::content(response, as = "text", type = "application/json")
    }, error = function(e) {
      httr::http_status(response)$message
    })
    
    logger::log_error("Failed to retrieve user data | Error: {error_message}")
    stop("Failed to retrieve user data: ", error_message)
  }
}
