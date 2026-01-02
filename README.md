# NeonFinance: Personal Finance Manager

> A fully offline, secure, and feature-rich personal finance management application built with Flutter. Track your expenses and income with ease, visualize your spending habits, and take control of your financial life.

## ✨ Core Features

*   **Offline First:** Your data is your own. All information is stored locally on your device using the powerful and fast **Hive** database, ensuring complete privacy and functionality without an internet connection.
*   **Transaction Management:** Effortlessly add, edit, and delete income and expense transactions.
*   **Custom Categories:** Create and manage your own spending categories, complete with custom colors and icons for easy identification.
*   **Data Visualization:** A beautiful and interactive chart on the statistics screen helps you visualize your financial data and understand your spending patterns.
*   **Theme Customization:** Switch between a sleek light mode and a cool dark mode to match your preference.
*   **Data Portability:** Export your transaction data for backup purposes and import it back whenever needed.

## 📱 App Flow Diagram

This diagram illustrates the main navigation flow between the different screens of the application.

```
+---------------------+      +---------------------------+      +--------------------+
|   Dashboard Screen  |----->|  Add Transaction Screen   |<---->|      Stats       |
| (Main View)         |      | (Add/Edit Transactions)   |      |      Screen      |
| - Total Balance     |      +---------------------------+      | (Visualizations)   |
| - Transaction List  |                                         +--------------------+
+---------------------+
      |
      |
      v
+---------------------+
|   Settings Screen   |
| - Theme Toggle      |
| - Data Export/Import|
| - Category Mgmt.    |
+---------------------+
      |
      v
+-----------------------------+
| Category Management Screen  |
| (Add/Edit/Delete Categories)|
+-----------------------------+
```

## 🏗️ Architecture

The application is built using a clean, scalable, and feature-first architecture. This approach ensures that the code is well-organized, easy to maintain, and simple to extend with new features.

### Architecture Diagram

The data flows in a unidirectional pattern, from the UI to the data layer, ensuring a predictable and manageable state.

```
+-----------------------+      +-----------------------+      +--------------------------+
|       UI Layer        |      |     Provider Layer    |      |       Data Layer         |
| (Screens & Widgets)   |----->| (State Management)    |----->| (Repository & Database)  |
|                       |      |                       |      |                          |
|  - DashboardScreen    |      |  - TransactionProvider|      |  - LocalStorageRepository|
|  - AddTransactionScreen|      |  - CategoryProvider   |      |  (Interacts with Hive)   |
|  - SettingsScreen     |      |  - ThemeProvider      |      |                          |
+-----------------------+      +-----------------------+      +--------------------------+
        ^                                                            |
        | (Listens to State Changes)                                 v
        +----------------------------------------------------+----------------+
                                                             |   Hive DB      |
                                                             | (Local Storage)|
                                                             +----------------+
```

### Project Structure

The project is organized into logical directories based on features:

-   `lib/models`: Contains the data models for the application, such as `Transaction` and `Category`. These are the blueprints for our data.
-   `lib/providers`: Holds the state management logic using `Riverpod`. Providers like `TransactionProvider` and `CategoryProvider` manage and provide the application's state to the UI.
-   `lib/repositories`: Contains the `LocalStorageRepository`, which acts as an abstraction layer between the providers and the Hive database. It handles all data read/write operations.
-   `lib/screens`: Contains the UI for the application, with each screen corresponding to a specific feature (e.g., `add_transaction_screen.dart`).

## 💾 Data Persistence with Hive

**Hive** is a lightweight and blazing-fast key-value database written in pure Dart. We use it to store all application data locally.

-   **TypeAdapters:** Custom `TypeAdapter`s (`TransactionAdapter`, `CategoryAdapter`) are used to serialize and deserialize Dart objects into a format that Hive can store.
-   **Boxes:** Data is stored in "Boxes," which are like tables in a traditional database. We use separate boxes for transactions and categories.

## 🚀 Getting Started

To run this project locally, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd myapp
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the code generator:**
    Because we use Hive, we need to generate the `TypeAdapter` files. Run the following command in your terminal:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the application:**
    ```bash
    flutter run
    ```

## 📦 Building for Production (APK)

To generate a release APK for Android, run the following command:

```bash
flutter build apk --release --no-tree-shake-icons
```

**Note:** The `--no-tree-shake-icons` flag is currently used to prevent a build error related to how `IconData` is handled in the app. This ensures that the APK can be built successfully while the underlying code is optimized in future versions.

## ♿ Accessibility (A11Y)

We are committed to making this application accessible to everyone. The design and development process will follow A11Y standards to ensure a wide variety of users with different physical and cognitive abilities can use the app comfortably.

## 🔮 Future Plans

The application is under active development. Future enhancements include:

*   Setting and tracking budgets.
*   Implementing savings goals.
*   Advanced data filtering and search capabilities.
*   UI/UX improvements and animations.
