// lib/main.dart
import 'package:flutter/material.dart';
import 'package:niffer_store/data/repositories/store_repository.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/services/storage_service.dart';
import 'routes/app_router.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/product_provider.dart';
import 'presentation/providers/store_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/order_provider.dart';
import 'core/constants/app_colors.dart';
import 'core/network/api_client.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/datasources/remote/auth_mock_datasource.dart';
import 'data/datasources/remote/product_remote_datasource.dart';
import 'data/datasources/remote/store_remote_datasource.dart';
import 'data/datasources/remote/order_remote_datasource.dart';
import 'data/datasources/local/auth_local_datasource.dart';
import 'core/constants/app_config.dart';
import 'dummy_data/dummy_data_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await StorageService.init();
  
  // Initialize dummy data for testing
  await DummyDataInitializer.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core Services
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),
        
        // Repositories
        Provider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: AppConfig.isDemoMode ? null : AuthRemoteDataSource(context.read<ApiClient>()),
            mockDataSource: AppConfig.isDemoMode ? AuthMockDataSource() : null,
            localDataSource: AuthLocalDataSource(),
          ),
        ),
        Provider<ProductRepositoryImpl>(
          create: (context) => ProductRepositoryImpl(
            remoteDataSource: ProductRemoteDataSource(context.read<ApiClient>()),
          ),
        ),
        Provider<StoreRepositoryImpl>(
          create: (context) => StoreRepositoryImpl(
            remoteDataSource: StoreRemoteDataSource(context.read<ApiClient>()),
          ),
        ),
        Provider<OrderRepositoryImpl>(
          create: (context) => OrderRepositoryImpl(
            remoteDataSource: OrderRemoteDataSource(context.read<ApiClient>()),
          ),
        ),
        
        // State Providers
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthRepositoryImpl>()),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(context.read<ProductRepositoryImpl>()),
        ),
        ChangeNotifierProvider<StoreProvider>(
          create: (context) => StoreProvider(context.read<StoreRepositoryImpl>()),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (context, authProvider, cartProvider) {
            if (cartProvider != null) {
              // Handle authentication state changes
              if (authProvider.isAuthenticated && cartProvider.isGuestMode) {
                // User just logged in, switch to user cart
                cartProvider.switchToUserCart();
              } else if (!authProvider.isAuthenticated && !cartProvider.isGuestMode) {
                // User just logged out, switch to guest cart
                cartProvider.switchToGuestCart();
              }
            }
            return cartProvider ?? CartProvider();
          },
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(context.read<OrderRepositoryImpl>()),
        ),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, authProvider, child) {
          return MaterialApp.router(
            title: 'Multi-Store E-commerce',
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.createRouter(authProvider),
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}