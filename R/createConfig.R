#' Create a Firebase Configuration YAML File
#'
#' This function generates a `config.yaml` file with Firebase project settings
#' and also updates the project's `.Renviron` file with the variables.
#'
#' @param api_key The Firebase API Key (required).
#' @param projectId The Firebase Project ID (required).
#' @param authDomain The Firebase Authentication Domain (required).
#' @param storageBucket The Firebase Storage Bucket (required).
#' @param databaseURL The Firebase Database URL (optional).
#' @param appId The Firebase App ID (optional).
#' @param output_dir A string specifying the directory where the `config.yaml` file will be saved.
#'                   Defaults to the current working directory. If the directory does not exist,
#'                   it will be created.
#' @return A message indicating the successful creation of the file and environment variables.
#' @examples
#' createConfig(
#'   api_key = "example-key",
#'   projectId = "example-id",
#'   authDomain = "example-auth",
#'   storageBucket = "example-bucket"
#' )
#' @import logger yaml
#' @export
createConfig <- function(api_key, projectId, authDomain, storageBucket, databaseURL = NULL, appId = NULL, output_dir = ".") {
  logger::log_appender(logger::appender_file("app.log"))
  logger::log_info("Starting to create config.yaml...")
  
  # Validate required parameters
  if (missing(api_key) || nchar(api_key) == 0) stop("'api_key' must be provided and non-empty.")
  if (missing(projectId) || nchar(projectId) == 0) stop("'projectId' must be provided and non-empty.")
  if (missing(authDomain) || nchar(authDomain) == 0) stop("'authDomain' must be provided and non-empty.")
  if (missing(storageBucket) || nchar(storageBucket) == 0) stop("'storageBucket' must be provided and non-empty.")
  
  # Ensure output directory exists
  if (!dir.exists(output_dir)) {
    logger::log_info("Output directory does not exist. Creating: {output_dir}")
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Define YAML content programmatically
  yaml_content <- list(
    default = list(
      FIREBASE_API_KEY = api_key,
      FIREBASE_PROJECT_ID = projectId,
      FIREBASE_AUTH_DOMAIN = authDomain,
      FIREBASE_STORAGE_BUCKET = storageBucket,
      FIREBASE_DATABASE_URL = databaseURL,
      FIREBASE_APP_ID = appId
    )
  )
  
  # Write YAML file
  file_path <- file.path(output_dir, "config.yaml")
  tryCatch({
    yaml::write_yaml(yaml_content, file_path)
    logger::log_info("config.yaml created at: {file_path}")
  }, error = function(e) {
    logger::log_error("Failed to write config.yaml: {e$message}")
    stop("Failed to write config.yaml: ", e$message)
  })
  
  # Prepare .Renviron content
  renviron_content <- c(
    paste0("FIREBASE_API_KEY=", api_key),
    paste0("FIREBASE_PROJECT_ID=", projectId),
    paste0("FIREBASE_AUTH_DOMAIN=", authDomain),
    paste0("FIREBASE_STORAGE_BUCKET=", storageBucket),
    if (!is.null(databaseURL)) paste0("FIREBASE_DATABASE_URL=", databaseURL) else NULL,
    if (!is.null(appId)) paste0("FIREBASE_APP_ID=", appId) else NULL
  )
  
  # Write to .Renviron
  renviron_path <- file.path(Sys.getenv("HOME"), ".Renviron")
  tryCatch({
    con <- file(renviron_path, open = "a")
    writeLines(renviron_content, con)
    close(con)
    logger::log_info(".Renviron file updated with environment variables.")
  }, error = function(e) {
    logger::log_error("Failed to update .Renviron: {e$message}")
    stop("Failed to update .Renviron: ", e$message)
  })
}
