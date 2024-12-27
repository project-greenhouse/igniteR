#' Send Password Reset Email using Firebase Auth REST API
#'
#' This function sends a password reset email to the specified email address using 
#' the Firebase Auth REST API. It retrieves Firebase configuration details from 
#' environment variables.
#'
#' @param email A string representing the user's email address.
#' @return Invisible NULL on success, throws an error on failure.
#'
#' @section Common Error Codes:
#' \itemize{
#'   \item EMAIL_NOT_FOUND: There is no user record corresponding to this email.
#'   \item INVALID_EMAIL: The email address is not valid.
#' }
#'
#' @examples
#' \dontrun{
#' email <- "user@example.com"
#' reset_password(email)
#' }
#' @import httr logger
#' @export
reset_password <- function(email) {
  logger::log_appender(logger::appender_file("app.log"))
  logger::log_info("Attempting to send password reset email to: {email}")
  
  # Retrieve Firebase variables from environment
  project_api_key <- Sys.getenv("FIREBASE_API_KEY")
  if (project_api_key == "") {
    logger::log_error("FIREBASE_API_KEY is not set in the environment.")
    stop("Environment variable FIREBASE_API_KEY is missing.")
  }
  
  # Validate inputs
  if (missing(email) || !is.character(email) || nchar(email) == 0) {
    logger::log_error("Invalid or missing email.")
    stop("'email' must be a non-empty string.")
  }
  
  if (!grepl("^[\\w.+\\-]+@[a-zA-Z\\d\\-]+\\.[a-zA-Z]{2,}$", email)) {
    logger::log_error("Invalid email format: {email}")
    stop("Provided 'email' is not a valid email address.")
  }
  
  firebase_url <- paste0(
    "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=", 
    project_api_key
  )
  
  # Create the request payload
  payload <- list(
    requestType = "PASSWORD_RESET",
    email = email
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
    logger::log_info("Password reset email sent successfully to: {email}")
    invisible(NULL) # Return NULL as the function doesn't generate additional output
  } else {
    # Fallback for non-JSON error responses
    error_message <- tryCatch({
      httr::content(response, as = "text", type = "application/json")
    }, error = function(e) {
      httr::http_status(response)$message
    })
    
    logger::log_error("Failed to send password reset email: {email} | Error: {error_message}")
    stop("Failed to send password reset email: ", error_message)
  }
}
