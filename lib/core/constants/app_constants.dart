class AppConstants {
  // App Info
  static const String appName = 'Business Network';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Image Sizes
  static const int avatarSize = 150;
  static const int companyLogoSize = 200;
  static const int maxImageSize = 2048; // 2MB

  // Validation
  static const int minPasswordLength = 8;
  static const int maxBioLength = 1000;
  static const int maxDescriptionLength = 2000;

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Colors (Modern Green Theme)
  static const int primaryColorValue = 0xFF2D5A27; // Verde oscuro profesional
  static const int secondaryColorValue = 0xFF4A7C59; // Verde medio
  static const int accentColorValue = 0xFF7FB069; // Verde claro

  // Background Colors
  static const int backgroundColorValue = 0xFFF8FAF6; // Fondo muy suave
  static const int surfaceColorValue = 0xFFFFFFFF;
  static const int cardColorValue = 0xFFF5F7F3; // Fondo de tarjetas suave

  // Text Colors
  static const int textPrimaryValue = 0xFF1A1A1A;
  static const int textSecondaryValue = 0xFF757575;
  static const int textLightValue = 0xFF9E9E9E;

  // Design Constants
  static const double borderRadius = 16.0;
  static const double cardElevation = 2.0;
  static const double spacing = 16.0;

  // Additional Colors
  static const int successColorValue = 0xFF4CAF50;
  static const int warningColorValue = 0xFFFF9800;
  static const int errorColorValue = 0xFFE57373;
  static const int infoColorValue = 0xFF64B5F6;

  // Priority Colors
  static const int lowPriorityColor = 0xFF4CAF50; // Green
  static const int mediumPriorityColor = 0xFFFF9800; // Orange
  static const int highPriorityColor = 0xFFFF5722; // Deep Orange
  static const int urgentPriorityColor = 0xFFD32F2F; // Red

  // Interest Level Colors
  static const int veryLowInterest = 0xFFFF5252; // Red
  static const int lowInterest = 0xFFFF9800; // Orange
  static const int mediumInterest = 0xFFFFEB3B; // Yellow
  static const int highInterest = 0xFF8BC34A; // Light Green
  static const int veryHighInterest = 0xFF4CAF50; // Green

  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // Debounce
  static const int searchDebounceMs = 500;

  // Refresh
  static const int refreshThresholdMs = 300000; // 5 minutos
}
