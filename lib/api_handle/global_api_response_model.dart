class ApiResponse<T> {
  bool? status;
  String? message;
  Data<T>? data;

  ApiResponse({this.status, this.message, this.data});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return ApiResponse<T>(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? Data<T>.fromJson(json['data'], fromJsonT)
          : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'status': status,
      'message': message,
      if (data != null) 'data': data!.toJson(toJsonT),
    };
  }
}

class Data<T> {
  int? currentPage;
  List<T>? data;
  int? to;
  int? total;

  Data({this.currentPage, this.data, this.to, this.total});

  factory Data.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return Data<T>(
      currentPage: json['current_page'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) => {
    'current_page': currentPage,
    'data': data?.map((e) => toJsonT(e)).toList(),
    'to': to,
    'total': total,
  };
}
