import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:rick_morty_flutter_app/auth/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _checkStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: _updateMainPage,
      child: Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/lottie/morty.json',
            controller: _controller,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..repeat();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _checkStatus() async {
    await Future<void>.delayed(const Duration(milliseconds: 3000));
    if (context.mounted) {
      context.read<AuthCubit>().checkStatus();
    }
  }

  void _updateMainPage(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.authenticated) {
      context.pushReplacement('/main');
    } else if (state.status == AuthStatus.unauthenticated) {
      context.pushReplacement('/login');
    }
  }
}
