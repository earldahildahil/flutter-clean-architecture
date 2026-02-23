import 'package:equatable/equatable.dart';
import 'package:app/earnings/data/models/earnings_summary.dart';

abstract class EarningsState extends Equatable {
  const EarningsState();

  @override
  List<Object?> get props => [];
}

class EarningsInitial extends EarningsState {}

class EarningsLoading extends EarningsState {}

class EarningsLoaded extends EarningsState {
  final EarningsSummary summary;
  final DateTime startDate;
  final DateTime endDate;

  const EarningsLoaded({
    required this.summary,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [summary, startDate, endDate];
}

class EarningsError extends EarningsState {
  final String message;

  const EarningsError(this.message);

  @override
  List<Object?> get props => [message];
}
