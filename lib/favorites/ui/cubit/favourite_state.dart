part of 'favourite_cubit.dart';

enum FavouriteStatus { loading, loaded, failed }

class FavouriteState extends Equatable {
  const FavouriteState({
    required this.status,
    required this.personajes,
  });

  const FavouriteState.loading()
      : status = FavouriteStatus.loading,
        personajes = const [];

  const FavouriteState.loaded({required this.personajes})
      : status = FavouriteStatus.loaded;

  const FavouriteState.fail()
      : status = FavouriteStatus.failed,
        personajes = const [];

  final FavouriteStatus status;
  final List<Personaje> personajes;

  @override
  List<Object> get props => [status, personajes];
}
