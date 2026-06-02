import 'package:task_manager/core/services/api_services.dart';
import 'package:task_manager/feature/main_menu/domain/models/model_project.dart';

class RemoteMainMenu {
  final ApiServices api;

  RemoteMainMenu({required this.api});

  Future<List<ModelProject>> getProject() async {
    return await api.getProject("", "");
  }
}
