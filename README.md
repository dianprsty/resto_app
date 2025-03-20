# Resto App

A Flutter-based restaurant application that allows users to browse restaurants, view details, and manage favorites. This project is part of my final submission for IDCamp 2024.

## Features

- Browse restaurant list
- View restaurant details
- Add and remove favorites
- Local notifications
- Dark mode support
- Offline data storage
- Background scheduling with WorkManager

## Tech Stack

- **Flutter**
- **State Management**: Provider
- **Networking**: HTTP package
- **Local Storage**: SQFlite & Shared Preferences
- **UI Enhancements**: Google Fonts & Lottie Animations
- **Background Tasks**: WorkManager & Flutter Local Notifications

## Requirements

Before running this project, ensure you have the following installed:

- Flutter SDK (minimum version **3.6.1**)
- Dart SDK
- Android Studio or Visual Studio Code with Flutter extension
- Android Emulator or a physical device
- Internet connection for fetching restaurant data

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/dianprsty/resto_app.git
   ```
2. Navigate to the project directory:
   ```sh
   cd resto_app
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the application:
   ```sh
   flutter run
   ```

## Screenshots

| Home Screen                                | Restaurant Details                       | Restaurant Detail                         |
| ------------------------------------------ | ---------------------------------------- | ----------------------------------------- |
| ![Home Screen](assets/screenshot/home.png) | ![Details](assets/screenshot/detail.png) | ![Details](assets/screenshot/detail2.png) |

| Search Screen                                  | Setting Screen                           | Favorite Screen                                    |
| ---------------------------------------------- | ---------------------------------------- | -------------------------------------------------- |
| ![Search Screen](assets/screenshot/search.png) | ![Setting](assets/screenshot/detail.png) | ![Favorite Screen](assets/screenshot/favorite.png) |

| Loading Screen                                | Empty Screen                            | Splash Screen                            |
| --------------------------------------------- | --------------------------------------- | ---------------------------------------- |
| ![Home Screen](assets/screenshot/loading.png) | ![Details](assets/screenshot/empty.png) | ![Details](assets/screenshot/splash.png) |

## Contributions

Contributions are welcome! Feel free to fork this repository and submit a pull request.

## License

This project is licensed under the MIT License.

---
