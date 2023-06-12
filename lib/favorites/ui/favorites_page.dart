import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:rick_morty_flutter_app/api/data/datasources/rick_api_datasource.dart';
import 'package:rick_morty_flutter_app/auth/ui/cubit/auth_cubit.dart';
import 'package:rick_morty_flutter_app/detail/detail_personaje_page.dart';
import 'package:rick_morty_flutter_app/favorites/data/firebase_favorite_repository.dart';
import 'package:rick_morty_flutter_app/favorites/ui/cubit/favourite_cubit.dart';
import 'package:rick_morty_flutter_app/widgets/personaje_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavouriteCubit(
        favoriteRepository: FirebaseFavoriteRepository(
          apiDatasource: RickApiDatasource(),
        ),
      )..init(context.read<AuthCubit>().state.user!.id),
      child: const FavoritesView(),
    );
  }
}

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(title: const Text('Favorites')),
        const Expanded(child: _StateSwitcher())
      ],
    );
  }
}

class _StateSwitcher extends StatelessWidget {
  const _StateSwitcher();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouriteCubit, FavouriteState>(
      buildWhen: _stateHasChange,
      builder: (context, state) {
        switch (state.status) {
          case FavouriteStatus.loading:
            return const _LoadingView();
          case FavouriteStatus.loaded:
            return const _LoadedView();
          case FavouriteStatus.failed:
            return const _FailedView();
        }
      },
    );
  }

  bool _stateHasChange(FavouriteState previous, FavouriteState current) {
    return previous.status != current.status;
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lottie/morty.json',
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView();

  @override
  Widget build(BuildContext context) {
    final personajes = context.select(
      (FavouriteCubit cubit) => cubit.state.personajes,
    );

    return ListView.builder(
      itemCount: personajes.length,
      itemBuilder: (context, index) {
        return Builder(
          builder: (context) {
            return PersonajeCard(
              heroTag: 'favourite-${personajes[index].id}',
              personaje: personajes[index],
              isFavourite: true,
              onChangeFavourite: () =>
                  context.read<FavouriteCubit>().toggleFavorite(
                        context.read<AuthCubit>().state.user!.id,
                        personajes[index].id.toString(),
                      ),
              onTap: () => context.push(
                '/detail-personaje',
                extra: DetailPersonajeArgs(
                  personaje: personajes[index],
                  prefix: 'favourite',
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FailedView extends StatelessWidget {
  const _FailedView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No se pudo obtener los datos'),
    );
  }
}
