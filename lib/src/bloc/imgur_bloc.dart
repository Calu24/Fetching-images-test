import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

part 'imgur_state.dart';

class ImgurCubit extends Cubit<ImgurState> {
  ImgurCubit() : super(const ImgurState());

  Future<void> getPopularImages() async {
    emit(state.copyWith(isLoading: true));

    final url = Uri.https('api.imgur.com', '3/gallery/hot/viral/week/1');
    final clientId = dotenv.env['client-id'];
    final headers = {
      'Authorization': 'Client-ID $clientId',
    };
    final response = await http.get(url, headers: headers);
    print(response.body);

    emit(state.copyWith(isLoading: false));
  }

  Future<void> search(String query) async {
    emit(state.copyWith(isLoading: true));

    final url = Uri.https(
        'api.imgur.com', '3/gallery/search/viral/week/1', {'q': query});
    final clientId = dotenv.env['client-id'];
    final headers = {
      'Authorization': 'Client-ID $clientId',
    };
    final response = await http.get(url, headers: headers);
    print(response.body);

    emit(state.copyWith(isLoading: false));
  }
}
