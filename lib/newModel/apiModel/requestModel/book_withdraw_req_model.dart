class BookWithdrawReqModel {
  String action;

  BookWithdrawReqModel({
    this.action,
  });
  Map<String, dynamic> toJson() {
    return {
      'action': action,
    };
  }
}
