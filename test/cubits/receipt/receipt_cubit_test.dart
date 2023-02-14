import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/data/repositories/v1/receipt_repository.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'receipt_cubit_test.mocks.dart';

final dummyReceipts = [
  Receipt(
    id: 1,
    productName: 'Coffee',
    transactionType: TransactionType.purchase,
    price: 1,
    amountPurchased: 1,
    timeUsed: DateTime.now(),
  ),
  Receipt(
    id: 2,
    productName: 'Coffee',
    transactionType: TransactionType.ticketSwipe,
    price: 1,
    amountPurchased: 1,
    timeUsed: DateTime.now(),
  ),
];

@GenerateMocks([ReceiptRepository])
void main() {
  group('receipt cubit tests', () {
    late ReceiptCubit receiptCubit;
    final repo = MockReceiptRepository();

    setUp(() {
      receiptCubit = ReceiptCubit(repo);
    });

    blocTest<ReceiptCubit, ReceiptState>(
      'fetchReceipts emits ReceiptState (with Status.success and null error) after successful fetch',
      build: () {
        when(repo.getUserReceipts())
            .thenAnswer((_) async => Right(dummyReceipts));
        return receiptCubit;
      },
      act: (cubit) => cubit.fetchReceipts(),
      expect: () => [
        isA<ReceiptState>()
            .having((state) => state.status, 'status', ReceiptStatus.success)
            .having((state) => state.error, 'error', isNull)
            .having((state) => state.receipts, 'all receipts', dummyReceipts)
      ],
    );

    blocTest<ReceiptCubit, ReceiptState>(
      'fetchReceipts emits ReceiptState (with Status.failure and non-null error) after failed fetch',
      build: () {
        when(repo.getUserReceipts()).thenAnswer(
          (_) async => Left(RequestHttpFailure('ERROR_MESSAGE', 0)),
        );
        return receiptCubit;
      },
      act: (cubit) => cubit.fetchReceipts(),
      expect: () => [
        isA<ReceiptState>()
            .having((state) => state.status, 'status', ReceiptStatus.failure)
            .having((state) => state.error, 'error', isNotNull),
      ],
    );

    blocTest<ReceiptCubit, ReceiptState>(
      'filterReceipts emits ReceiptState (with Status.success, appropriate filterBy/filteredReceipts, and correct dropdown name)',
      build: () {
        when(repo.getUserReceipts())
            .thenAnswer((_) async => Right(dummyReceipts));
        return receiptCubit;
      },
      act: (cubit) async {
        await cubit.fetchReceipts();
        cubit.filterReceipts(ReceiptFilterCategory.swipes);
        cubit.filterReceipts(ReceiptFilterCategory.purchases);
      },
      // Skip the first state emitted by fetchReceipts
      skip: 1,
      expect: () => [
        isA<ReceiptState>()
            .having((s) => s.status, '', ReceiptStatus.success)
            .having((s) => s.filterBy, '', ReceiptFilterCategory.swipes)
            .having((s) => s.filteredReceipts, '', [dummyReceipts[1]]),
        isA<ReceiptState>()
            .having((s) => s.status, '', ReceiptStatus.success)
            .having((s) => s.filterBy, '', ReceiptFilterCategory.purchases)
            .having((s) => s.filteredReceipts, '', [dummyReceipts[0]]),
      ],
      verify: (cubit) {
        expect(cubit.state.filterBy.name, Strings.receiptFilterPurchases);
      },
    );

    tearDown(() {
      receiptCubit.close();
    });
  });
}
