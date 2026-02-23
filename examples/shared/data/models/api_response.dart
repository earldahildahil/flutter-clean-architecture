class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  const ApiResponse({
    required this.success,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) =>
      ApiResponse(
        success: json['success'] as bool,
        data: json['data'] != null
            ? fromJsonT(json['data'] as Map<String, dynamic>)
            : null,
        error: json['error'] as String?,
      );
}
