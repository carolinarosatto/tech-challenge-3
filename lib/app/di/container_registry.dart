import 'package:tech_challenge_3/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:tech_challenge_3/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tech_challenge_3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/login_usecase.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/register_usecase.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/watch_auth_state_usecase.dart';
import 'package:tech_challenge_3/features/transactions/data/datasources/firestore_transactions_datasource.dart';
import 'package:tech_challenge_3/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:tech_challenge_3/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/calculate_totals_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/save_transaction_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/watch_transactions_page_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/watch_transactions_usecase.dart';

class ContainerRegistry {
  ContainerRegistry._();

  static final FirebaseAuthDatasource _firebaseAuthDatasource =
      FirebaseAuthDatasource();
  static final AuthRepository _authRepository = AuthRepositoryImpl(
    _firebaseAuthDatasource,
  );

  static final LoginUseCase _loginUseCase = LoginUseCase(_authRepository);
  static final RegisterUseCase _registerUseCase = RegisterUseCase(
    _authRepository,
  );
  static final LogoutUseCase _logoutUseCase = LogoutUseCase(_authRepository);
  static final WatchAuthStateUseCase _watchAuthStateUseCase =
      WatchAuthStateUseCase(_authRepository);

  static final FirestoreTransactionsDatasource _transactionsDatasource =
      FirestoreTransactionsDatasource();
  static final TransactionsRepository _transactionsRepository =
      TransactionsRepositoryImpl(_transactionsDatasource);

  static final WatchTransactionsUseCase _watchTransactionsUseCase =
      WatchTransactionsUseCase(_transactionsRepository);
  static final WatchTransactionsPageUseCase _watchTransactionsPageUseCase =
      WatchTransactionsPageUseCase(_transactionsRepository);
  static final SaveTransactionUseCase _saveTransactionUseCase =
      SaveTransactionUseCase(_transactionsRepository);
  static final DeleteTransactionUseCase _deleteTransactionUseCase =
      DeleteTransactionUseCase(_transactionsRepository);
  static const CalculateTotalsUseCase _calculateTotalsUseCase =
      CalculateTotalsUseCase();

  static LoginUseCase get loginUseCase => _loginUseCase;
  static RegisterUseCase get registerUseCase => _registerUseCase;
  static LogoutUseCase get logoutUseCase => _logoutUseCase;
  static WatchAuthStateUseCase get watchAuthStateUseCase =>
      _watchAuthStateUseCase;

  static WatchTransactionsUseCase get watchTransactionsUseCase =>
      _watchTransactionsUseCase;
  static WatchTransactionsPageUseCase get watchTransactionsPageUseCase =>
      _watchTransactionsPageUseCase;
  static SaveTransactionUseCase get saveTransactionUseCase =>
      _saveTransactionUseCase;
  static DeleteTransactionUseCase get deleteTransactionUseCase =>
      _deleteTransactionUseCase;
  static CalculateTotalsUseCase get calculateTotalsUseCase =>
      _calculateTotalsUseCase;
}
