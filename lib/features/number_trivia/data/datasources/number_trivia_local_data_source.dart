import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';

import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {

  /// Get the cached [NumberTriviaModel] which was gotten on last call while user has internet
  ///
  /// throw a [CacheException] if no cache data available
  Future<NumberTriviaModel>? getLastNumberTrivia(int? number);

  /// call the http://numbersapi.com/random endpoint
  ///
  /// throw a [CacheException] for all type of error codes
  Future<void>? cacheNumberTrivia(NumberTriviaModel cacheTriviaModel);
}
