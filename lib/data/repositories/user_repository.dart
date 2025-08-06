import '../models/user_model.dart';
import '../../core/services/api_service.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  // Get users list
  Future<List<UserModel>> getUsers({
    int page = 1,
    String? search,
    int? companyId,
    String? skills,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
      };

      if (search != null) queryParams['search'] = search;
      if (companyId != null) queryParams['company_id'] = companyId;
      if (skills != null) queryParams['skills'] = skills;

      final response =
          await _apiService.get('/users', queryParameters: queryParams);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Error al cargar usuarios');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Get current user
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiService.get('/profile');

      if (response['success'] == true) {
        return UserModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Error al cargar perfil');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Update profile
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? position,
    String? bio,
    String? linkedinProfile,
    String? website,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (position != null) data['position'] = position;
      if (bio != null) data['bio'] = bio;
      if (linkedinProfile != null) data['linkedin_profile'] = linkedinProfile;
      if (website != null) data['website'] = website;

      final response = await _apiService.put('/profile', data: data);

      if (response['success'] == true) {
        return UserModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Error al actualizar perfil');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
