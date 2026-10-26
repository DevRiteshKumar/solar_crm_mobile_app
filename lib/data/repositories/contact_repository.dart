import '../models/contact.dart';

abstract class ContactRepository {
  Future<List<Contact>> getContacts({String? query});

  Future<Contact> createContact(Contact contact);

  Future<Contact> updateContact(Contact contact);

  Future<void> deleteContact(String id);

  Future<Contact?> getById(String id);
}
