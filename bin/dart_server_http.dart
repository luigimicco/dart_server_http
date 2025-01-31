import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final router = Router()
  ..get('/', _rootHandler)
  ..all('/<ignored|.*>', (Request request) {
    return Response.notFound('Page not found');
  });

Response _rootHandler(Request req) {
  return Response.ok('<h1>Hello, World!</h1>\n',
      headers: {'Content-Type': 'text/html'});
}

void main(List<String> arguments) async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  final server = await serve(handler, ip, port);
  print('Server listening ${server.address.host}:${server.port}');
}
