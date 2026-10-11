import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../core/api_client.dart';
import '../../../core/utils/app_log.dart';
import '../../../core/models/user.dart';
import '../../../core/models/product.dart';
import '../../../core/models/product_category.dart';
import '../model/dashboard_summary.dart';
import '../model/featured_collection.dart';

abstract class HomeRepository {
  Future<User?> getProfile();
  Future<User?> updateProfile(Map<String, dynamic> updateData);
  Future<DashboardSummary?> getSummary();
  Future<List<FeaturedCollection>> getCollections();
  Future<List<ProductCategory>> getCategories();
  Future<List<Product>> getLatestProducts();
  Future<String?> uploadProfileImage(String filePath);
}

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient apiClient;

  HomeRepositoryImpl({required this.apiClient});

  dynamic _parseData(dynamic data) {
    if (data is String) {
      try {
        return jsonDecode(data);
      } catch (_) {
        // Sin $e: el cuerpo puede contener PII.
        AppLog.d('Error decoding JSON response');
      }
    }
    return data;
  }

  @override
  Future<User?> getProfile() async {
    try {
      final response = await apiClient.dio.get('/users/profile');
      if (response.statusCode == 200) {
        final parsedData = _parseData(response.data);
        return User.fromJson(parsedData);
      }
      AppLog.d('getProfile unexpected status: ${response.statusCode}');
      return null;
    } catch (e) {
      // Solo el tipo, sin mensaje/stacktrace (pueden llevar token o PII).
      AppLog.d('getProfile failed: ${e.runtimeType}');
      return null;
    }
  }

  @override
  Future<User?> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.dio.patch(
        '/users/profile',
        data: updateData,
      );
      if (response.statusCode == 200) {
        final parsedData = _parseData(response.data);
        return User.fromJson(parsedData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<DashboardSummary?> getSummary() async {
    try {
      final response = await apiClient.dio.get('/dashboard/summary');
      if (response.statusCode == 200) {
        final parsedData = _parseData(response.data);
        return DashboardSummary.fromJson(parsedData);
      }
      return null;
    } catch (e) {
      AppLog.d('getSummary failed: ${e.runtimeType}');
      return null;
    }
  }

  @override
  Future<List<FeaturedCollection>> getCollections() async {
    try {
      final response = await apiClient.dio.get('/collections');
      if (response.statusCode == 200) {
        final parsedData = _parseData(response.data);
        final all = (parsedData as List)
            .map((i) => FeaturedCollection.fromJson(i as Map<String, dynamic>))
            .toList();
        // Only visible collections reach the home.
        return all.where((c) => c.isActive).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ProductCategory>> getCategories() async {
    try {
      final response = await apiClient.dio.get('/products/categories');
      if (response.statusCode == 200) {
        final parsedData = _parseData(response.data);
        return (parsedData as List)
            .map((i) => ProductCategory.fromJson(i))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Product>> getLatestProducts() async {
    try {
      final response = await apiClient.dio.get('/products');
      if (response.statusCode == 200) {
        final parsedData = _parseData(response.data);
        return (parsedData as List).map((i) => Product.fromJson(i)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String?> uploadProfileImage(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await apiClient.dio.post('/users/upload', data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsedData = _parseData(response.data);
        return parsedData['photoUrl'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
