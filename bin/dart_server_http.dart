import 'dart:io';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final router = Router()
  ..get('/', _rootHandler)
  ..mount('/api/v1.0/', Api().router.call)
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

class Api {
  List<int> items = [1, 2, 3, 4, 5];

  Future<Response> _items(Request request) async {
    return Response.ok(jsonEncode(items),
        headers: {'Content-Type': 'application/json'});
  }

  Router get router {
    final router = Router();

    router.get('/items', _items);
    router.post('/items', (Request request) async {
      final body = await request.readAsString();
      final item = int.parse(body);
      items.add(item);
      return Response.ok(jsonEncode(items),
          headers: {'Content-Type': 'application/json'});
    });
    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));

    return router;
  }
}
