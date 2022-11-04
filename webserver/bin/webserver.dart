import 'dart:convert';
import 'dart:io';
import 'package:webserver/webserver.dart' as webserver;
import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:supabase/supabase.dart';

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

  stdout.writeln('Database URL: ${Platform.environment['SB_DB_URL']}');
  stdout.writeln('Database PW: ${String.fromEnvironment('SB_DB_PW')}');

  var handler = const shelf.Pipeline()
                           .addMiddleware(shelf.logRequests())
                           .addHandler(_echoRequest);

  var server = await io.serve(handler, _hostname, port);
  print('Serving @ http://${server.address.host}:${server.port}');

}

Future<shelf.Response> _echoUsers(shelf.Request request) async {
  final SB_DB_PW = await File('/Users/yourusername/.supabase_db_pw').readAsString();
  stdout.writeln(SB_DB_PW);

  final client = SupabaseClient(Platform.environment['SB_DB_URL']!, SB_DB_PW.trim());
  final response = await client
    .from('student')
    .select();

  stdout.writeln(response);

  var map = {
    'student' : response
  };

  var body = jsonEncode(map);

  return shelf.Response.ok(body);
}

Future<shelf.Response> _echoRequest(shelf.Request request) async {
  switch(request.url.toString()) {
    case 'api/students': return _echoUsers(request);
    default : return shelf.Response.badRequest(body: 'Invalid method');
  }
}

