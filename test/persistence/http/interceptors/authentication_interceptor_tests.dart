import 'package:chopper/chopper.dart';
import 'package:coffeecard/persistence/http/interceptors/authentication_interceptor.dart';
import 'package:coffeecard/persistence/storage/secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_interceptor_tests.mocks.dart';

@GenerateMocks([SecureStorage])
void main() {
  test(
      'WHEN calling onRequest GIVEN a token in SecureStorage THEN Authorization Header is added to the request',
      () async {
    const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

    final mockSecureStorage = MockSecureStorage();
    when(mockSecureStorage.readToken())
        .thenAnswer((_) => Future<String>.value(token));

    final interceptor = AuthenticationInterceptor(mockSecureStorage);
    const request = Request('POST', 'url', 'baseurl');

    final result = await interceptor.onRequest(request);

    expect(result.headers.containsKey('Authorization'), isTrue);
    expect(result.headers['Authorization'], equals('Bearer $token'));
  });

  test(
      'WHEN calling onRequest GIVEN no token in SecureStorage THEN no Authorization Header is added to the request',
      () async {
    final mockSecureStorage = MockSecureStorage();
    // ignore: prefer_void_to_null
    when(mockSecureStorage.readToken()).thenAnswer((_) => Future<Null>.value());

    final interceptor = AuthenticationInterceptor(mockSecureStorage);
    const request = Request('POST', 'url', 'baseurl');

    final result = await interceptor.onRequest(request);

    expect(result.headers.containsKey('Authorization'), isFalse);
  });
}