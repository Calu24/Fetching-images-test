part of 'imgur_bloc.dart';

class ImgurState extends Equatable {
  const ImgurState({
    this.isLoading = false,
  });

  final bool isLoading;

  ImgurState copyWith({
    bool? isLoading,
    bool? isSubmitted,
  }) =>
      ImgurState(
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object> get props => [
        isLoading,
      ];
}
