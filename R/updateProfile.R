#' Update User Profile
#'
#' @description
#' Updates a user's profile information in Firebase Authentication.
#' Commonly used in Shiny apps to manage user profile data.
#'
#' @param idToken Character string. The Firebase ID token of the authenticated user.
#' @param displayName Optional character string. The user's new display name.
#' @param photoUrl Optional character string. URL of the user's new profile photo.
#'
#' @return A list containing the updated profile information, including:
#' \itemize{
#'   \item displayName: The user's updated display name.
#'   \item photoUrl: The user's updated profile photo URL.
#'   \item email: The user's email address.
#'   \item localId: The unique identifier for the user.
#' }
#'
#' @section Common Error Codes:
#' \itemize{
#'   \item INVALID_ID_TOKEN: The provided ID token is invalid.
#'   \item USER_DISABLED: The user account has been disabled.
#'   \item TOKEN_EXPIRED: The provided ID token has expired.
#' }
#'
#' @examples
#' \dontrun{
#' # In a Shiny app
#' auth_result <- signInWithPassword("user@example.com", "password")
#' 
#' # Update the user's profile
#' updated_profile <- updateProfile(
#'   idToken = auth_result$idToken,
#'   displayName = "New Name",
#'   photoUrl = "https://example.com/photo.jpg"
#' )
#' }
#'
#' @seealso
#' \code{\link{getUserData}} for retrieving user profile information
#'
#' @export
updateProfile <- function(idToken, displayName = NULL, photoUrl = NULL) {
  logger::log_appender(logger::appender_file("app.log"))
  logger::log_info("Attempting to update user profile")
  
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
  
  if (is.null(displayName) && is.null(photoUrl)) {
    logger::log_error("No update parameters provided.")
    stop("At least one of 'displayName' or 'photoUrl' must be provided.")
  }
  
  if (!is.null(photoUrl) && !grepl("^https?://", photoUrl)) {
    logger::log_error("Invalid photo URL format: {photoUrl}")
    stop("Provided 'photoUrl' must be a valid URL starting with 'http://' or 'https://'.")
  }
  
  firebase_url <- paste0(
    "https://identitytoolkit.googleapis.com/v1/accounts:update?key=", 
    project_api_key
  )
  
  # Create the request payload
  payload <- list(
    idToken = idToken,
    returnSecureToken = TRUE
  )
  
  if (!is.null(displayName)) payload$displayName <- displayName
  if (!is.null(photoUrl)) payload$photoUrl <- photoUrl
  
  # Send the POST request
  response <- httr::POST(
    url = firebase_url,
    body = httr::toJSON(payload, auto_unbox = TRUE),
    encode = "json",
    httr::content_type("application/json")
  )
  
  # Handle response
  if (httr::http_status(response)$category == "Success") {
    content <- httr::content(response, as = "parsed", type = "application/json")
    logger::log_info("Successfully updated user profile")
    return(content)
  } else {
    # Fallback for non-JSON error responses
    error_message <- tryCatch({
      httr::content(response, as = "text", type = "application/json")
    }, error = function(e) {
      httr::http_status(response)$message
    })
    
    logger::log_error("Failed to update profile | Error: {error_message}")
    stop("Failed to update profile: ", error_message)
  }
}
