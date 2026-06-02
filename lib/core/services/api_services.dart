import 'package:task_manager/feature/main_menu/domain/models/model_project.dart';

class ApiServices {
  Future<List<ModelProject>> getProject(
    String idCompany,
    String uidUser,
  ) async {
    return await [
      ModelProject(
        projectName: "Ringkas POS Mobile",
        projectId: "PRJ001",
        projectType: "Mobile App",
        projectStatus: "On Progress",
        projectCreatedBy: "Oky",
        projectCreatedId: "USR001",
        projectTotalContribut: 5,
        projectStart: DateTime(2026, 5, 1),
        projectEnd: DateTime(2026, 6, 15),
      ),

      ModelProject(
        projectName: "Inventory Management System",
        projectId: "PRJ002",
        projectType: "Web App",
        projectStatus: "Completed",
        projectCreatedBy: "Budi",
        projectCreatedId: "USR002",
        projectTotalContribut: 8,
        projectStart: DateTime(2026, 1, 10),
        projectEnd: DateTime(2026, 3, 25),
      ),

      ModelProject(
        projectName: "Task Management App",
        projectId: "PRJ003",
        projectType: "Flutter App",
        projectStatus: "Pending",
        projectCreatedBy: "Andi",
        projectCreatedId: "USR003",
        projectTotalContribut: 3,
        projectStart: DateTime(2026, 6, 1),
        projectEnd: DateTime(2026, 7, 20),
      ),

      ModelProject(
        projectName: "E-Commerce Dashboard",
        projectId: "PRJ004",
        projectType: "Admin Panel",
        projectStatus: "On Progress",
        projectCreatedBy: "Sinta",
        projectCreatedId: "USR004",
        projectTotalContribut: 6,
        projectStart: DateTime(2026, 4, 12),
        projectEnd: DateTime(2026, 8, 1),
      ),

      ModelProject(
        projectName: "Finance Tracker",
        projectId: "PRJ005",
        projectType: "Desktop App",
        projectStatus: "Cancelled",
        projectCreatedBy: "Rizky",
        projectCreatedId: "USR005",
        projectTotalContribut: 2,
        projectStart: DateTime(2026, 2, 5),
        projectEnd: DateTime(2026, 5, 30),
      ),
    ];
  }
}
