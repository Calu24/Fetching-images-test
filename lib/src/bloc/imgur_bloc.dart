import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'imgur_state.dart';

class ImgurCubit extends Cubit<ImgurState> {
  ImgurCubit() : super(const ImgurState());

  Future<void> init() async {
    final url = Uri.https(
      'api.imgur.com', '3/gallery/search/viral/week/1', {'q': 'cats'});
    final headers = {
      'Authorization': 'Client-ID 090e58d5dba0f9c',
    };
    final response = await http.get(url, headers: headers);
    print(response.body);

    emit(state.copyWith(isLoading: false, isSubmitted: false));
  }

  // Future<void> submit() async {
  //   emit(state.copyWith(isLoading: true));
  //   await Future<void>.delayed(const Duration(seconds: 1));
  //   emit(state.copyWith(isLoading: false, isSubmitted: true));
  // }
}
