import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty_flutter_app/auth/auth.dart';
import 'package:rick_morty_flutter_app/l10n/l10n.dart';
import 'package:rick_morty_flutter_app/login/cubit/login_cubit.dart';
import 'package:rick_morty_flutter_app/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(authRepository: FirebaseAuthProvider()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return KeyboardCloser(
      child: _LoginListener(
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.loginTitle),
          ),
          body: const SingleChildScrollView(
            child: Column(
              children: [
                _LoginImage(),
                _FormSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginListener extends StatelessWidget {
  const _LoginListener({required Widget child}) : _child = child;

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: _stateHasChanged,
      listener: _listenState,
      child: _child,
    );
  }

  void _listenState(BuildContext context, LoginState state) {
    if (state.status == LoginStatus.success) {
      context.read<AuthCubit>().doLogin(state.user!);
      context.pushReplacement('/main');
    } else if (state.status == LoginStatus.genericFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.signupFailureMessage)),
      );
    } else if (state.status == LoginStatus.userNotFoundFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.invalidData)),
      );
    } else if (state.status == LoginStatus.wrongPasswordFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.invalidData)),
      );
    }
  }

  bool _stateHasChanged(LoginState previous, LoginState current) {
    return previous.status != current.status;
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _EmailField(),
            SizedBox(height: 16),
            _PasswordField(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_LoginButton(), _SignupButton()],
            ),
            SizedBox(height: 16),
            _GoWithoutLoginButton(),
            //  _BotonPrueba()
          ],
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: context.read<LoginCubit>().emailChanged,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: context.l10n.email,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return PasswordTextFormField(
      onChanged: context.read<LoginCubit>().passwordChanged,
      hintText: context.l10n.password,
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final isFilled = context.select(
      (LoginCubit cubit) => cubit.state.canDoLogin,
    );
    return ElevatedButton(
      onPressed: isFilled ? cubit.login : null,
      child: Text(context.l10n.loginTitle),
    );
  }
}

class _SignupButton extends StatelessWidget {
  const _SignupButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.pushReplacement('/signup'),
      child: Text(context.l10n.signupButton),
    );
  }
}

class _LoginImage extends StatelessWidget {
  const _LoginImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/rick_login.png');
  }
}

class _GoWithoutLoginButton extends StatelessWidget {
  const _GoWithoutLoginButton();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return InkWell(
      onTap: cubit.loginWithoutAuth,
      child: Text(context.l10n.goWithoutLogin),
    );
  }
}

class _BotonPrueba extends StatelessWidget {
  const _BotonPrueba();

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () async {}, child: Text('Prueba'));
  }
}
