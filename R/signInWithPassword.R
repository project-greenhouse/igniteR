#' Sign In with Email and Password
#'
#' @description
#' Authenticates a user using their email and password through Firebase Authentication.
#' Designed for use in Shiny applications to manage user sessions.
#'
#' @param email Character string. The user's email address.
#' @param password Character string. The user's password.
#'
#' @return A list containing:
#' \itemize{
#'   \item idToken - The Firebase ID token for the user
#'   \item email - The user's email address
#'   \item refreshToken - Token that can be used to refresh the ID token
#'   \item expiresIn - Token expiration time in seconds
#'   \item localId - The uid of the authenticated user
#' }
#'
#' @examples
#' \dontrun{
#' # In a Shiny app
#' auth_result <- signInWithPassword(
#'   email = "user@example.com",
#'   password = "userpassword"
#' )
#' 
#' # Use the token for authenticated requests
#' user_data <- getUserData(auth_result$idToken)
#' }
#'
#' @seealso
#' \code{\link{signUpWithPassword}} for creating new accounts
#' \code{\link{resetPassword}} for password reset functionality
#'
#' @export
signInWithPassword <- function(email, password) {
  logger::log_appender(logger::appender_file("app.log"))
  logger::log_info("Attempting to sign in user with email: {email}")
  
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
  
  if (missing(password) || !is.character(password) || nchar(password) == 0) {
    logger::log_error("Invalid or missing password.")
    stop("'password' must be a non-empty string.")
  }
  
  firebase_url <- paste0("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=", project_api_key)
  
  # Create the request payload
  payload <- list(
    email = email,
    password = password,
    returnSecureToken = TRUE
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
    content <- httr::content(response, as = "parsed", type = "application/json")
    logger::log_info("User signed in successfully: {email}")
    return(list(
      idToken = content$idToken,
      email = content$email,
      refreshToken = content$refreshToken,
      expiresIn = content$expiresIn,
      localId = content$localId
    ))
  } else {
    # Fallback for non-JSON error responses
    error_message <- tryCatch({
      httr::content(response, as = "text", type = "application/json")
    }, error = function(e) {
      httr::http_status(response)$message
    })
    
    logger::log_error("Failed to sign in user: {email} | Error: {error_message}")
    stop("Failed to sign in: ", error_message)
  }
}
