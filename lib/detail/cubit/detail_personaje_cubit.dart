import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_morty_flutter_app/api/api.dart';
import 'package:rick_morty_flutter_app/detail/detail_personaje_page.dart';

part 'detail_personaje_state.dart';

class DetailPersonajeCubit extends Cubit<DetailPersonajeState> {
  DetailPersonajeCubit({required DetailPersonajeArgs args})
      : super(
          DetailPersonajeState(args.personaje, args.prefix),
        );
}
