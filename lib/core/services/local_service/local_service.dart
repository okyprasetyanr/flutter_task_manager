// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/shared_component/user/data/local/user_local.dart';
import 'package:task_manager/feature/workspace/data/local/workspace_local.dart';

class LocalServices {
  final WorkspaceLocal workspaceLocal;
  final UserLocal userLocal;

  LocalServices({required this.workspaceLocal, required this.userLocal});
}
