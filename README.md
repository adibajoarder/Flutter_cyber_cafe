# ☕ Cyber Café App

A modern, visually stunning Flutter application designed for ordering premium drinks in a cyber café setting. This app features a complete end-to-end user flow from authentication to cart management and a simulated checkout process, all built with a dark-themed UI.

## ✨ Features

- **User Authentication**: Local login system using `SharedPreferences`.
- **Dynamic Menu**: Browse a variety of premium café drinks.
- **Cart Management**: Add, remove, and adjust quantities of drinks in the cart.
- **Checkout & Payment**: Simulated checkout flow with delivery location input and fake payment processing.
- **State Management**: Robust state handling using the `provider` package.
- **Premium UI**: Dark mode aesthetics with customized typography using `google_fonts` and vibrant color schemes.

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Local Storage**: [Shared Preferences](https://pub.dev/packages/shared_preferences)
- **Typography**: [Google Fonts](https://pub.dev/packages/google_fonts)
- **Formatting**: [Intl](https://pub.dev/packages/intl)

## 📂 Project Structure

```text
lib/
├── models/         # Data classes (Drink, User, CartItem, Order)
├── providers/      # State management (AuthProvider, CartProvider)
├── routes/         # Application routing configuration
├── screens/        # UI Screens (Home, Login, Cart, Checkout, Splash)
├── services/       # Business logic (AuthService, ApiService, PaymentService)
├── widgets/        # Reusable UI components (DrinkCard, CustomButton, etc.)
└── main.dart       # App entry point and theme configuration
```

## 🚀 Getting Started

Follow these steps to run the project locally.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version >=3.0.0)
- Android Studio / Xcode for emulators, or a connected physical device.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/cyber_cafe_app.git
   cd cyber_cafe_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 🎨 UI/UX Design

The application utilizes a dark theme by default, providing a "Cyber" aesthetic. 
- **Background Color**: `#0D0D1A`
- **Primary Accent**: `#6C63FF`
- **Secondary Accent**: `#xFFFF84`
- **Typography**: `Poppins` font family for a modern look.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! 

## 📝 License

This project is licensed under the MIT License.
