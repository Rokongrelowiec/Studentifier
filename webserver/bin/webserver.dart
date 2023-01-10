import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:image/image.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:intl/intl.dart';
import 'package:supabase/supabase.dart';

import 'db_credentials.dart';
import 'qr_code.dart';

const _hostname = 'localhost';

enum PersonType {
  STUDENT,
  LECTURER
}

void main(List<String> arguments) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(arguments);

  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '8080';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value: "$portStr" into a number.');
    exitCode = 64;
    return;
  }

  var handler = const shelf.Pipeline()
                           .addMiddleware(shelf.logRequests())
                           .addHandler(_echoRequest);

  var server = await io.serve(handler, _hostname, port);
  print('Serving @ http://${server.address.host}:${server.port}');

}

Future<shelf.Response> _echoUsers(shelf.Request request) async {
  final dbCredentials = DatabaseCredentials();
  await DatabaseCredentials.initCredentials(dbCredentials);
  final dbClient = DatabaseConnector(dbCredentials).client;

  var providedApiKey = request.headers['x-api-key'];
  print(providedApiKey);

  var readApiKeyResponse = await dbClient.from('apiKey').select('apiKey').eq('id', '1');
  var readApiKeyMap = readApiKeyResponse[0];
  var readApiKey = readApiKeyMap['apiKey'];

  if (readApiKey != providedApiKey) {
    return shelf.Response.forbidden('UNAUTHORIZED API KEY');
  }

  final response = await dbClient
    .from('student')
    .select();

  var map = {
    'student' : response
  };

  var body = jsonEncode(map);

  return shelf.Response.ok(body);
}

Future<shelf.Response> _echoActiveUsers(shelf.Request request) async{
  final dbCredentials = DatabaseCredentials();
  await DatabaseCredentials.initCredentials(dbCredentials);
  final dbClient = DatabaseConnector(dbCredentials).client;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  
  final response = await dbClient
    .from('student')
    .select()
    .gte('data_waznosci', formatted);

  var map = {
    'student' : response
  };

  var body = jsonEncode(map);

  return shelf.Response.ok(body);

}

Future<shelf.Response> _echoUpdateUsersStudentId(shelf.Request request) async{
  var readString = await request.readAsString();
  print(readString);

  return shelf.Response.ok('hello');
}

Future<shelf.Response> _echoRequest(shelf.Request request) async {
  switch(request.url.toString()) {
    case 'api/v1/students': return _echoUsers(request);
    case 'api/v1/students/active': return _echoActiveUsers(request);
    case 'api/v1/students/update/student_id': return _echoUpdateUsersStudentId(request);
    case 'api/v1/students/qr': return _echoQrCodeDownload(request, PersonType.STUDENT);
    case 'api/v1/vehicles/licenseplates': return _echoVehiclesLicensePlates(request);
    case 'api/v1/vehicles/licenseplates/lecturers': return _echoVehiclesLicensePlatesOfLecturers(request);
    case 'api/v1/lecturers/qr': return _echoQrCodeDownload(request, PersonType.LECTURER);
    default : return shelf.Response.badRequest(body: 'Invalid method');
  }
}

Future<shelf.Response> _echoQrCodeDownload(shelf.Request request, PersonType type) async {
  final dbCredentials = DatabaseCredentials();
  await DatabaseCredentials.initCredentials(dbCredentials);
  final dbClient = DatabaseConnector(dbCredentials).client;

  if(! await isUserAuthenticated(request.headers, dbClient)) {
    return shelf.Response.forbidden("Bad authorization key.");
  }

  if(isRequestTheTypeSameAsProvided(request.method, 'POST')) {
    return shelf.Response.badRequest(body:"Wrong Method.");
  }

  var header = {
    'Content-Type' : 'image/png'
  };

  switch (type) {
    case PersonType.STUDENT:
      print('Student type of request');
      break;
    case PersonType.LECTURER:
      print('Lecturer type of request');
      break;

  }

  var qrCode = StudentifierQRCode();
  var requestBodyAwaited = await request.readAsString();
  qrCode.dataMap = jsonDecode(requestBodyAwaited).toString();
  qrCode.drawQrCode();

  return shelf.Response.ok(encodePng(qrCode.qrCode), headers: header);
}

Future<shelf.Response> _echoVehiclesLicensePlatesOfLecturers(shelf.Request request) async {
  final dbCredentials = DatabaseCredentials();
  await DatabaseCredentials.initCredentials(dbCredentials);
  final dbClient = DatabaseConnector(dbCredentials).client;

  final response = await dbClient
    .from('rejestracje')
    .select()
    .eq('wykladowca', 'true');

  var map = {
    'vehicles' : response
  };

  var body = jsonEncode(map);

  return shelf.Response.ok(body);


}

Future<shelf.Response> _echoVehiclesLicensePlates(shelf.Request request) async {
  final dbCredentials = DatabaseCredentials();
  await DatabaseCredentials.initCredentials(dbCredentials);
  final dbClient = DatabaseConnector(dbCredentials).client;
  
  final response = await dbClient
    .from('rejestracje')
    .select();

  var map = {
    'vehicles' : response
  };

  var body = jsonEncode(map);

  return shelf.Response.ok(body);
}

Future<bool> isUserAuthenticated(Map<String, String> requestHeader, SupabaseClient dbClient) async {
  String? apiKeyFromHeader = requestHeader['x-api-key'];

  final response = await dbClient
      .from('apiKey')
      .select('apiKey')
      .eq('apiKey', apiKeyFromHeader)
      .single();

  String retrievedApiKey = response.values.elementAt(0);
  if (apiKeyFromHeader == retrievedApiKey) {
    return true;
  } else {
    return false;
  }
}

bool isRequestTheTypeSameAsProvided(String providedRequest, String expectedRequest) {
  return providedRequest == expectedRequest;
}

void retrieveStudentByStudentId() {

}



