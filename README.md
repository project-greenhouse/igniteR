# IgniteR

**IgniteR** is an R package that simplifies interaction with the [Firebase REST API](https://firebase.google.com/docs/reference/rest). Designed for R users, it provides tools to authenticate, query, and manage Firebase data, making it easier to integrate Firebase capabilities into your data workflows.

## Features

- **Authentication**: Securely connect to Firebase using API keys and authentication tokens.
- **Data Management**: Retrieve, write, and update data in your Firebase Realtime Database or Firestore.
- **Cloud Functions**: Trigger and interact with Firebase Cloud Functions directly from R.
- **Scalability**: Build scalable applications with Firebase services integrated seamlessly into R projects.

## Installation

IgniteR is currently under development. Once released, you can install it directly from CRAN:

```R
install.packages("IgniteR")
```

To install the development version from GitHub, use:

```R
# install.packages("devtools")
devtools::install_github("your-username/IgniteR")
```

## Usage

Here's a quick example to get started:

```R
library(IgniteR)

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
3. **Install IgniteR**: Install the development version of IgniteR using the instructions above.

## Contributing

We welcome contributions! If you’d like to report issues, suggest features, or contribute code, please check out our [Contributing Guidelines](CONTRIBUTING.md).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Firebase](https://firebase.google.com/) for their powerful platform.
- The R community for making data-driven development accessible and innovative.
