import 'package:equatable/equatable.dart';

abstract class EarningsEvent extends Equatable {
  const EarningsEvent();

  @override
  List<Object?> get props => [];
}

class EarningsLoadRequested extends EarningsEvent {
  final String driverId;
  final DateTime? startDate;
  final DateTime? endDate;

  const EarningsLoadRequested({
    required this.driverId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [driverId, startDate, endDate];
}

class EarningsRefreshRequested extends EarningsEvent {
  const EarningsRefreshRequested();
}

class EarningsDateRangeChanged extends EarningsEvent {
  final DateTime startDate;
  final DateTime endDate;

  const EarningsDateRangeChanged({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
