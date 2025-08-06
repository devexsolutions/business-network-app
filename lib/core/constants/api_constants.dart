class ApiConstants {
  // Base URL - Cambiar según tu configuración
  static const String baseUrl = 'http://localhost:8000/api';

  // Endpoints de autenticación
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Endpoints de usuarios
  static const String users = '/users';
  static const String userSuggestions = '/users/suggestions';

  // Endpoints de perfil
  static const String profile = '/profile';
  static const String profileBasic = '/profile/basic';
  static const String profileProfessional = '/profile/professional';
  static const String profileTax = '/profile/tax';
  static const String profileAvatar = '/profile/avatar';
  static const String profileStats = '/profile/stats';
  static const String profileSearch = '/profile/search';

  // Endpoints de empresas
  static const String companies = '/companies';

  // Endpoints de posts
  static const String posts = '/posts';

  // Endpoints de conexiones
  static const String connections = '/connections';
  static const String connectionsPending = '/connections/pending';
  static const String connectionsSent = '/connections/sent';

  // Endpoints de eventos
  static const String events = '/events';

  // Endpoints de reuniones 1 a 1
  static const String meetings = '/meetings';
  static const String meetingsStats = '/meetings/stats';

  // Endpoints de recomendaciones
  static const String recommendations = '/recommendations';
  static const String recommendationsStats = '/recommendations/stats';
  static const String recommendationsNetwork = '/recommendations/network';

  // Endpoints de seguimiento uno a uno
  static const String followUps = '/follow-ups';
  static const String followUpsStats = '/follow-ups/stats';
  static const String followUpsUpcoming = '/follow-ups/upcoming';
  static const String followUpsOpportunities = '/follow-ups/opportunities';

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';

  // Timeouts
  static const int connectTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000; // 30 segundos
  static const int sendTimeout = 30000; // 30 segundos
}
