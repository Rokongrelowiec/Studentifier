import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:intl/intl.dart';

import 'db_credentials.dart';

const _hostname = 'localhost';

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
    case 'api/v1/vehicles/licenseplates': return _echoVehiclesLicensePlates(request);
    case 'api/v1/vehicles/licenseplates/lecturers': return _echoVehiclesLicensePlatesOfLecturers(request);
    default : return shelf.Response.badRequest(body: 'Invalid method');
  }
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




