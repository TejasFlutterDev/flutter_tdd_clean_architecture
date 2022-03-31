import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/platform/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final injector = GetIt.instance;

Future<void> init() async {
  // Features - Number Trivia
  initFeatures();
  // Core
  initCore();
  // External
  await initExternal();
}

void initFeatures() {
  // BLoC
  injector.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: injector(),
      getRandomNumberTrivia: injector(),
      inputConverter: injector()));

  // Use Cases
  injector.registerLazySingleton(() => GetConcreteNumberTrivia(injector()));
  injector.registerLazySingleton(() => GetRandomNumberTrivia(injector()));

  // Repository
  injector.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: injector(),
          localDataSource: injector(),
          networkInfo: injector()));

  // Data sources
  injector.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: injector()));
  injector.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: injector()));
}

void initCore() {
  injector.registerLazySingleton(() => InputConverter());
  injector
      .registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(injector()));
}

Future<void> initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  injector.registerLazySingleton(() => sharedPreferences);
  injector.registerLazySingleton(() => http.Client());
  injector.registerLazySingleton(() => InternetConnectionChecker());
}
