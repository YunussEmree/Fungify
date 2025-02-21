import 'package:fungi_app/modules/main_binding.dart';
import 'package:fungi_app/modules/main_page.dart';
import 'package:fungi_app/modules/pages/camera_page.dart';
import 'package:fungi_app/modules/pages/gallery_page.dart';
import 'package:fungi_app/modules/pages/search_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.MAINPAGE;

  static final List<GetPage<dynamic>> routes = <GetPage>[
    // Auth Routes
    GetPage(
      name: Routes.MAINPAGE,
      page: () => MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.CAMERAPAGE,
      page: () => CameraPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.GALLERYPAGE,
      page: () => GalleryPage(),
    ),
    GetPage(
      name: Routes.SEARCHPAGE,
      page: () => SearchPage(),
    ),
  ];
}
