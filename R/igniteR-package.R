#' igniteR: Firebase Authentication for R
#'
#' The igniteR package provides a comprehensive interface to the Firebase 
#' Authentication REST API. It allows R users to integrate Firebase Authentication 
#' into their applications, enabling user management, session handling, and profile updates.
#'
#' @section Main Features:
#' \itemize{
#'   \item **User Authentication**:
#'     \itemize{
#'       \item \code{\link{sign_in_password}} - Sign in with email and password
#'       \item \code{\link{sign_in_oauth}} - Sign in with OAuth providers
#'       \item \code{\link{sign_up_password}} - Create new user accounts
#'     }
#'   \item **Account Management**:
#'     \itemize{
#'       \item \code{\link{reset_password}} - Send password reset emails
#'       \item \code{\link{change_email}} - Update user email
#'       \item \code{\link{delete_account}} - Delete user accounts
#'     }
#'   \item **Email Operations**:
#'     \itemize{
#'       \item \code{\link{send_email_verification}} - Send email verification
#'     }
#'   \item **User Data Management**:
#'     \itemize{
#'       \item \code{\link{get_user}} - Retrieve user profile data
#'     }
#' }
#'
#' @section Configuration:
#' Before using the package, configure your Firebase project:
#' \itemize{
#'   \item Set the `FIREBASE_API_KEY` environment variable with your Firebase API key.
#'   \item Refer to Firebase's REST API documentation for additional details.
#' }
#'
#' @examples
#' \dontrun{
#' # Sign up a new user
#' sign_up_password("user@example.com", "password123")
#'
#' # Sign in
#' auth <- sign_in_password("user@example.com", "password123")
#'
#' # Get user profile
#' profile <- get_user(auth$idToken)
#' }
#'
#' @keywords internal
"_PACKAGE"

