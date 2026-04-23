class UserRequest {
  final String userId;
  final String type;
  final String pageNo;

  UserRequest(this.userId, {this.type = '', this.pageNo = '1'});
}
