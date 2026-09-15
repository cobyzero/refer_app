import 'package:go_router/go_router.dart';
import 'package:refer_app/features/search/ui/search_screen.dart';
import '../features/splash/ui/splash_screen.dart';
import '../features/splash/ui/maintenance_screen.dart';
import '../features/splash/ui/update_required_screen.dart';
import '../features/auth/ui/auth_screen.dart';
import '../features/auth/ui/signup_screen.dart';
import '../features/navigator/ui/main_navigator.dart';
import '../features/product_details/ui/product_details_screen.dart';
import '../features/cart/ui/cart_screen.dart';
import '../features/cart/ui/checkout_screen.dart';
import '../features/settings/ui/edit_profile_screen.dart';
import '../features/settings/ui/change_password_screen.dart';
import '../features/settings/ui/help_center_screen.dart';
import '../features/orders/ui/order_history_screen.dart';
import '../features/orders/ui/order_detail_screen.dart';
import '../features/cart/ui/order_status_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/search/bloc/search_bloc.dart';
import '../features/search/bloc/search_event.dart';
import '../features/home/ui/menu_screen.dart';
import '../features/auth/ui/forgot_password_screen.dart';
import '../features/auth/ui/reset_password_screen.dart';
import '../features/auth/ui/verify_email_screen.dart';
import '../features/stars/ui/stars_history_screen.dart';
import '../features/stars/bloc/stars_bloc.dart';
import '../features/stars/bloc/stars_event.dart';
import 'di.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/maintenance',
      builder: (context, state) => const MaintenanceScreen(),
    ),
    GoRoute(
      path: '/update-required',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return UpdateRequiredScreen(
          minVersion: extra['minVersion'] as String? ?? '',
          installedVersion: extra['installedVersion'] as String? ?? '',
        );
      },
    ),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return ResetPasswordScreen(email: email);
      },
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return VerifyEmailScreen(email: email);
      },
    ),
    GoRoute(path: '/main', builder: (context, state) => const MainNavigator()),
    GoRoute(
      path: '/home', // Alias commonly used
      builder: (context, state) => const MainNavigator(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailsScreen(productId: id);
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<SearchBloc>()..add(FetchCategories()),
        child: const SearchScreen(),
      ),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
        return CheckoutScreen(
          redeemedRewardId: extra?['redeemedRewardId'],
          redeemedRewardTitle: extra?['redeemedRewardTitle'],
          redeemedRewardImage: extra?['redeemedRewardImage'],
        );
      },
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/order-history',
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: '/stars-history',
      builder: (context, state) {
        final bloc = state.extra as StarsBloc?;
        if (bloc != null) {
          return BlocProvider.value(
            value: bloc,
            child: const StarsHistoryScreen(),
          );
        }
        return BlocProvider(
          create: (context) => sl<StarsBloc>()..add(StarsStarted()),
          child: const StarsHistoryScreen(),
        );
      },
    ),
    GoRoute(
      path: '/order-status',
      builder: (context, state) {
        final orderId = state.uri.queryParameters['orderId'] ?? 'ER-9842';
        final locationName =
            state.uri.queryParameters['locationName'] ?? 'Downtown Studio';
        return OrderStatusScreen(orderId: orderId, locationName: locationName);
      },
    ),
    GoRoute(
      path: '/order-detail',
      builder: (context, state) {
        final order = state.extra as Map<String, dynamic>;
        return OrderDetailScreen(order: order);
      },
    ),
    GoRoute(
      path: '/help-center',
      builder: (context, state) => const HelpCenterScreen(),
    ),
  ],
);
