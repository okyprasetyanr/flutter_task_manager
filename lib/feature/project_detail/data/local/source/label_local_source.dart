import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';
import 'package:task_manager/shared/model/model_label.dart';

class LabelLocalSource {
  final LocalDatabase localDatabase;
  final SyncTable syncTable;
  final ResponseWrapperLocal responseWrapper;

  LabelLocalSource({
    required this.localDatabase,
    required this.syncTable,
    required this.responseWrapper,
  });

  Future<void> syncLabel({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelLabel, Label>(
      init: init,
      remoteModels: remoteResults.map((e) => ModelLabel.fromJson(e)).toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.labels,
      idColumn: localDatabase.labels.id,
      modelData: (ModelLabel model) => Label(
        id: model.id,
        name: model.name,
        color: model.color,
        companyId: model.companyId,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchLabel({required String companyId}) {
    final query = localDatabase.select(localDatabase.labels)
      ..where((tbl) => tbl.companyId.equals(companyId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<Label> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }

  Future<void> deleteLabel(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.labels,
      idColumn: localDatabase.labels.id,
    );
  }
}
