// Stub notification service - flutter_local_notifications temporarily disabled
class NotificationService {
  static Future<void> initialize() async {
    // Stub implementation - notifications disabled
    print('NotificationService: Notifications disabled (stub implementation)');
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Stub implementation - just print for debugging
    print('NotificationService: Show notification - $title: $body');
  }

  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // Stub implementation - just print for debugging
    print('NotificationService: Schedule reminder - $title at $scheduledTime');
  }

  static Future<void> cancelNotification(int id) async {
    // Stub implementation
    print('NotificationService: Cancel notification $id');
  }

  static Future<void> cancelAllNotifications() async {
    // Stub implementation
    print('NotificationService: Cancel all notifications');
  }
}
