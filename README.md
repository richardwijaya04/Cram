# Cram: Advanced Study Progress & Performance Tracker for iOS 🚀

[![Swift Version](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org/)
[![Platform](https://img.shields.io/badge/Platform-iOS%2016+-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple.svg)](https://developer.apple.com/xcode/swiftui/)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM-green.svg)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE.md)

<p align="center">
  <img src="YOUR_LINK_TO_MAIN_APP_SHOWCASE_IMAGE_OR_GIF.png" alt="Cram Application Showcase" width="350"/>
  </p>

Cram is a meticulously engineered iOS application, architected with SwiftUI, designed to empower dedicated learners and professionals in systematically tracking and visualizing their academic and self-directed study progression. It offers a sophisticated, yet remarkably intuitive, platform for granular progress management, detailed session logging, and sustained engagement through intelligent feedback mechanisms.

---

## ✨ Core Functionalities & Technical Highlights

* 📊 **Dynamic Progress Visualization Engine:**
    * Features an interactive `ProgressBarView` with a distinctive real-time text color transition effect. This is achieved by dynamically re-rendering individual character foreground colors based on their precise geometric coordinates relative to the animated progress indicator, offering an engaging and satisfying user experience.
* 📚 **Flexible Hierarchical Data Management:**
    * Enables users to define custom "Tables" (e.g., "Advanced Algorithmics," "CFA Level II Preparation") and nested "Topics" (e.g., "Graph Traversal Algorithms," "Quantitative Methods").
    * Full CRUD (Create, Read, Update, Delete) operations are supported for both entities, ensuring a highly adaptable study framework.
* ⏱️ **Intelligent Study Session Logging & Analytics:**
    * Facilitates precise logging of study sessions, allowing users to allocate percentage-based progress to specific topics.
    * Calculations ensure progress constraints (0.0 to 1.0) are respected, with changes instantly reflected in the UI.
* 📜 **Comprehensive Progress Auditing:**
    * Maintains a detailed, timestamped `history` of all `ProgressUpdateEvent`s for each topic. This allows for meticulous review of learning velocity and historical performance.
* 🔥 **Study Streak Mechanism (Conceptual Basis):**
    * Includes the foundational UI and data structure for tracking consecutive study days, designed to enhance user motivation and consistency. *(Advanced temporal logic for streak calculation is an area for future refinement.)*
* 💾 **Robust Local Data Persistence Architecture:**
    * Leverages Swift's `Codable` protocol for seamless serialization and deserialization of complex data structures (`Table`, `Topic`, `ProgressUpdateEvent`).
    * Table data is persisted as a JSON file within the application's sandboxed Documents Directory, ensuring data integrity and resilience.
    * `UserDefaults` is employed for lightweight storage of user preferences and application state (e.g., onboarding completion, last selected table index).
* 👋 **Streamlined User Onboarding Experience:**
    * A guided onboarding sequence, presented conditionally, ensures new users can rapidly understand and utilize the application's core features.
* 💡 **Contextual Guidance via TipKit (iOS 17+):**
    * Integrates Apple's TipKit framework to deliver context-sensitive, non-intrusive guidance, enhancing feature discovery and user proficiency.
* 🎨 **Modern, Performant UI with SwiftUI & MVVM:**
    * The entire user interface is declaratively constructed using SwiftUI, promoting maintainability and a responsive user experience.
    * Adheres to the Model-View-ViewModel (MVVM) architectural pattern for a clean separation of concerns, enhancing testability and scalability.
* 🖋️ **Enhanced Readability with Custom Typography:**
    * Utilizes the "Lexend" custom font family, selected for its superior legibility and aesthetic qualities, contributing to a polished user interface.

---

## 🛠️ Technology Stack & Architectural Blueprint

* **Primary Language:** Swift (5.9 and later)
* **User Interface Framework:** SwiftUI (Declarative, state-driven UI)
* **Architectural Pattern:** Model-View-ViewModel (MVVM) for robust separation of concerns and testability.
* **Data Persistence & Serialization:**
    * `Codable` Protocol: For efficient and type-safe data encoding/decoding.
    * JSON: Format for structured data storage.
    * File System: Secure storage of primary data within the app's Documents Directory.
    * `UserDefaults`: For lightweight storage of application preferences and state.
* **iOS Native Features:**
    * TipKit (iOS 17+): For contextual in-app tips.
    * Custom Fonts: Integrated via application bundle.
* **Concurrency Model:** Structured Concurrency (`async/await`) for managing asynchronous operations, such as TipKit event donations.

---

## 📸 Application Showcase

<table>
  <tr>
    <td><img src="readme-assets/cram-dashboard.png" alt="Cram Dashboard View" width="220"/></td>
    <td><img src="readme-assets/cram-add-session.png" alt="Cram Add Session Modal" width="220"/></td>
    <td><img src="readme-assets/cram-edit-table.png" alt="Cram Edit Table Interface" width="220"/></td>
  </tr>
  <tr>
    <td align="center"><em>Main Dashboard Interface</em></td>
    <td align="center"><em>Log Study Session</em></td>
    <td align="center"><em>Table Configuration</em></td>
  </tr>
  <tr>
    <td><img src="readme-assets/cram-topic-history.png" alt="Cram Topic Progress History" width="220"/></td>
    <td><img src="readme-assets/cram-progressbar-animation.gif" alt="Dynamic Progress Bar Animation" width="220"/></td>
    <td><img src="readme-assets/cram-onboarding.png" alt="Cram User Onboarding" width="220"/></td>
  </tr>
  <tr>
    <td align="center"><em>Detailed Topic History</em></td>
    <td align="center"><em>Interactive Progress Bar Effect</em></td>
    <td align="center"><em>User Onboarding Flow</em></td>
  </tr>
</table>

---

## 🚀 Setup & Execution Protocol

1.  **System Prerequisites:**
    * macOS (Sonoma or later recommended).
    * Xcode 15.0 or a subsequent version.
    * Git version control system.
2.  **Repository Acquisition:**
    ```bash
    git clone https://github.com/richardwijaya04/Cram.git
    cd [YOUR_REPOSITORY_NAME]
    ```
3.  **Project Initialization (Xcode):**
    * Open the `Cram.xcodeproj` file using Xcode.
4.  **Target Configuration:**
    * Select an appropriate iOS Simulator (e.g., iPhone 15 Pro, configured with iOS 17.0 for full TipKit functionality) or a provisioned physical iOS device.
5.  **Build & Deployment:**
    * Execute the build and run command (`Cmd+R`) from within the Xcode IDE.

---

## 🧠 Engineering Insights & Problem-Solving Highlights

* **Sophisticated `ProgressBarView` Implementation:**
    * A significant engineering challenge was the development of the dynamic text-coloring effect within the `ProgressBarView`. This necessitated precise geometric calculations using `GeometryReader`, robust character-width estimation algorithms for the "Lexend" font, and efficient state-driven UI updates to ensure a fluid visual transition synchronized with the progress animation.
* **State Management in a Declarative Paradigm:**
    * Effectively managing and propagating state across a complex hierarchy of SwiftUI views (Dashboard, Modals for Create/Edit/Add Session, History) was critical. This was addressed through strategic application of `@StateObject`, `@ObservedObject`, and `@Published` property wrappers, ensuring data integrity and responsive UI updates within the MVVM framework.
* **Resilient Data Persistence with `Codable`:**
    * Designing the data models (`Table`, `Topic`, `ProgressUpdateEvent`) for `Codable` conformance, including appropriate `Date` encoding/decoding strategies (ISO8601), was paramount for reliable local JSON file storage. Careful error handling was implemented for file I/O and deserialization processes.
* **Integrity of Historical Progress Data:**
    * Ensuring that all modifications to a topic's progress—whether through dedicated session logging or direct manipulation during table edits—are accurately captured as immutable `ProgressUpdateEvent`s in the topic's history log. This maintains a verifiable audit trail of learning activities.

This project served as an excellent platform to deepen expertise in modern iOS development practices, including advanced SwiftUI techniques, robust state management strategies, data persistence, and the creation of engaging, interactive user interfaces.

---

## 📈 Strategic Roadmap for Future Iterations

* [ ] **Cloud-Based Data Synchronization:** Implementation of iCloud (potentially Core Data with CloudKit) to enable seamless data persistence and synchronization across a user's Apple device ecosystem.
* [ ] **Enhanced Home Screen Presence:** Development of interactive iOS Widgets, providing users with at-a-glance progress summaries and quick-access functionality.
* [ ] **Proactive Learning Engagement System:** Integration of a sophisticated local notification framework for customizable study reminders, motivational prompts, and streak maintenance alerts.
* [ ] **Advanced Analytics & Reporting:** Introduction of a dedicated module for visualizing learning trends, progress velocity, and other key performance indicators through charts and statistical summaries.
* [ ] **UI Theming & Accessibility Enhancements:** Offering multiple UI themes (e.g., dark mode variants, accent colors) and further refining accessibility features to support a broader range of users.
* [ ] **Comprehensive Test Coverage:** Implementation of Unit Tests (XCTest) for business logic and UI Tests (XCUITest) to ensure application stability and regression prevention.

---

## 👨‍💻 Principal Developer

* **[Richard Wijaya Harianto]**
    * GitHub: `https://github.com/richardwijaya04`
    * LinkedIn: `www.linkedin.com/in/richard-wijaya-harianto`
    * Email: `richardharianto04@gmail.com`

---

Thank you for your interest in Cram. Contributions, suggestions, and feedback are always welcome. If you find this project insightful or valuable, please consider awarding it a star ⭐.
