import 'package:fungify/modules/main_binding.dart';
import 'package:fungify/modules/main_page.dart';
import 'package:fungify/modules/pages/camera_page.dart';
import 'package:fungify/modules/pages/gallery_page.dart';
import 'package:fungify/modules/pages/search_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.mainpage;

  static final List<GetPage<dynamic>> routes = <GetPage>[
    GetPage(
      name: Routes.mainpage,
      page: () => MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.camerapage,
      page: () => CameraPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.gallerypage,
      page: () => GalleryPage(),
    ),
    GetPage(
      name: Routes.searchpage,
      page: () => SearchPage(),
    ),
  ];
}
