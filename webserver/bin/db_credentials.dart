import 'dart:convert';
import 'dart:io';
import 'package:supabase/supabase.dart';

class DatabaseCredentials {
  late String databaseUrl;
  late String databasePassword;
  DatabaseCredentials();

   static initCredentials(DatabaseCredentials credentials) async {
    await File('${Platform.environment['HOME']}/.supabase_db_creds').readAsString().then((String json) {
      Map<String, dynamic> jsonMap = jsonDecode(json);
      credentials.databaseUrl = jsonMap['dbUrl'];
      credentials.databasePassword = jsonMap['dbPassword'];
    });
   }

}



class DatabaseConnector {
  late final SupabaseClient client;
  DatabaseConnector(DatabaseCredentials credentials){
    client = SupabaseClient(credentials.databaseUrl, credentials.databasePassword);
  }
}