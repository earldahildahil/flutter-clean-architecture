import 'package:app/earnings/data/datasources/earnings_datasource.dart';
import 'package:app/earnings/data/models/earnings_summary.dart';

/// Repositories should NOT import Supabase/Firebase directly.
/// They work with datasources and domain entities only.
class EarningsRepository {
  final EarningsDataSource _dataSource;

  EarningsRepository(this._dataSource);

  Future<EarningsSummary> getEarnings({
    required String driverId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final summaryData = await _dataSource.fetchEarningsSummary(
        driverId: driverId,
        startDate: startDate,
        endDate: endDate,
      );

      final dailyData = await _dataSource.fetchDailyEarnings(
        driverId: driverId,
        startDate: startDate,
        endDate: endDate,
      );

      final dailyBreakdown = dailyData.map((json) => DailyEarning(
        date: DateTime.parse(json['date'] as String),
        amount: (json['amount'] as num).toDouble(),
        trips: json['trip_count'] as int,
      )).toList();

      return EarningsSummary(
        totalEarnings: (summaryData['total_earnings'] as num).toDouble(),
        tips: (summaryData['tips'] as num).toDouble(),
        bonuses: (summaryData['bonuses'] as num).toDouble(),
        completedTrips: summaryData['completed_trips'] as int,
        onlineHours: (summaryData['online_hours'] as num).toDouble(),
        dailyBreakdown: dailyBreakdown,
      );
    } catch (e) {
      throw Exception('Failed to fetch earnings: $e');
    }
  }
}
