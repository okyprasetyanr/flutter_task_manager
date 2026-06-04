# Ringkas Task

## Product Vision

Ringkas Task adalah aplikasi manajemen tugas dan proyek yang terinspirasi oleh Jira, namun lebih sederhana, cepat, dan mudah digunakan oleh tim kecil hingga menengah.

### Target Pengguna

* Software House
* Startup
* Tim Internal Perusahaan
* Freelancer Team
* UKM

---

# User Roles

## Workspace Owner

### Hak Akses

* Membuat Workspace
* Menghapus Workspace
* Mengelola Billing (Future)
* Menambah Admin

---

## Workspace Admin

### Hak Akses

* Membuat Project
* Mengelola Member
* Mengelola Task

---

## Member

### Hak Akses

* Melihat project yang diikuti
* Membuat task
* Mengubah task yang memiliki akses

---

## Viewer

### Hak Akses

* Read Only

---

# Database Schema

## Users

Master data user.

### Table

`users`

| Field      | Type     |
| ---------- | -------- |
| id         | String   |
| name       | String   |
| email      | String   |
| photo_url  | String   |
| created_at | DateTime |
| updated_at | DateTime |

### Example

```json
{
  "id": "USR001",
  "name": "Oky",
  "email": "oky@gmail.com",
  "photo_url": ""
}
```

---

## Workspaces

### Table

`workspaces`

| Field       | Type     |
| ----------- | -------- |
| id          | String   |
| owner_id    | String   |
| name        | String   |
| description | String   |
| created_at  | DateTime |

---

## Workspace Members

### Table

`workspace_members`

| Field        | Type     |
| ------------ | -------- |
| id           | String   |
| workspace_id | String   |
| user_id      | String   |
| role         | Enum     |
| joined_at    | DateTime |

### Roles

```text
owner
admin
member
viewer
```

---

# Project Module

## Projects

### Table

`projects`

| Field        | Type     |
| ------------ | -------- |
| id           | String   |
| workspace_id | String   |
| name         | String   |
| description  | String   |
| color        | String   |
| icon         | String   |
| status       | Enum     |
| created_by   | String   |
| created_at   | DateTime |

### Status

```text
active
completed
archived
```

---

## Project Members

### Table

`project_members`

| Field      | Type   |
| ---------- | ------ |
| id         | String |
| project_id | String |
| user_id    | String |
| role       | Enum   |

### Roles

```text
project_manager
developer
designer
qa
viewer
```

---

# Task Module

Task merupakan fitur utama aplikasi.

## Tasks

### Table

`tasks`

| Field          | Type     |
| -------------- | -------- |
| id             | String   |
| project_id     | String   |
| sprint_id      | String?  |
| parent_task_id | String?  |
| title          | String   |
| description    | String   |
| status         | Enum     |
| priority       | Enum     |
| story_point    | Int      |
| reporter_id    | String   |
| assignee_id    | String   |
| start_date     | DateTime |
| due_date       | DateTime |
| created_at     | DateTime |
| updated_at     | DateTime |

### Status

```text
backlog
todo
in_progress
review
testing
done
cancelled
```

### Priority

```text
lowest
low
medium
high
highest
critical
```

### Example

```json
{
  "id": "TASK001",
  "project_id": "PRJ001",
  "title": "Implement Login",
  "status": "in_progress",
  "priority": "high",
  "assignee_id": "USR002",
  "reporter_id": "USR001"
}
```

---

# Subtask Module

Mirip dengan Jira.

## Subtasks

### Table

`subtasks`

| Field   | Type   |
| ------- | ------ |
| id      | String |
| task_id | String |
| title   | String |
| is_done | Bool   |

### Example

```json
{
  "id": "SUB001",
  "task_id": "TASK001",
  "title": "Create Login UI",
  "is_done": true
}
```

---

# Label Module

## Labels

### Table

`labels`

| Field      | Type   |
| ---------- | ------ |
| id         | String |
| project_id | String |
| name       | String |
| color      | String |

### Example

```json
{
  "id": "LBL001",
  "project_id": "PRJ001",
  "name": "Frontend",
  "color": "#4CAF50"
}
```

---

## Task Labels

Many-to-Many relationship antara Task dan Label.

### Table

`task_labels`

| Field    | Type   |
| -------- | ------ |
| task_id  | String |
| label_id | String |

---

# Comment Module

## Comments

### Table

`comments`

| Field      | Type     |
| ---------- | -------- |
| id         | String   |
| task_id    | String   |
| user_id    | String   |
| content    | String   |
| created_at | DateTime |

---

# Attachment Module

## Attachments

### Table

`attachments`

| Field       | Type     |
| ----------- | -------- |
| id          | String   |
| task_id     | String   |
| file_name   | String   |
| file_url    | String   |
| file_size   | Int      |
| uploaded_by | String   |
| created_at  | DateTime |

---

# Activity Module

Audit trail seluruh perubahan task.

## Activities

### Table

`activities`

| Field      | Type     |
| ---------- | -------- |
| id         | String   |
| task_id    | String   |
| user_id    | String   |
| action     | String   |
| old_value  | String   |
| new_value  | String   |
| created_at | DateTime |

### Example

```json
{
  "id": "ACT001",
  "task_id": "TASK001",
  "user_id": "USR002",
  "action": "CHANGE_STATUS",
  "old_value": "todo",
  "new_value": "in_progress"
}
```

---

# Sprint Module (Future)

Digunakan apabila ingin mendekati fitur Jira.

## Sprints

### Table

`sprints`

| Field      | Type     |
| ---------- | -------- |
| id         | String   |
| project_id | String   |
| name       | String   |
| start_date | DateTime |
| end_date   | DateTime |
| status     | Enum     |

### Status

```text
planned
active
completed
```

---

# Dashboard Aggregate

Bukan tabel database.

Dibentuk oleh repository untuk kebutuhan UI.

```dart
class DashboardData {
  final int totalProject;
  final int totalTask;
  final int todoTask;
  final int inProgressTask;
  final int completedTask;
  final List<Task> recentTask;
}
```

---

# Halaman V1

## Dashboard

Menampilkan:

* Total Project
* Total Task
* Task Due Today
* Task Overdue
* Recent Activity

---

## Project Detail

### Tabs

```text
Overview
Board
Members
Activity
Settings
```

---

## Board

```text
Backlog
Todo
In Progress
Review
Testing
Done
```

Fitur:

* Drag & Drop Task antar kolom

---

## Task Detail

### Sections

```text
Task Info
Description
Assignee
Reporter
Checklist
Comment
Attachment
Activity
```

---

# Entity Domain Final

Entity utama yang digunakan pada sistem:

```text
User
Workspace
WorkspaceMember

Project
ProjectMember

Task
Subtask

Label
TaskLabel

Comment
Attachment
Activity

Sprint (Future)
```

---

# Aggregate / View Models

Model berikut bukan tabel database, melainkan model yang dibentuk oleh Repository untuk kebutuhan UI.

```text
DashboardData
ProjectDetail
TaskDetail
MemberDetail
ProjectStatistic
```

Dengan pendekatan ini, arsitektur Flutter + BLoC + Repository akan tetap bersih, scalable, dan mudah dikembangkan untuk fitur-fitur lanjutan di masa depan.
