import '../../../core/constants/app_constants.dart';
import '../../mock/mock_data.dart';
import '../../models/dashboard_stats.dart';
import '../dashboard_repository.dart';

class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardStats> getStats({DateTime? from, DateTime? to}) async {
    await Future.delayed(AppConstants.mockDelay);
    return MockData.dashboardStats;
  }
}
