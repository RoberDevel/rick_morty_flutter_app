import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty_flutter_app/auth/auth.dart';
import 'package:rick_morty_flutter_app/l10n/l10n.dart';
import 'package:rick_morty_flutter_app/signup/cubit/signup_cubit.dart';
import 'package:rick_morty_flutter_app/widgets/widgets.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(
        authRepository: FirebaseAuthProvider(),
      ),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return KeyboardCloser(
      child: _SignupListener(
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.signupTitle),
          ),
          body: const SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                _RegisterImage(),
                _FormSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupListener extends StatelessWidget {
  const _SignupListener({required Widget child}) : _child = child;

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: _listenState,
      child: _child,
    );
  }

  void _listenState(BuildContext context, SignupState state) {
    if (state.status == SignupStatus.success) {
      context.read<AuthCubit>().doLogin(state.user!);
      context.pushReplacement('/main');
    } else if (state.status == SignupStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.signupFailureMessage),
        ),
      );
    } else if (state.status == SignupStatus.incorrectMatchPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.incorrectMatchPassword),
        ),
      );
    }
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _EmailField(),
              SizedBox(height: 16),
              _PasswordField(),
              SizedBox(height: 16),
              _CheckPasswordField(),
              SizedBox(height: 16),
              _SignupButton(),
              _LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: context.select(
        (SignupCubit cubit) => cubit.state.isSubmitting,
      ),
      onChanged: context.read<SignupCubit>().emailChanged,
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
      onChanged: context.read<SignupCubit>().passwordChanged,
      hintText: context.l10n.password,
    );
  }
}

class _CheckPasswordField extends StatelessWidget {
  const _CheckPasswordField();

  @override
  Widget build(BuildContext context) {
    return PasswordTextFormField(
      onChanged: context.read<SignupCubit>().passwordChanged2,
      hintText: context.l10n.password,
    );
  }
}

class _SignupButton extends StatelessWidget {
  const _SignupButton();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();
    final canDoSubmit = context.select(
      (SignupCubit cubit) => cubit.state.canDoSubmit,
    );

    return ElevatedButton(
      onPressed: canDoSubmit ? cubit.submit : null,
      child: Text(context.l10n.signupTitle),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.pushReplacement('/login');
      },
      child: Text(context.l10n.goBackToLogin),
    );
  }
}

class _RegisterImage extends StatelessWidget {
  const _RegisterImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/rick_registro.jpg');
  }
}
