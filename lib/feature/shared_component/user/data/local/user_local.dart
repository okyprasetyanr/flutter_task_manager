// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

class UserLocal {
  ResponseWrapperLocal responseWrapper;
  LocalDatabase localDatabase;
  UserLocal({required this.responseWrapper, required this.localDatabase});

  Future<void> saveWorkspaces(List<dynamic> remoteResults) async {
    for (final json in remoteResults) {
      final model = ModelUser.fromJson(json);

      await localDatabase
          .into(localDatabase.users)
          .insertOnConflictUpdate(
            User(
              id: model.id,
              name: model.name,
              email: model.email,
              photoUrl: model.photoUrl,
              createdAt: model.createdAt,
              companyId: model.companyId,
            ),
          );
    }
  }

  Stream<Map<String, dynamic>> watchUsers({required String companyId}) {
    final query = localDatabase.select(localDatabase.users)
      ..where((tbl) => tbl.companyId.equals(companyId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<User> rows) {
          return rows.map((row) => row.toJson()).toList();
        });
      },
    );
  }
}
