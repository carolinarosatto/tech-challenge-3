import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tech_challenge_3/app/di/container_registry.dart';
import 'package:tech_challenge_3/core/theme/theme.dart';
import 'package:tech_challenge_3/firebase_options.dart';
import 'package:tech_challenge_3/features/auth/presentation/providers/auth_provider.dart';
import 'package:tech_challenge_3/features/transactions/presentation/providers/transactions_provider.dart';
import 'package:tech_challenge_3/app/navigation/app_router.dart';
import 'package:tech_challenge_3/app/presentation/pages/home_page.dart';
import 'package:tech_challenge_3/features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //Configuração para rodar em ambiente dev
  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: ContainerRegistry.loginUseCase,
            registerUseCase: ContainerRegistry.registerUseCase,
            logoutUseCase: ContainerRegistry.logoutUseCase,
            watchAuthStateUseCase: ContainerRegistry.watchAuthStateUseCase,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TransactionsProvider?>(
          create: (context) => null,
          update: (context, authProvider, previous) {
            if (!authProvider.isAuthenticated || authProvider.user == null) {
              return null;
            }
            if (previous == null || previous.userId != authProvider.user!.uid) {
              return TransactionsProvider(
                userId: authProvider.user!.uid,
                watchTransactionsUseCase:
                    ContainerRegistry.watchTransactionsUseCase,
                watchTransactionsPageUseCase:
                    ContainerRegistry.watchTransactionsPageUseCase,
                saveTransactionUseCase:
                    ContainerRegistry.saveTransactionUseCase,
                deleteTransactionUseCase:
                    ContainerRegistry.deleteTransactionUseCase,
                calculateTotalsUseCase:
                    ContainerRegistry.calculateTotalsUseCase,
              );
            }
            return previous;
          },
        ),
      ],
      child: MaterialApp(
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Bytebank',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            // Enquanto está verificando o estado inicial
            if (authProvider.status == AuthStatus.initial) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Se está autenticado, vai para home
            if (authProvider.isAuthenticated) {
              return const HomePage(); // Sua HomePage
            }

            // Se não está autenticado, vai para login
            return const LoginPage();
          },
        ),
        routes: AppRouter.routes,
      ),
    );
  }
}
