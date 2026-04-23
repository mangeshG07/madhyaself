class OtherUserRequest {
  final String userId;
  final String otherUserId;
  final String reason;

  OtherUserRequest(this.userId, this.otherUserId, {this.reason = ''});
}
