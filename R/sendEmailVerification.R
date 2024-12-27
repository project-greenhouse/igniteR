#' Send Email Verification
#'
#' @description
#' Sends a verification email to the user's email address.
#' Important for maintaining verified user status in Shiny applications.
#'
#' @param idToken Character string. The Firebase ID token of the authenticated user.
#'
#' @return Invisible NULL on success, throws error on failure.
#'
#' @examples
#' \dontrun{
#' # After user signs in
#' auth_result <- signInWithPassword("user@example.com", "password")
#' 
#' # Send verification email
#' sendEmailVerification(auth_result$idToken)
#' }
#'
#' @seealso
#' \code{\link{getUserData}} to check email verification status
#'
#' @export
sendEmailVerification <- function(idToken) {
  logger::log_appender(logger::appender_file("app.log"))
  logger::log_info("Attempting to send verification email")
  
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
    "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=", 
    project_api_key
  )
  
  # Create the request payload
  payload <- list(
    requestType = "VERIFY_EMAIL",
    idToken = idToken
  )
  
  # Send the POST request
  response <- httr::POST(
    url = firebase_url,
    body = httr::toJSON(payload, auto_unbox = TRUE),
    encode = "json",
    httr::content_type("application/json")
  )
  
  # Handle response
  if (httr::http_status(response)$category == "Success") {
    logger::log_info("Verification email sent successfully.")
    invisible(NULL) # Return as documented
  } else {
    # Fallback for non-JSON error responses
    error_message <- tryCatch({
      httr::content(response, as = "text", type = "application/json")
    }, error = function(e) {
      httr::http_status(response)$message
    })
    
    logger::log_error("Failed to send verification email | Error: {error_message}")
    stop("Failed to send verification email: ", error_message)
  }
}
