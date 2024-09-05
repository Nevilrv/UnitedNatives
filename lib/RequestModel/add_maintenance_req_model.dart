class AddMaintenanceModel {
  String? state;

  AddMaintenanceModel({
    this.state,
  });
  Future<Map<String, dynamic>> toJson() async {
    return {
      'action': 'maintenance',
      'state': state,
    };
  }
}
