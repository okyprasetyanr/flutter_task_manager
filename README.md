**Note:** This project is currently **under active development**. Some features might change, and new components are still being added.
# Ringkas Task

> A Clean Architecture Task Management App Built with Flutter & BLOC

Ringkas Task is a mobile-first task management application designed to simplify project collaboration through a clean and structured user experience. Inspired by the complexity of many existing platforms, it organizes work into clear layers—from Workspace to Project, Task, and Task Details—allowing users to focus on one level at a time without feeling overwhelmed.

Currently, the application is in its Minimum Viable Product (MVP) stage.

## 🚀 Core Features

- **Real-Time Data Synchronization:** Instantly syncs task updates across all connected users using Supabase Realtime.
- **Reactive UI with BLOC & Drift Streams:** Combines BLOC and Drift Streams to automatically keep the UI in sync with the latest data.
- **Smart Local Caching (Read-Only Offline):** Uses Drift to provide instant loading and read-only offline access to previously synced tasks.
- **Zero UI Lag:** All read, write, and delete operations go through the local Drift database, delivering a fast and responsive user experience.
- **Efficient Networking:** Uses an event-driven architecture with real-time streams instead of frequent API polling, reducing unnecessary network requests.

## 🛠 Tech Stack & Architecture

| Category | Technology & Patterns |
| :--- | :--- |
| **Frontend** | Flutter & Dart |
| **Backend & Real-Time** | Supabase (Authentication, Realtime Broadcast & Realtime Changes) |
| **Local Database** | Drift (Reactive SQLite Caching Layer) |
| **State Management** | BLOC (Core Architecture), GetX Obx (Micro UI State) |
| **Data Processing** | RxDart, Streams, Custom Stream & Non-Stream Wrappers |
| **Architecture Pattern** | Clean Architecture |
| **Offline Strategy** | Local-First Caching with Drift (Read-Only Offline) |

### Architecture Highlights

- **Data Flow:** Built on a Reactive Data Flow architecture where data moves from Supabase to Drift, and then to BLOC for state management. The system follows a strict unidirectional flow:

  ```text
  Supabase → Drift → BLOC → UI
  ```

- **Single Source of Truth:** BLOC manages the entire UI state, keeping every component synchronized and reactive.

- **Advanced Pipelines & Safety:** Utilizes RxDart to combine dependent data streams, centralized CollectData wrappers for error handling, and Dart enums for strict type safety.

## 🗺 Future Roadmap

The following enterprise and collaboration features are planned for upcoming milestones:

- **Approval & Workflow:** Multi-level task approval for structured team workflows.
- **Role-Based Access Control (RBAC):** Flexible permissions for Managers, Supervisors, and Team Members.
- **Analytics Dashboard:** Productivity insights with task completion, team performance, and project progress metrics.