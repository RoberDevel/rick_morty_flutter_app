import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rick_morty_flutter_app/api/api.dart';
import 'package:rick_morty_flutter_app/favorites/domain/repository/favorite_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required RickRepository rickRepository,
    required FavoriteRepository favoriteRepository,
  })  : _rickRepository = rickRepository,
        _favoriteRepository = favoriteRepository,
        super(const HomeState.loading());

  final RickRepository _rickRepository;
  final FavoriteRepository _favoriteRepository;
  StreamSubscription<List<String>>? _favoriteSubscription;

  Future<void> toggleFavorite(
    String userId,
    String personajeId,
    bool isFavorite,
  ) async {
    if (!isFavorite) {
      await _favoriteRepository.addFavorite(userId, personajeId);
    } else {
      await _favoriteRepository.removeFavorite(userId, personajeId);
    }
  }

  Future<void> init(String userId, bool isAnonimous) async {
    if (!isAnonimous) {
      _favoriteSubscription = _favoriteRepository
          .getFavorites(userId)
          .listen(_updateFavorites)
        ..onError((e) => print(e));
    }

    await getPersonajes();
  }

  Future<void> getPersonajes() async {
    try {
      if (state.filter.trim().isNotEmpty) {
        final personajes = await _rickRepository.getFilteredCharacters(
          page: state.initialPage + 1,
          query: state.filter,
        );
        emit(
          HomeState.success(
            filter: state.filter,
            personajes: [...state.personajes, ...personajes],
            initialPage: state.initialPage + 1,
            favorites: state.favorites,
          ),
        );
        return;
      } else {
        final personajes = await _rickRepository.getAllPersonajes(
          page: state.initialPage + 1,
        );
        emit(
          HomeState.success(
            personajes: [...state.personajes, ...personajes],
            initialPage: state.initialPage + 1,
            favorites: state.favorites,
          ),
        );
      }
    } catch (e) {
      print(e);
      emit(HomeState.failure(state.filter));
    }
  }

  Future<void> getFilteredCharacters(String query) async {
    emit(state.updateFilter(query));
    try {
      final personajes = await _rickRepository.getFilteredCharacters(
        query: query,
      );
      emit(
        HomeState.success(
          filter: query,
          personajes: personajes,
          initialPage: 1,
          favorites: state.favorites,
        ),
      );
    } catch (e) {
      print(e);
      emit(HomeState.failure(query));
    }
  }

  void _updateFavorites(List<String> event) {
    emit(state.updateFavorites(event));
  }

  @override
  Future<void> close() async {
    await _favoriteSubscription?.cancel();
    return super.close();
  }
}
