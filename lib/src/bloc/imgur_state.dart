part of 'imgur_bloc.dart';

class ImgurState extends Equatable {
  const ImgurState({
    this.isLoading = false,
    this.imagesLink = const [],
    this.popularPageNumber = 1,
    this.searchPageNumber = 1,
  });

  final bool isLoading;
  final List<String> imagesLink;
  final int popularPageNumber;
  final int searchPageNumber;

  ImgurState copyWith({
    bool? isLoading,
    List<String>? imagesLink,
    int? popularPageNumber,
    int? searchPageNumber,
  }) =>
      ImgurState(
        isLoading: isLoading ?? this.isLoading,
        imagesLink: imagesLink ?? this.imagesLink,
        popularPageNumber: popularPageNumber ?? this.popularPageNumber,
        searchPageNumber: searchPageNumber ?? this.searchPageNumber,
      );

  @override
  List<Object> get props => [
        isLoading,
        imagesLink,
        popularPageNumber,
        searchPageNumber,
      ];
}
