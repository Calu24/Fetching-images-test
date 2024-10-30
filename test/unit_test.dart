// test/imgur_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spartapp_ayala_lucas/src/bloc/imgur_bloc.dart';
import 'package:spartapp_ayala_lucas/src/models/gallery_response.dart';
import 'package:spartapp_ayala_lucas/src/respositories/imgur_repository.dart';

class MockImgurRepository extends Mock implements ImgurRepository {}

void main() {
  group('ImgurCubit', () {
    late ImgurCubit imgurCubit;
    late MockImgurRepository mockImgurRepository;

    setUp(() {
      mockImgurRepository = MockImgurRepository();
      imgurCubit = ImgurCubit(mockImgurRepository);
    });

    tearDown(() {
      imgurCubit.close();
    });

    test('initial state is ImgurState', () {
      expect(imgurCubit.state, const ImgurState());
    });

    blocTest<ImgurCubit, ImgurState>(
      'emits [ImgurState(isLoading: true), ImgurState(isLoading: false, imagesLinks: [])] when getPopularImages is successful',
      build: () {
        when(mockImgurRepository.fetchPopularImages())
            .thenAnswer((_) async => <GalleryModel>[]);
        return imgurCubit;
      },
      act: (cubit) => cubit.getPopularImages(),
      expect: () => [
        const ImgurState(isLoading: true),
        const ImgurState(isLoading: false, imagesLinks: []),
      ],
    );

    blocTest<ImgurCubit, ImgurState>(
      'emits [ImgurState(isLoading: true), ImgurState(isLoading: false)] when getPopularImages fails',
      build: () {
        when(mockImgurRepository.fetchPopularImages())
            .thenThrow(Exception('error'));
        return imgurCubit;
      },
      act: (cubit) => cubit.getPopularImages(),
      expect: () => [
        const ImgurState(isLoading: true),
        const ImgurState(isLoading: false),
      ],
    );

    blocTest<ImgurCubit, ImgurState>(
      'emits [ImgurState(galleryModels: [])] when searchImage is successful',
      build: () {
        when(mockImgurRepository.searchImages('cLRT0zd'))
            .thenAnswer((_) async => <GalleryModel>[]);
        return imgurCubit;
      },
      act: (cubit) => cubit.searchImage('query'),
      expect: () => [
        const ImgurState(galleryModels: [], query: 'query'),
      ],
    );

    blocTest<ImgurCubit, ImgurState>(
      'emits [ImgurState()] when searchImage fails',
      build: () {
        when(mockImgurRepository.searchImages('cLRT0zd'))
            .thenThrow(Exception('error'));
        return imgurCubit;
      },
      act: (cubit) => cubit.searchImage('query'),
      expect: () => [
        const ImgurState(galleryModels: [], query: 'query'),
      ],
    );
  });
}
