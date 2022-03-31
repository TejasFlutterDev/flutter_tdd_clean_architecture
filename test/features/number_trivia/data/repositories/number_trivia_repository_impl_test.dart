import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/platform/network_info.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

@GenerateMocks([MockNetworkInfo])
@GenerateMocks([
  NumberTriviaRemoteDataSource
], customMocks: [
  MockSpec<NumberTriviaRemoteDataSource>(
      as: #MockNumberTriviaRemoteDataSourceForTest,
      returnNullOnMissingStub: true),
])
void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );

    group("getConcreteNumberTrivia", () {
      final tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel(text: "Text Trivia", number: tNumber);
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;

      test('should check if device network is available', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      });

      group("device is online", () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        test(
            'should return remote data when the call to remote data source is successful',
            () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        });
        test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        });
        test(
            'should return [ServerFailure] when the call to remote data source is successful',
            () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        });
      });

      group("device is offline", () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });
      });
    });
  });
}
