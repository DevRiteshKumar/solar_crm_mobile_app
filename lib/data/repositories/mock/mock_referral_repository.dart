import '../../../core/constants/app_constants.dart';
import '../../mock/mock_data.dart';
import '../../models/referral.dart';
import '../referral_repository.dart';

class MockReferralRepository implements ReferralRepository {
  @override
  Future<List<Referral>> getReferrals({String? query, DateTime? from, DateTime? to}) async {
    await Future.delayed(AppConstants.mockDelay);
    var result = List<Referral>.from(MockData.referrals);
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      result = result
          .where(
            (r) =>
                r.customerName.toLowerCase().contains(q) ||
                r.businessName.toLowerCase().contains(q) ||
                r.referredBy.toLowerCase().contains(q) ||
                r.contactNo.contains(q),
          )
          .toList();
    }
    return result;
  }
}
