import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';

import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {

  /// call the http://numbersapi.com/{number} endpoint
  ///
  /// throw a [ServerException] for all type of error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number);

  /// call the http://numbersapi.com/random endpoint
  ///
  /// throw a [ServerException] for all type of error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
