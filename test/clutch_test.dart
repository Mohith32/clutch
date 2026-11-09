import 'package:clutch/data/store.dart';
import 'package:clutch/domain/profile.dart';
import 'package:flutter_test/flutter_test.dart';

Profile asha() => Profile(
      displayName: 'Asha Rao',
      bloodGroup: 'O+',
      allergies: ['Penicillin', 'Peanuts'],
      meds: [Med(name: 'Salbutamol')],
      contacts: [Contact(name: 'Ravi Rao', relation: 'Father', phone: '+91 90000 00000')],
      updatedAt: DateTime(2026, 11, 9),
    );

void main() {
  test('QR payload matches the PRD example', () {
    final p = asha()..visibility[Output.qr]!.remove(Field.sos);
    expect(
      qrPayload(p),
      'EMERGENCY | Asha Rao | Blood O+ | Allergy: Penicillin, Peanuts | Call: Ravi Rao (Father) +91 90000 00000 '
      '| Meds: Salbutamol | Updated 2026-11-09',
    );
  });

  test('QR payload stays within 300 chars, keeps the essentials, drops low priority first', () {
    final p = asha()
      ..allergies.addAll(List.generate(12, (i) => 'Allergen number $i'))
      ..notes = 'n' * 140
      ..doctorName = 'Dr Long Name'
      ..doctorPhone = '+91 98765 43210'
      ..contacts.addAll([Contact(name: 'B', phone: '12345678'), Contact(name: 'C', phone: '87654321')]);
    final s = qrPayload(p, sos: '112');
    expect(s.length, lessThanOrEqualTo(qrMax));
    expect(s, startsWith('EMERGENCY | Asha Rao | Blood O+ | Allergy: Penicillin'));
    expect(s, endsWith('Updated 2026-11-09'));
    expect(s, isNot(contains('Note:'))); // lowest priority goes first
  });

  test('QR respects per-output visibility', () {
    final p = asha()..visibility[Output.qr] = {Field.name};
    expect(qrPayload(p, sos: '112'), 'EMERGENCY | Asha Rao | Updated 2026-11-09');
  });

  test('phone validation', () {
    for (final ok in ['', '+91 90000 00000', '040-2345 6789', '(555) 123-4567', '112233']) {
      expect(validPhone(ok), isTrue, reason: ok);
    }
    for (final bad in ['abc', '12', '+91 9000x', '1234567890123456', '++91 1234567']) {
      expect(validPhone(bad), isFalse, reason: bad);
    }
  });

  test('profile JSON round trip', () {
    final p = asha()
      ..organDonor = true
      ..visibility[Output.wallpaper] = {Field.blood}
      ..language = 'te';
    final q = Profile.fromJson(p.toJson());
    expect(q.toJson(), p.toJson());
  });

  test('regional emergency numbers', () {
    expect(sosFor('IN'), '112');
    expect(sosFor('us'), '911');
    expect(sosFor(null), '112');
  });

  test('backup round trip, with and without passphrase', () async {
    final data = [asha().toJson()];
    final plain = await encodeBackup(data, '');
    expect((await decodeBackup(plain, ''))[0]['displayName'], 'Asha Rao');

    final locked = await encodeBackup(data, 'correct horse');
    expect(locked, isNot(contains('Asha')));
    expect((await decodeBackup(locked, 'correct horse'))[0]['displayName'], 'Asha Rao');
    await expectLater(decodeBackup(locked, 'wrong'), throwsA(isA<WrongPassphrase>()));
    await expectLater(decodeBackup(locked, ''), throwsA(isA<NeedsPassphrase>()));
  });

  test('QR link fits 300 chars and decodes back to the payload', () {
    final p = asha()
      ..allergies.addAll(List.generate(12, (i) => 'Allergen_$i ~ weird'))
      ..notes = 'n' * 140;
    final url = qrUrl(p, sos: '112');
    expect(url.length, lessThanOrEqualTo(qrMax));
    expect(url, startsWith('$cardHost#EMERGENCY~Asha_Rao~Blood_O%2B'));
    final text = decodeQrFragment(url.split('#')[1]);
    expect(text, startsWith('EMERGENCY | Asha Rao | Blood O+ | Allergy: Penicillin, Peanuts'));
    expect(text, endsWith('Updated 2026-11-09'));
    expect(decodeQrFragment(encodeQrFragment('Hi | राम_~ | +91 (0)')), 'Hi | राम_~ | +91 (0)');
  });
}
