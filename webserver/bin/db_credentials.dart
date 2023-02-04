import 'dart:convert';
import 'dart:io';
import 'package:supabase/supabase.dart';

class DatabaseCredentials {
  late String databaseUrl;
  late String databasePassword;
  DatabaseCredentials();

   static initCredentialsLocal(DatabaseCredentials credentials) async {
    await File('${Platform.environment['HOME']}/.supabase_db_creds').readAsString().then((String json) {
      print('I do the file read');
      Map<String, dynamic> jsonMap = jsonDecode(json);
      credentials.databaseUrl = jsonMap['dbUrl'];
      credentials.databasePassword = jsonMap['dbPassword'];
    });
   }

   static initCredentialsHeroku(DatabaseCredentials credentials) async {
     credentials.databaseUrl = Platform.environment['dbUrl']!;
     credentials.databasePassword = Platform.environment['dbPassowrd']!;
   }

   static initCredentials(DatabaseCredentials credentials) async {
     Platform.environment['herokuBased'] == "TRUE" ? await initCredentialsHeroku(credentials) : await initCredentialsLocal(credentials);
   }
}



class DatabaseConnector {
  late final SupabaseClient client;
  DatabaseConnector(DatabaseCredentials credentials){
    client = SupabaseClient(credentials.databaseUrl, credentials.databasePassword);
  }
}