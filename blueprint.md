
# Project Blueprint

## Overview

This document outlines the architecture, features, and future development plans for the personal finance application. The application is designed to be a comprehensive tool for tracking expenses and income, managing categories, and visualizing financial data. It is a fully offline application that stores all data locally on the device using Hive.

## Core Features

*   **Offline First:** All data is stored locally using Hive, ensuring the application is fully functional without an internet connection.
*   **Transaction Management:** Users can add, edit, and delete income and expense transactions.
*   **Category Management:** Users can create, edit, and delete categories for their transactions.
*   **Data Visualization:** The application provides a visual representation of financial data using charts.
*   **Theme Customization:** Users can switch between light and dark themes.
*   **Data Export/Import:** Users can export their data to a shareable format and import it back into the application.

## Project Structure

The project is structured using a feature-first approach, with each feature having its own set of screens, providers, and repositories.

*   `lib/models`: Contains the data models for the application, such as `Transaction` and `Category`.
*   `lib/providers`: Contains the providers for managing the application's state, such as `CategoryProvider` and `ThemeProvider`.
*   `lib/repositories`: Contains the repositories for interacting with the local data storage, such as `LocalStorageRepository`.
*   `lib/screens`: Contains the UI for the application, with each screen corresponding to a specific feature.

## Current Plan

The current plan is to continue building out the core features of the application and to improve the overall user experience. This includes:

*   **Improving the user interface:** The UI will be updated to be more modern and intuitive.
*   **Adding new features:** New features will be added to the application, such as the ability to set budgets and to track savings goals.
*   **Improving performance:** The performance of the application will be improved by optimizing the code and by using more efficient data structures.
