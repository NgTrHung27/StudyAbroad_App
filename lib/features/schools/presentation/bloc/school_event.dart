import 'package:equatable/equatable.dart';

abstract class SchoolEvent extends Equatable {
  const SchoolEvent();

  @override
  List<Object?> get props => [];
}

class GetSchoolListEvent extends SchoolEvent {
  const GetSchoolListEvent();
}

class GetSchoolListByCountryEvent extends SchoolEvent {
  final String country;

  const GetSchoolListByCountryEvent(this.country);

  @override
  List<Object?> get props => [country];
}

class GetUniqueCountriesEvent extends SchoolEvent {
  const GetUniqueCountriesEvent();
}
