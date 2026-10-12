const homeRoute = '/';
const loginRoute = '/login';
const announcementRoutePattern = '/pengumuman/:id';

String announcementRouteForId(String id) =>
    '/pengumuman/${Uri.encodeComponent(id)}';

String routeFromMessage(Map<String, dynamic> data) {
  final route = data['route'];
  if (route is String && route.startsWith('/') && !route.startsWith('//')) {
    return route;
  }

  final id = data['id'];
  if (id is String && id.isNotEmpty) {
    return announcementRouteForId(id);
  }

  return homeRoute;
}