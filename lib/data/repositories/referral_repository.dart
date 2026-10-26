import '../models/referral.dart';

abstract class ReferralRepository {
  Future<List<Referral>> getReferrals({String? query, DateTime? from, DateTime? to});
}
