import '../../../core/constants/app_constants.dart';
import '../../mock/mock_data.dart';
import '../../models/contact.dart';
import '../contact_repository.dart';

class MockContactRepository implements ContactRepository {
  final List<Contact> _contacts = List.from(MockData.contacts);

  @override
  Future<List<Contact>> getContacts({String? query}) async {
    await Future.delayed(AppConstants.mockDelay);
    if (query == null || query.trim().isEmpty) return List.from(_contacts);
    final q = query.toLowerCase();
    return _contacts
        .where(
          (c) =>
              c.fullName.toLowerCase().contains(q) ||
              (c.jobTitle?.toLowerCase().contains(q) ?? false) ||
              c.phone1.contains(q) ||
              (c.email?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  @override
  Future<Contact> createContact(Contact contact) async {
    await Future.delayed(AppConstants.mockDelay);
    final created = contact.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
    _contacts.insert(0, created);
    return created;
  }

  @override
  Future<Contact> updateContact(Contact contact) async {
    await Future.delayed(AppConstants.mockDelay);
    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
    }
    return contact;
  }

  @override
  Future<void> deleteContact(String id) async {
    await Future.delayed(AppConstants.mockDelay);
    _contacts.removeWhere((c) => c.id == id);
  }

  @override
  Future<Contact?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _contacts.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
