class UserRequest {
  final String userId;
  final String type;
  final String pageNo;
  final String view;

  UserRequest(this.userId, {this.type = '', this.pageNo = '1', this.view = ''});
}
