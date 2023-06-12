part of 'home_cubit.dart';

enum HomeStatus {
  loading,
  success,
  failure,
}

@immutable
class HomeState extends Equatable {
  const HomeState._({
    this.personajes = const [],
    this.status = HomeStatus.loading,
    this.initialPage = 0,
    this.filter = '',
    this.favorites = const [],
  });
  const HomeState.loading() : this._();

  const HomeState.success({
    required this.personajes,
    this.initialPage = 0,
    this.filter = '',
    this.favorites = const [],
  }) : status = HomeStatus.success;

  const HomeState.failure(this.filter)
      : status = HomeStatus.failure,
        personajes = const [],
        initialPage = 0,
        favorites = const [];

  final List<Personaje> personajes;
  final HomeStatus status;
  final int initialPage;
  final String filter;
  final List<String> favorites;

  bool get isLoading => status == HomeStatus.loading;
  bool get isSuccess => status == HomeStatus.success;

  HomeState updateFavorites(List<String> favorites) {
    return _copyWith(favorites: favorites);
  }

  HomeState updateStatus(HomeStatus status) {
    return _copyWith(status: status);
  }

  HomeState updateFilter(String filter) {
    return _copyWith(filter: filter);
  }

  HomeState _copyWith({
    List<Personaje>? personajes,
    HomeStatus? status,
    int? initialPage,
    String? filter,
    List<String>? favorites,
  }) {
    return HomeState._(
      personajes: personajes ?? this.personajes,
      status: status ?? this.status,
      initialPage: initialPage ?? this.initialPage,
      filter: filter ?? this.filter,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object> get props => [
        personajes,
        status,
        initialPage,
        filter,
        favorites,
      ];
}
