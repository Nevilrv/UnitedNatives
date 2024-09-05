class AddChatOnlineStatusReqModel {
  bool? isOnline;
  String? lastSeen;

  AddChatOnlineStatusReqModel({
    this.isOnline,
    this.lastSeen,
  });
  Future<Map<String, dynamic>> toJson() async {
    return {
      'is_online': isOnline,
      'last_seen': lastSeen,
    };
  }
}
