class ApiUrls {
  ApiUrls._();

  // Base URLs
  static const String baseUrl = 'https://study-abroad-cemc-admin.vercel.app';
  static const String adminUrl = 'https://admin-cemc-co.vercel.app';
  static const String apiBaseUrl = '$baseUrl/api';
  static const String adminApiUrl = '$adminUrl/api';

  // Auth APIs
  static const String login = '$apiBaseUrl/auth/login';
  static const String register = '$apiBaseUrl/auth/register';
  static const String emailVerification = '$apiBaseUrl/auth/new-verification';
  static const String resetPassword = '$apiBaseUrl/auth/reset-password';
  static const String newPassword = '$apiBaseUrl/auth/new-password';
  static const String deleteAccount = '$apiBaseUrl/auth/delete';
  static const String authSchools = '$apiBaseUrl/auth/schools';

  // Schools APIs
  static const String schools = '$apiBaseUrl/schools';
  static const String schoolsFull = '$apiBaseUrl/schools/full';
  static const String nameSchools = '$apiBaseUrl/nameSchools';
  static String schoolById(String schoolId) => '$apiBaseUrl/schools/$schoolId';
  static String schoolScholarships(String schoolId, String scholarshipId) =>
      '$apiBaseUrl/schools/$schoolId/scholarships/$scholarshipId';

  // Account APIs
  static String accountById(String accountId) => '$apiBaseUrl/accounts/$accountId';
  static String studentRequirements(String accountId, String requirementId) =>
      '$apiBaseUrl/accounts/students/$accountId/requirements/$requirementId';

  // Profile APIs
  static String profileById(String profileId) => '$apiBaseUrl/profile/$profileId';
  static const String profileBio = '$apiBaseUrl/profile/Bio';

  // News APIs
  static const String news = '$apiBaseUrl/news';
  static String newsById(String newsId) => '$apiBaseUrl/news/$newsId';

  // Feedback APIs
  static const String feedbacks = '$apiBaseUrl/feedbacks';

  // Notification APIs
  static String notifications(String accountId) => '$apiBaseUrl/notifications/$accountId';
  static const String notificationToken = '$adminApiUrl/notifications';

  // Chat Support APIs
  static const String chatSession = '$adminApiUrl/chat-session';
  static String chatSessionByClientAndAccount(String clientId, String accountId) =>
      '$adminApiUrl/chat-session/$clientId/$accountId';

  // Message APIs
  static const String messageChat = '$apiBaseUrl/message/chat';
  static const String messagePrivate = '$apiBaseUrl/message/private';
  static const String messageGroup = '$apiBaseUrl/message/group';
  static const String messageSchool = '$apiBaseUrl/message/school';
  static const String messageStudent = '$apiBaseUrl/message/student';

  // Country APIs
  static const String countries = '$apiBaseUrl/country';

  // Seed APIs (Development)
  static const String seed = '$apiBaseUrl/seed';
  static const String seedChat = '$apiBaseUrl/seed-chat';
}
