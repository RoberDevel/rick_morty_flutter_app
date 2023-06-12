import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty_flutter_app/api/api.dart';
import 'package:rick_morty_flutter_app/auth/auth.dart';
import 'package:rick_morty_flutter_app/detail/detail_personaje_page.dart';
import 'package:rick_morty_flutter_app/favorites/data/firebase_favorite_repository.dart';
import 'package:rick_morty_flutter_app/home/cubit/home_cubit.dart';
import 'package:rick_morty_flutter_app/widgets/personaje_card.dart';
import 'package:rick_morty_flutter_app/widgets/search_text_field.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!;
    return BlocProvider(
      lazy: false,
      create: (context) => HomeCubit(
        favoriteRepository: FirebaseFavoriteRepository(
          apiDatasource: RickApiDatasource(),
        ),
        rickRepository: RickRepositoryImpl(
          RickApiDatasource(),
        ),
      )..init(user.id, user.isEmpty),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: const Text('Home'),
          actions: const [
            Expanded(child: _SearchBar()),
            _LogoutButton(),
          ],
        ),
        const Expanded(child: _StateSwitcher()),
        /*  Align(
          alignment: Alignment.bottomRight,
          child: Visibility(
            visible: true,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.arrow_upward),
            ),
          ),
        )*/
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  var _isOpen = false;
  @override
  Widget build(BuildContext context) {
    return ExpandedWidget(
      isOpen: _isOpen,
      closeIcon: 'assets/images/iconSearch.png',
      openIcon: 'assets/images/iconArrowLeft.png',
      onChanged: _toggleVisibility,
      child: TextFormField(
        onChanged: (value) {
          context.read<HomeCubit>().getFilteredCharacters(value);
        },
        decoration: const InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
          filled: false,
        ),
      ),
    );
  }

  void _toggleVisibility(bool value) {
    setState(() {
      _isOpen = value;
    });
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        context.pushReplacement('/login');
        await context.read<AuthCubit>().doLogout();
      },
    );
  }
}

class _StateSwitcher extends StatelessWidget {
  const _StateSwitcher();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: _changeStatus,
      builder: (context, state) {
        if (state.isLoading) {
          return const _LoadingView();
        } else if (state.isSuccess) {
          return const _LoadedView();
        } else {
          return const Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  bool _changeStatus(HomeState previous, HomeState current) {
    return previous.status != current.status;
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView();

  @override
  Widget build(BuildContext context) {
    return const _PersonajeListView();
  }
}

class _PersonajeListView extends StatefulWidget {
  const _PersonajeListView();

  @override
  State<_PersonajeListView> createState() => _PersonajeListViewState();
}

class _PersonajeListViewState extends State<_PersonajeListView> {
  var showFab = false;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final personajes = context.select(
      (HomeCubit cubit) => cubit.state.personajes,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: PaginatedListView<Personaje>(
            controller: _scrollController,
            onNotification: _updateFabVisibility,
            loadData: () => context.read<HomeCubit>().getPersonajes(),
            initialValues: personajes,
            itemBuilder: (context, index, personaje) {
              return Builder(
                builder: (context) {
                  final isAnonimous =
                      context.read<AuthCubit>().state.user!.isEmpty;
                  final isFavourite = context.select(
                    (HomeCubit cubit) => cubit.state.favorites.contains(
                      personaje.id.toString(),
                    ),
                  );
                  return PersonajeCard(
                    heroTag: 'home-${personaje.id}',
                    personaje: personajes[index],
                    isFavourite: isFavourite,
                    onChangeFavourite: isAnonimous
                        ? null
                        : () => context.read<HomeCubit>().toggleFavorite(
                              context.read<AuthCubit>().state.user!.id,
                              personaje.id.toString(),
                              isFavourite,
                            ),
                    onTap: () => context.push(
                      '/detail-personaje',
                      extra: DetailPersonajeArgs(
                          personaje: personaje, prefix: 'home'),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 12),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Visibility(
              visible: showFab,
              child: FloatingActionButton(
                onPressed: _resetScroll,
                child: const Icon(Icons.arrow_upward),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _updateFabVisibility(ScrollUpdateNotification value) {
    if (value.metrics.pixels > 1000 && !showFab) {
      setState(() {
        showFab = true;
      });
    } else if (value.metrics.pixels <= 1000 && showFab) {
      setState(() {
        showFab = false;
      });
    }
    return true;
  }

  void _resetScroll() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.decelerate,
    );
  }
}

class PaginatedListView<T> extends StatefulWidget {
  const PaginatedListView({
    required this.loadData,
    required this.itemBuilder,
    required this.initialValues,
    required this.controller,
    super.key,
    this.onNotification,
  });

  final Future<void> Function() loadData;
  final Widget Function(BuildContext, int, T) itemBuilder;
  final List<T> initialValues;
  final bool Function(ScrollUpdateNotification)? onNotification;
  final ScrollController controller;

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  var _isFetching = false;
  late List<T> _elementList;

  @override
  void initState() {
    super.initState();
    _elementList = widget.initialValues;

    widget.controller.addListener(
      _fetchData,
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (_isFetching) return;
    if (widget.controller.offset <
        (widget.controller.position.maxScrollExtent * .75)) {
      return;
    }
    _isFetching = true;
    await widget.loadData();
    _isFetching = false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: widget.onNotification,
      child: ListView.builder(
        controller: widget.controller,
        itemCount: widget.initialValues.length,
        itemBuilder: (context, index) => widget.itemBuilder(
          context,
          index,
          widget.initialValues[index],
        ),
      ),
    );
  }
}
