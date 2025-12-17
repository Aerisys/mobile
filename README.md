# Aerisys Mobile 🛸

**Locate your bro with a NOTIFICATION.**

Aerisys is a Flutter-based mobile application designed for drone tracking and camera connectivity.

---

## 🏗 Architecture

The project follows the **MVVM (Model-View-ViewModel)** pattern combined with **Clean Architecture** principles to ensure the code is testable and scalable.

* **View:** Flutter widgets that display the UI (e.g., `LocationPage`, `HomePage`).
* **ViewModel:** Handles business logic and state using `Provider` (e.g., `MapViewModel`).
* **Services:** Wrappers for external APIs like Firebase Auth, Firestore, and Geolocator.
* **DI (Dependency Injection):** Managed via `GetIt` for efficient service discovery.

---

## 🚀 Features

* **Real-time Tracking:** Live GPS positioning using `geolocator` and `flutter_map`.
* **Drone Dashboard:** A centralized hub to access drone controls, settings, and location data.
* **Firebase Integration:** * **Authentication:** Secure login and registration.


---

## 🛠 Tech Stack

* **Frontend:** [Flutter](https://flutter.dev) (SDK ^3.10.4)
* **State Management:** [Provider](https://pub.dev/packages/provider)
* **Service Locator:** [GetIt](https://pub.dev/packages/get_it)
* **Navigation:** [GoRouter](https://pub.dev/packages/go_router)
* **Database/Auth:** [Firebase](https://firebase.google.com)
* **Maps:** [Flutter Map](https://pub.dev/packages/flutter_map) (OpenStreetMap tiles)

---

## 📦 Getting Started

### Prerequisites

* Flutter SDK installed.
* Firebase CLI installed and logged in (`firebase login`).
* FlutterFire CLI activated (`dart pub global activate flutterfire_cli`).

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/your-username/aerisys-mobile.git
cd aerisys-mobile

```


2. **Install dependencies:**
```bash
flutter pub get

```


3. **Configure Firebase:**
   Since `firebase_options.dart` is git-ignored for security, generate it using:
```bash
flutterfire configure

```


4. **Run the App:**
```bash
flutter run

```



---

## 📂 Project Structure

```text
lib/
├── core/                # DI, Routing, Themes, and Global Services
│   ├── di.dart          # GetIt Registration
│   ├── routes/          # GoRouter Configuration
│   └── services/        # Firebase & GPS Logic
├── data/                # Models, Enums, and Constants
├── presentation/        # UI Layer
│   ├── view_models/     # State and Business Logic
│   └── views/           # Flutter Screen Widgets
└── firebase_options.dart # Generated Firebase config

```

---

