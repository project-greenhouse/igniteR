##' Sign In with OAuth using Firebase Auth REST API
#'
#' This function signs in a user using OAuth credentials via the Firebase Auth REST API.
#'
#' @param provider A string representing the OAuth provider (e.g., "google.com", "facebook.com").
#' @param accessToken A string representing the OAuth access token.
#' @return A list containing the authentication response including idToken, refreshToken, etc.
#'
#' @section Common Error Codes:
#' \itemize{
#'   \item INVALID_PROVIDER_ID: The provider ID is invalid.
#'   \item INVALID_OAUTH_TOKEN: The OAuth token is invalid.
#'   \item INVALID_OAUTH_PROVIDER: The OAuth provider is invalid.
#' }
#'
#' @examples
#' \dontrun{
#' provider <- "google.com"
#' access_token <- "oauth-access-token"
#' auth_result <- sign_in_oauth(provider, access_token)
#' }
#' @import httr logger
#' @export
sign_in_oauth <- function(provider, accessToken) {
  logger::log_appender(logger::appender_file("app.log"))
  logger::log_info("Attempting to sign in with OAuth provider: {provider}")
  
  # Retrieve Firebase variables from environment
  project_api_key <- Sys.getenv("FIREBASE_API_KEY")
  if (project_api_key == "") {
    logger::log_error("FIREBASE_API_KEY is not set in the environment.")
    stop("Environment variable FIREBASE_API_KEY is missing.")
  }
  
  # Validate inputs
  if (missing(provider) || missing(accessToken)) {
    logger::log_error("Provider or access token is missing.")
    stop("Both 'provider' and 'accessToken' must be provided.")
  }
  
  if (!provider %in% c("google.com", "facebook.com", "twitter.com", "github.com")) {
    logger::log_error("Invalid provider: {provider}")
    stop("The 'provider' must be one of: 'google.com', 'facebook.com', 'twitter.com', or 'github.com'.")
  }
  
  firebase_url <- paste0(
    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=", 
    project_api_key
  )
  
  # Create the request payload
  payload <- list(
    requestUri = "http://localhost",
    postBody = paste0(
      "access_token=", accessToken,
      "&providerId=", provider
    ),
    returnSecureToken = TRUE,
    returnIdpCredential = TRUE
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
    logger::log_info("Successfully signed in with OAuth")
    return(content)
  } else {
    # Fallback for non-JSON error responses
    error_message <- tryCatch({
      httr::content(response, as = "text", type = "application/json")
    }, error = function(e) {
      httr::http_status(response)$message
    })
    
    logger::log_error("Failed to sign in with OAuth | Error: {error_message}")
    stop("Failed to sign in with OAuth: ", error_message)
  }
}
