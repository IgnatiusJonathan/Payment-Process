import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:intl/date_symbol_data_local.dart';
import 'features/auth/screens/login_page.dart';
import 'features/auth/screens/register_page.dart';
import 'screens/main_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'database/database.dart';
import 'database/user_repository.dart';
import 'models/user.dart' as user_model;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final database = await ref.read(databaseProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final databaseAsync = ref.watch(databaseProvider);

    return databaseAsync.when(
      loading: () => MaterialApp(
        home: _buildLoadingScreen(context),
        debugShowCheckedModeBanner: false,
      ),
      error: (error, stack) => MaterialApp(
        home: _buildErrorScreen(context, error),
        debugShowCheckedModeBanner: false,
      ),
      data: (database) => provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(
            create: (_) {
              return AuthProvider(database);
            },
          ),
        ],
        child: MaterialApp(
          title: 'Scannabit',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 21, 27, 38),
              secondary: Color.fromARGB(255, 35, 52, 70),
              tertiary: Color.fromARGB(255, 48, 62, 82),
              surface: Color.fromARGB(255, 11, 14, 22),
              onPrimary: Color.fromARGB(255, 255, 255, 255),
              onSecondary: Color.fromARGB(255, 255, 255, 255),
            ),
            scaffoldBackgroundColor: const Color.fromARGB(255, 21, 27, 38),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.white,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromARGB(255, 48, 62, 82),
              selectedItemColor: Color.fromARGB(120, 255, 255, 255),
              unselectedItemColor: Color.fromARGB(90, 255, 255, 255),
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(color: Colors.white),
              displayMedium: TextStyle(color: Colors.white),
              displaySmall: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
              titleSmall: TextStyle(color: Colors.white),
            ),
          ),
          home: const AuthWrapper(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 27, 38),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading Scannabit...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context, Object error) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 27, 38),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color.fromARGB(255, 175, 103, 117),
              size: 64,
            ),
            const SizedBox(height: 20),
            Text(
              'Error: $error',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(databaseProvider);
              },
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  Future<user_model.User?>? _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _getStoredUser();
  }

  Future<user_model.User?> _getStoredUser() async {
    final database = await ref.read(databaseProvider.future);
    final userRepo = UserRepository(database);
    final users = await userRepo.getAllUsers();

    if (users.isEmpty) {
      return null;
    }

    final userData = users.first;
    return user_model.User(
      userId: userData['userID'] as int,
      username: userData['username'] as String,
      password: userData['password'] as String,
      totalSaldo: userData['totalSaldo'] as int,
      isLoggedIn: true,
      email: userData['email'] as String? ?? '',
      phone: userData['phone'] as String? ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<user_model.User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildAuthLoadingScreen(context);
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const LoginPage();
        }

        final user = snapshot.data!;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final authProvider = provider.Provider.of<AuthProvider>(
            context,
            listen: false,
          );
          if (authProvider.currentUser?.username != user.username) {
            authProvider.setLoggedIn(user.username);
          }
        });

        return MainScreen(user: user);
      },
    );
  }

  Widget _buildAuthLoadingScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 27, 38),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Memeriksa Autentikasi...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
