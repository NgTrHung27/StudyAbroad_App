class ApplyScholarModel {
  final String? success;
  final String? error;

  ApplyScholarModel({this.success, this.error});

  factory ApplyScholarModel.fromJson(Map<String, dynamic> json) {
    return ApplyScholarModel(
      success: json['success']?.toString(),
      error: json['error']?.toString() ?? json['message']?.toString(),
    );
  }
}
