#' Delete User Account
#'
#' @description
#' Permanently deletes a user's account from Firebase Authentication.
#' Use with caution in Shiny applications as this action cannot be undone.
#'
#' @param idToken Character string. The Firebase ID token of the authenticated user.
#'
#' @return Invisible NULL on success, throws error on failure.
#'
#' @examples
#' \dontrun{
#' # After user confirms deletion
#' auth_result <- signInWithPassword("user@example.com", "password")
#' 
#' # Delete the account
#' deleteAccount(auth_result$idToken)
#' }
#'
#' @seealso
#' \code{\link{getUserData}} to verify account deletion and retrieve user profile data.
#'
#' @export
deleteAccount <- function(idToken) {
  logger::log_appender(logger::appender_file("app.log"))
  logger::log_info("Attempting to delete user account")
  
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
    "https://identitytoolkit.googleapis.com/v1/accounts:delete?key=", 
    project_api_key
  )
  
  # Create the request payload
  payload <- list(
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
    logger::log_info("Successfully deleted user account")
    invisible(NULL)
  } else {
    # Fallback for non-JSON error responses
    error_message <- tryCatch({
      httr::content(response, as = "text", type = "application/json")
    }, error = function(e) {
      httr::http_status(response)$message
    })
    
    logger::log_error("Failed to delete account | Error: {error_message}")
    stop("Failed to delete account: ", error_message)
  }
}
