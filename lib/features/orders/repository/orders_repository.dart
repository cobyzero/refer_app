import '../../../core/api_client.dart';

abstract class OrdersRepository {
  /// Order-first flow: creates a PENDING_PAYMENT order priced server-side.
  Future<Map<String, dynamic>?> createOrder(Map<String, dynamic> orderData);
  Future<List<dynamic>?> getOrders();
  /// Settles a pending order after the Stripe sheet (server verifies).
  Future<Map<String, dynamic>?> confirmOrder(String orderId);
  /// Voids a pending order (e.g. user cancelled the payment sheet).
  Future<bool> cancelOrder(String orderId);
}

class OrdersRepositoryImpl implements OrdersRepository {
  final ApiClient apiClient;

  OrdersRepositoryImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>?> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await apiClient.dio.post('/orders', data: orderData);
      if (response.statusCode == 201) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> confirmOrder(String orderId) async {
    try {
      final response = await apiClient.dio.post('/orders/$orderId/confirm');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> cancelOrder(String orderId) async {
    try {
      final response = await apiClient.dio.post('/orders/$orderId/cancel');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<dynamic>?> getOrders() async {
    try {
      final response = await apiClient.dio.get('/orders');
      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
