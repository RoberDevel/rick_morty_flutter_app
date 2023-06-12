import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_morty_flutter_app/api/domain/domain.dart';
import 'package:rick_morty_flutter_app/favorites/favorites.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit({
    required FavoriteRepository favoriteRepository,
  })  : _favoriteRepository = favoriteRepository,
        super(const FavouriteState.loading());

  final FavoriteRepository _favoriteRepository;
  late final StreamSubscription<List<Personaje>> _favouritesSbscription;

  void init(String userId) {
    _favouritesSbscription = _favoriteRepository
        .getPersonajesFavorites(userId)
        .listen(_onListenData)
      ..onError(_handleError);
  }

  Future<void> toggleFavorite(
    String userId,
    String personajeId,
  ) async {
    await _favoriteRepository.removeFavorite(userId, personajeId);
  }

  void _onListenData(List<Personaje> personajes) {
    emit(FavouriteState.loaded(personajes: personajes));
  }

  void _handleError(Object error) {
    emit(const FavouriteState.fail());
  }

  @override
  Future<void> close() async {
    await _favouritesSbscription.cancel();
    return super.close();
  }
}
