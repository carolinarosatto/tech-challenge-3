import 'package:flutter_test/flutter_test.dart';
import 'package:tech_challenge_3/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';

void main() {
  group('TransactionMapper', () {
    test('fromMap parses createdAt and keeps canonical fields', () {
      final map = {
        'id': 'tx-1',
        'userId': 'user-1',
        'category': 'food',
        'type': 'payment',
        'title': 'Mercado',
        'description': 'Compra mensal',
        'amount': 150.5,
        'createdAt': '2026-01-10T12:30:00.000Z',
      };

      final entity = TransactionMapper.fromMap(map);

      expect(entity.id, 'tx-1');
      expect(entity.userId, 'user-1');
      expect(entity.category, TransactionCategory.food);
      expect(entity.type, TransactionType.payment);
      expect(
        entity.createdAt.toUtc(),
        DateTime.parse('2026-01-10T12:30:00.000Z').toUtc(),
      );
    });

    test('fromMap uses legacy date field when createdAt is missing', () {
      final map = {
        'id': 'tx-2',
        'userId': 'user-2',
        'category': 'other',
        'type': 'deposit',
        'amount': 20,
        'date': '2026-01-11T00:00:00.000Z',
      };

      final entity = TransactionMapper.fromMap(map);

      expect(entity.type, TransactionType.deposit);
      expect(
        entity.createdAt.toUtc(),
        DateTime.parse('2026-01-11T00:00:00.000Z').toUtc(),
      );
    });

    test('toMap writes createdAt in canonical format', () {
      final entity = TransactionEntity(
        id: 'tx-3',
        userId: 'user-3',
        category: TransactionCategory.health,
        type: TransactionType.payment,
        title: 'Farmácia',
        description: 'Remédios',
        amount: 85.9,
        createdAt: DateTime.parse('2026-02-01T09:00:00.000Z'),
      );

      final map = TransactionMapper.toMap(entity);

      expect(map['createdAt'], '2026-02-01T09:00:00.000Z');
      expect(map.containsKey('date'), isFalse);
    });
  });
}
