import 'package:equatable/equatable.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';

abstract class CarouselState extends Equatable {
  const CarouselState();

  @override
  List<Object?> get props => [];
}

class CarouselInitial extends CarouselState {}

class CarouselLoading extends CarouselState {}

class CarouselLoaded extends CarouselState {
  final List<SchoolEntity> carousels;

  const CarouselLoaded(this.carousels);

  @override
  List<Object?> get props => [carousels];
}

class CarouselError extends CarouselState {
  final String message;
  final bool isNetworkError;

  const CarouselError({
    required this.message,
    this.isNetworkError = false,
  });

  @override
  List<Object?> get props => [message, isNetworkError];
}
