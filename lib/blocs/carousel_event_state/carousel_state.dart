import 'package:equatable/equatable.dart';
import '../../models/schools.dart';

abstract class CarouselState extends Equatable {
  const CarouselState();

  @override
  List<Object> get props => [];
}

class CarouselInitial extends CarouselState {}

class CarouselLoading extends CarouselState {}

class CarouselLoaded extends CarouselState {
  final List<Schools> carousels;

  const CarouselLoaded(this.carousels);

  @override
  List<Object> get props => [carousels];
}

class CarouselError extends CarouselState {
  final String message;

  const CarouselError(this.message);

  @override
  List<Object> get props => [message];
}
