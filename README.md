# igniteR v0.1.0 <img src="man/figures/shinyIgniteR_hex_cloud_orange.png" align="right" width="120"/>

**Simplified use of Firebase Authentication for Shiny Apps**

<!-- badges: start -->

[![R-CMD-check](https://github.com/project-greenhouse/igniteR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/project-greenhouse/igniteR/actions/workflows/R-CMD-check.yaml)
[![Last-changedate](https://img.shields.io/badge/last%20change-2024--08--27-yellowgreen.svg)](/commits/master)
[![license](https://img.shields.io/badge/license-MIT%20+%20file%20LICENSE-lightgrey.svg)](https://choosealicense.com/)
[![minimal R
version](https://img.shields.io/badge/R%3E%3D-3.5.0-6666ff.svg)](https://cran.r-project.org/)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![packageversion](https://img.shields.io/badge/Package%20version-1.1.3-orange.svg?style=flat-square)](commits/master)
[![thanks-md](https://img.shields.io/badge/THANKS-md-ff69b4.svg)](THANKS.md)

<!-- badges: end -->

**igniteR** is an R package that simplifies interaction with the [Firebase REST API](https://firebase.google.com/docs/reference/rest). Designed for R users, it provides tools to authenticate, query, and manage Firebase data, making it easier to integrate Firebase capabilities into your data workflows.

## Features

- **Authentication**: Securely connect to Firebase using API keys and authentication tokens.
- **Data Management**: Retrieve, write, and update data in your Firebase Realtime Database or Firestore.
- **Cloud Functions**: Trigger and interact with Firebase Cloud Functions directly from R.
- **Scalability**: Build scalable applications with Firebase services integrated seamlessly into R projects.

## Installation

igniteR is currently under development. Once released, you can install it directly from CRAN:

```R
install.packages("igniteR")
```

To install the development version from GitHub, use:

```R
# install.packages("devtools")
devtools::install_github("your-username/igniteR")
```

## Usage

Here's a quick example to get started:

```R
library(igniteR)

# Set up your Firebase project credentials
firebase_config <- firebase_auth(api_key = "YOUR_API_KEY", project_id = "YOUR_PROJECT_ID")

# Retrieve data from a Firebase Realtime Database
data <- firebase_get(firebase_config, path = "/your/data/path")

# Write data to Firebase
firebase_put(firebase_config, path = "/your/data/path", data = list(name = "Example", value = 123))
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
