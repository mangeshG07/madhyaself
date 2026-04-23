import '../../core/exporters/app_export.dart';

class SendMessageRequest {
  final String userId;
  final String conversationId;
  final String message;
  final List<MultipartFile>? photos;

  SendMessageRequest(
    this.userId,
    this.conversationId,
    this.message,
    this.photos,
  );
}
