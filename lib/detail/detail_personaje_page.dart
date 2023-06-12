import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_flutter_app/api/domain/domain.dart';
import 'package:rick_morty_flutter_app/detail/cubit/detail_personaje_cubit.dart';
import 'package:rick_morty_flutter_app/l10n/l10n.dart';

class DetailPersonajeArgs {
  const DetailPersonajeArgs({required this.personaje, required this.prefix});
  final Personaje personaje;
  final String prefix;
}

class DetailPersonajePage extends StatelessWidget {
  const DetailPersonajePage({
    super.key,
    required this.args,
  });
  final DetailPersonajeArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailPersonajeCubit(args: args),
      child: const DetailPersonajeView(),
    );
  }
}

class DetailPersonajeView extends StatelessWidget {
  const DetailPersonajeView({super.key});

  @override
  Widget build(BuildContext context) {
    final prefix = context.read<DetailPersonajeCubit>().state.prefix;
    final personaje = context.read<DetailPersonajeCubit>().state.personaje;

    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title:
              Text(context.read<DetailPersonajeCubit>().state.personaje.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Hero(
                  tag: '$prefix-${personaje.id}',
                  child: Image.network(
                    fit: BoxFit.cover,
                    context.read<DetailPersonajeCubit>().state.personaje.image,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                context.read<DetailPersonajeCubit>().state.personaje.name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const _Details()
            ],
          ),
        ));
  }
}

class _Details extends StatelessWidget {
  const _Details();

  @override
  Widget build(BuildContext context) {
    final isAlive =
        context.read<DetailPersonajeCubit>().state.personaje.status == 'Alive';
    final String statusText;
    final status = context.read<DetailPersonajeCubit>().state.personaje.status;
    if (status == 'Alive') {
      statusText = context.l10n.alive;
    } else if (status == 'Dead') {
      statusText = context.l10n.dead;
    } else {
      statusText = context.l10n.unknown;
    }

    var origin =
        context.read<DetailPersonajeCubit>().state.personaje.origin.name;

    if (origin == 'unknown') {
      origin = context.l10n.unknown;
    } else {
      origin = context.read<DetailPersonajeCubit>().state.personaje.origin.name;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: isAlive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    statusText,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                context.l10n.origin,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                origin,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                context.l10n.lastKnownLocation,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                context
                    .read<DetailPersonajeCubit>()
                    .state
                    .personaje
                    .location
                    .name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
    );
  }
}
