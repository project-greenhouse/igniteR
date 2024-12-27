#' Sign Up with Email and Password using Firebase Auth REST API
#'
#' This function creates a new user account using their email and password via the Firebase 
#' Auth REST API. It retrieves Firebase configuration details directly from 
#' environment variables.
#'
#' @param email A string representing the user's email address.
#' @param password A string representing the user's password.
#' @return A list containing the authentication response. Includes fields such as:
#' \item{idToken}{The ID token to authenticate with Firebase services.}
#' \item{refreshToken}{The token to refresh the ID token when it expires.}
#' \item{localId}{The unique identifier for the user.}
#'
#' @section Common Error Codes:
#' \itemize{
#'   \item EMAIL_EXISTS: The email address is already in use by another account.
#'   \item OPERATION_NOT_ALLOWED: Email/password accounts are not enabled.
#'   \item WEAK_PASSWORD: The password is too weak.
#' }
#'
#' @examples
#' \dontrun{
#' email <- "newuser@example.com"
#' password <- "newuserpassword"
#' user_data <- sign_up_password(email, password)
#' print(user_data$localId)
#' }
#' @import httr logger
#' @export
sign_up_password <- function(email, password) {
  logger::log_appender(logger::appender_file("app.log"))
  logger::log_info("Attempting to sign up user with email: {email}")
  
  # Retrieve Firebase variables from environment
  project_api_key <- Sys.getenv("FIREBASE_API_KEY")
  if (project_api_key == "") {
    logger::log_error("FIREBASE_API_KEY is not set in the environment.")
    stop("Environment variable FIREBASE_API_KEY is missing.")
  }
  
  # Validate inputs
  if (missing(email) || missing(password)) {
    logger::log_error("Email or password is missing.")
    stop("Both 'email' and 'password' must be provided.")
  }
  
  firebase_url <- paste0("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=", project_api_key)
  
  # Create the request payload
  payload <- list(
    email = email,
    password = password,
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
    logger::log_info("User signed up successfully: {email}")
    return(content)
  } else {
    error_message <- httr::content(response, as = "text", type = "application/json")
    logger::log_error("Failed to sign up user: {email} | Error: {error_message}")
    stop("Failed to sign up: ", error_message)
  }
}
