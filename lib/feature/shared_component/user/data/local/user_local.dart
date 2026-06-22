// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

class UserLocal {
  ResponseWrapperLocal responseWrapper;
  LocalDatabase localDatabase;
  SyncTable syncTable;
  UserLocal({
    required this.responseWrapper,
    required this.localDatabase,
    required this.syncTable,
  });

  Future<void> syncUser({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelUser, UserMember>(
      init: init,
      remoteModels: remoteResults.map((e) => ModelUser.fromJson(e)).toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.userMembers,
      idColumn: localDatabase.userMembers.id,
      modelData: (ModelUser model) => UserMember(
        id: model.id,
        name: model.name,
        email: model.email,
        createdAt: model.createdAt,
        companyId: model.companyId,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchUser({required String companyId}) {
    final query = localDatabase.select(localDatabase.userMembers)
      ..where((tbl) => tbl.companyId.equals(companyId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<UserMember> rows) {
          return rows.map((row) => row.toJson()).toList();
        });
      },
    );
  }

  Future<void> deleteUser(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.userMembers,
      idColumn: localDatabase.userMembers.id,
    );
  }
}
