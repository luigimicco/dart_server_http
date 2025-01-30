import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final router = Router()..get('/', _rootHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

void main(List<String> arguments) async {
  final ip = "127.0.0.1";
  final port = 8080;

  final handler = Pipeline().addHandler(router.call);

  final server = await serve(handler, ip, port);
  print('Server listening ${server.address.host}:${server.port}');
}
