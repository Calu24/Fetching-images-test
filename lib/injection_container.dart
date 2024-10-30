import 'package:get_it/get_it.dart';
import 'package:spartapp_ayala_lucas/src/bloc/imgur_bloc.dart';
import 'package:spartapp_ayala_lucas/src/respositories/imgur_repository.dart';
import 'package:spartapp_ayala_lucas/src/respositories/imgur_repository_impl.dart';

final GetIt getIt = GetIt.instance;

void setupInjection() {
  getIt.registerLazySingleton<ImgurRepository>(() => ImgurRepositoryImpl());
  getIt.registerFactory(() => ImgurCubit(getIt<ImgurRepository>()));
}
