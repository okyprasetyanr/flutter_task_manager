class ApiServices {
  Future<List<Map<String, dynamic>>> getProject(
    String idCompany,
    String uidUser,
  ) async {
    return await [
      {
        "projectName": "Ringkas POS Mobile",
        "projectId": "PRJ001",
        "projectType": "Mobile App",
        "projectStatus": "On Progress",
        "projectCreatedBy": "Oky",
        "projectCreatedId": "USR001",
        "projectTotalContribut": 5,
        "projectStart": "2026-05-01",
        "projectEnd": "2026-06-15",
      },
      {
        "projectName": "Inventory Management System",
        "projectId": "PRJ002",
        "projectType": "Web App",
        "projectStatus": "Completed",
        "projectCreatedBy": "Budi",
        "projectCreatedId": "USR002",
        "projectTotalContribut": 8,
        "projectStart": "2026-01-10",
        "projectEnd": "2026-03-25",
      },
      {
        "projectName": "Task Management App",
        "projectId": "PRJ003",
        "projectType": "Flutter App",
        "projectStatus": "Pending",
        "projectCreatedBy": "Andi",
        "projectCreatedId": "USR003",
        "projectTotalContribut": 3,
        "projectStart": "2026-06-01",
        "projectEnd": "2026-07-20",
      },
      {
        "projectName": "E-Commerce Dashboard",
        "projectId": "PRJ004",
        "projectType": "Admin Panel",
        "projectStatus": "On Progress",
        "projectCreatedBy": "Sinta",
        "projectCreatedId": "USR004",
        "projectTotalContribut": 6,
        "projectStart": "2026-04-12",
        "projectEnd": "2026-08-01",
      },
      {
        "projectName": "Finance Tracker",
        "projectId": "PRJ005",
        "projectType": "Desktop App",
        "projectStatus": "Cancelled",
        "projectCreatedBy": "Rizky",
        "projectCreatedId": "USR005",
        "projectTotalContribut": 2,
        "projectStart": "2026-02-05",
        "projectEnd": "2026-05-30",
      },
    ];
  }

  Future<Map<String, dynamic>> getProjectDetail(String idProject) async {
    return await {
      "members": [
        {
          "userId": "USR001",
          "name": "Oky",
          "role": "Lead Developer",
          'id_project': "PRJ001",
        },
        {
          "userId": "USR002",
          "name": "Andi",
          "role": "UI/UX Designer",
          'id_project': "PRJ001",
        },
      ],

      "tasks": [
        {
          "taskId": "TSK001",
          "title": "Setup Project Architecture",
          "description": "Clean architecture + bloc setup",
          "status": "Done",
          "priority": "High",
          "assignedTo": "Oky",
          "dueDate": "2026-01-05",
          'id_project': "PRJ001",
        },
        {
          "taskId": "TSK002",
          "title": "Design Login UI",
          "description": "Login + register screen design",
          "status": "In_Progress",
          "priority": "Medium",
          "assignedTo": "Andi",
          "dueDate": "2026-01-10",
          'id_project': "PRJ001",
        },
        {
          "taskId": "TSK003",
          "title": "Implement Task List UI",
          "description": "List project tasks with filter",
          "status": "Todo",
          "priority": "Medium",
          "assignedTo": "Oky",
          "dueDate": "2026-01-15",
          'id_project': "PRJ001",
        },
      ],
    };
  }
}
