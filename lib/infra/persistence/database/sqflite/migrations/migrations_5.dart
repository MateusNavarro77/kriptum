import 'package:kriptum/config/env/env.dart';
import 'package:kriptum/infra/persistence/database/sqflite/tables/networks_table.dart';
import 'package:sqflite/sqflite.dart';

Future<void> runMigration5(Database db) async {
  await db.transaction(
    (txn) async {
      txn.execute('''
      UPDATE ${NetworksTable.table}
      SET ${NetworksTable.rpcUrlColumn} = ${Env.defaultEthereumMainnetRpc}
      WHERE ${NetworksTable.idColumn} = 1;
    ''');
      txn.execute('''
      UPDATE ${NetworksTable.table}
      SET ${NetworksTable.rpcUrlColumn} = ${Env.defaultSepoliaRpc}
      WHERE ${NetworksTable.idColumn} = 11155111;
    ''');
    },
  );
}
