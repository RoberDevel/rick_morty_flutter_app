part of 'detail_personaje_cubit.dart';

class DetailPersonajeState extends Equatable {
  const DetailPersonajeState(this.personaje, this.prefix);
  final Personaje personaje;
  final String prefix;

  @override
  List<Object> get props => [personaje, prefix];
}
