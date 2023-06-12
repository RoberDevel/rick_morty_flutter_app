import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_flutter_app/auth/auth.dart';
import 'package:rick_morty_flutter_app/favorites/ui/favorites_page.dart';
import 'package:rick_morty_flutter_app/home/home.dart';
import 'package:rick_morty_flutter_app/l10n/l10n.dart';
import 'package:rick_morty_flutter_app/quote/quote.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _index = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      const HomePage(),
      if (context.read<AuthCubit>().state.user!.isNotEmpty)
        const FavoritesPage(),
      const QuotePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: _CustomBottomNavigation(
        selectedIndex: _index,
        onChange: _updateSelectedPage,
      ),
    );
  }

  void _updateSelectedPage(int page) {
    setState(() {
      _index = page;
    });
  }
}

class _CustomBottomNavigation extends StatelessWidget {
  const _CustomBottomNavigation({
    required ValueChanged<int> onChange,
    required int selectedIndex,
  })  : _onChange = onChange,
        _selectedIndex = selectedIndex;

  final ValueChanged<int> _onChange;
  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onChange,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: context.l10n.home,
        ),
        if (context.read<AuthCubit>().state.user!.isNotEmpty)
          BottomNavigationBarItem(
            icon: const Icon(Icons.star_border_rounded),
            label: context.l10n.favorites,
          ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.music_note_outlined),
          label: context.l10n.quotes,
        ),
      ],
    );
  }
}
