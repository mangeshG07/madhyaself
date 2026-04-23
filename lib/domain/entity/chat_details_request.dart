class ChatDetailsRequest {
  final String userId;
  final String conversationId;
  final String nextCursor;

  ChatDetailsRequest(this.userId, this.conversationId, {this.nextCursor = ''});
}
