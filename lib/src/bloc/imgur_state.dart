part of 'imgur_bloc.dart';

class ImgurState extends Equatable {
  const ImgurState({
    this.isLoading = false,
    this.imagesLink = const [],
  });

  final bool isLoading;
  final List<String> imagesLink;

  ImgurState copyWith({
    bool? isLoading,
    List<String>? imagesLink,
  }) =>
      ImgurState(
        isLoading: isLoading ?? this.isLoading,
        imagesLink: imagesLink ?? this.imagesLink,
      );

  @override
  List<Object> get props => [
        isLoading,
        imagesLink,
      ];
}
