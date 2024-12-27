# igniteR <img src="man/figures/shinyIgniteR_hex_cloud_orange.png" alt="igniteR logo with a cloud and orange background" align="right" width="120"/>

**Simplified use of Firebase Authentication for Shiny Apps**

<!-- badges: start -->

[![R-CMD-check](https://github.com/project-greenhouse/igniteR/actions/workflows/R-CMD-check.yml)/badge.svg)](https://github.com/project-greenhouse/igniteR/actions/workflows/R-CMD-check.yml)
[![Last-changedate](https://img.shields.io/badge/last%20change-2024--12--27-yellowgreen.svg)](https://github.com/project-greenhouse/igniteR/commits/main)
[![license](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://choosealicense.com/licenses/gpl-3.0/)
[![minimal R version](https://img.shields.io/badge/R%3E%3D-4.1.0-6666ff.svg)](https://cran.r-project.org/)
[![Project Status: Active – The project is currently in beta or experimental phase.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![packageversion](https://img.shields.io/badge/Package%20version-0.1.0-orange.svg?style=flat-square)](https://github.com/project-greenhouse/igniteR/commits/main)
[![thanks-md](https://img.shields.io/badge/THANKS-md-ff69b4.svg)](THANKS.md)

<!-- badges: end -->

**igniteR** is an R package designed to streamline the integration of Firebase Authentication services into R applications, particularly Shiny apps. It provides functions to manage user authentication and account operations via the Firebase Authentication REST API. With tools for signing in, signing up, password resets, email verification, and account management, igniteR simplifies the implementation of secure authentication workflows for R developers.

## Features

- **Authentication**: Securely identify app users with Firebase Authentication.
- **Account Management**: Manage user accounts, including user creation, deletion, password reset, and email verification.
- **Configuration**: Create `config.yaml` and update `.Renviron` with `createConfig`, to scale the use of Firebase projects and Authentication services into different R projects.

## Installation

igniteR is currently under development. Once released, you can install it directly from CRAN:

```R
install.packages("igniteR")
```

To install the development version from GitHub, use:

```R
# install.packages("devtools")
devtools::install_github("project-greenhouse/igniteR")
```

## Usage

Here's a quick example to get started:

```R
library(igniteR)

# Set up your Firebase project credentials
createConfig(
  api_key = "YOUR_API_KEY",
  projectId = "YOUR_PROJECT_ID",
  authDomain = "YOUR_AUTH_DOMAIN",
  storageBucket = "YOUR_STORAGE_BUCKET"
)

# Sign up a new user
signUpWithPassword("user@example.com", "password123")

# Sign in an existing user
auth <- signInWithPassword("user@example.com", "password123")

# Send a password reset email
resetPassword("user@example.com")
```

## Getting Started

1. **Create a Firebase Project**: If you don’t already have a Firebase project, set one up at [Firebase Console](https://console.firebase.google.com/).
2. **Enable the REST API**: Ensure the Firebase REST API is enabled in your project settings.
3. **Install igniteR**: Install the development version of igniteR using the instructions above.

## Contributing

We welcome contributions! If you’d like to report issues, suggest features, or contribute code, please check out our [Contributing Guidelines](CONTRIBUTING.md).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Firebase](https://firebase.google.com/) for their powerful platform.
- The R community for making data-driven development accessible and innovative.
