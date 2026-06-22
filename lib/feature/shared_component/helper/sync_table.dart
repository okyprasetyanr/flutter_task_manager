// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:drift/drift.dart';
import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class SyncTable {
  LocalDatabase localDatabase;
  SyncTable({required this.localDatabase});

  Future<void> syncTable<T, L>({
    required List<T> remoteModels,
    required String Function(T remoteModel) getRemoteId,
    required TableInfo<Table, L> tableName,
    required GeneratedColumn<String> idColumn,
    required String Function(L localRow) getLocalId,
    required Insertable<L> Function(T modelToDrift) modelData,
    bool init = false,
  }) async {
    try {
      await localDatabase.transaction(() async {
        for (final model in remoteModels) {
          await localDatabase
              .into(tableName)
              .insertOnConflictUpdate(modelData(model));
        }

        if (init) {
          var query = localDatabase.select(tableName);
          final localRows = await query.get();

          final localIds = localRows.map((row) => getLocalId(row)).toSet();
          final remoteIds = remoteModels.map(getRemoteId).toSet();
          final deletedIds = localIds.difference(remoteIds);

          if (deletedIds.isNotEmpty) {
            await (localDatabase.delete(
              tableName,
            )..where((tbl) => idColumn.isIn(deletedIds))).go();
          }
        }
      });
    } catch (e) {
      devLog("Log SyncTable: error: ${e.toString()}");
    }
  }

  Future<void> deleteData({
    required String id,
    required TableInfo<Table, dynamic> tableName,
    required GeneratedColumn<String> idColumn,
  }) async {
    await localDatabase.transaction(() async {
      try {
        final rowsDeleted = await (localDatabase.delete(
          tableName,
        )..where((tbl) => idColumn.equals(id))).go();

        devLog(
          "Drift Lokal: Berhasil menghapus $rowsDeleted baris di tabel ${tableName.actualTableName}",
        );
      } catch (e) {
        devLog("Drift Lokal Error saat deleteRowById: $e");
        rethrow;
      }
    });
  }
}
