import 'decodable.dart';

///A function that creates an object of type [T]
typedef Create<T> = T Function();

///Construct to get object from generic class
abstract class GenericObject<T> {
  Create<Decodable> create;

  GenericObject({required this.create});

  T genericObject(dynamic data) {
    final item = create();
    return item.decode(data);
  }
}

///Construct to wrap response from API.
///
///Used it as return object of APIController to handle any kind of response.
class ResponseWrapper<T> extends GenericObject<T> {
  T? response;

  ResponseWrapper({required Create<Decodable> create}) : super(create: create);

  factory ResponseWrapper.init(
      {required Create<Decodable> create, required dynamic data}) {
    final wrapper = ResponseWrapper<T>(create: create);
    wrapper.response = wrapper.genericObject(data);
    return wrapper;
  }
}

class APIResponse<T> extends GenericObject<T>
    implements Decodable<APIResponse<T>> {
  String? status;
  T? data;

  APIResponse({required Create<Decodable> create}) : super(create: create);

  @override
  APIResponse<T> decode(dynamic json) {
    data = genericObject(json);
    return this;
  }
}

class APIListResponse<T> extends GenericObject<T>
    implements Decodable<APIListResponse<T>> {
  int? page;
  List<T>? data;
  int? totalPages;
  int? totalResults;

  APIListResponse({required Create<Decodable> create}) : super(create: create);


  @override
  APIListResponse<T> decode(dynamic json) {
    page = json['page'];
    data = [];
    json['results'].forEach((item) {
      data?.add(genericObject(item));
    });
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
    return this;
  }
}

class APIListMovieResponse<T> extends GenericObject<T>
    implements Decodable<APIListMovieResponse<T>> {
  int? page;
  List<T>? data;
  int? totalPages;
  int? totalResults;

  APIListMovieResponse({required Create<Decodable> create}) : super(create: create);


  @override
  APIListMovieResponse<T> decode(dynamic json) {
    page = json['page'];
    data = [];
    json['results'].forEach((item) {
      if(item['media_type'] == 'movie'){
        data?.add(genericObject(item));
      }
    });
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
    return this;
  }
}

class APIListTVResponse<T> extends GenericObject<T>
    implements Decodable<APIListTVResponse<T>> {
  int? page;
  List<T>? data;
  int? totalPages;
  int? totalResults;

  APIListTVResponse({required Create<Decodable> create}) : super(create: create);


  @override
  APIListTVResponse<T> decode(dynamic json) {
    page = json['page'];
    data = [];
    json['results'].forEach((item) {
      if(item['media_type'] == 'tv'){
        data?.add(genericObject(item));
      }
    });
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
    return this;
  }
}

class APIListCredit<T> extends GenericObject<T>
    implements Decodable<APIListCredit<T>> {
  int? id;
  List<T>? cast;
  APIListCredit({required Create<Decodable> create}) : super(create: create);

  @override
  APIListCredit<T> decode(dynamic json) {
    id = json['id'];
    cast = [];
    json['cast'].forEach((item) {
      cast?.add(genericObject(item));
    });
    return this;
  }
}

class APIVideo<T> extends GenericObject <T>
  implements Decodable<APIVideo<T>> {
  int? id;
  T? results;
  APIVideo({required Create<Decodable> create}) : super (create: create);

  @override
  APIVideo<T> decode(dynamic json) {
    id = json['id'];
    for (var e in json['results']) {
      if(e['type'] == 'Trailer') {
        results = genericObject(e);
        break;
      }
    }
    return this;
  }
}

class TokenRequest
    implements Decodable<TokenRequest> {
  bool? status;
  String? requestToken;
  TokenRequest();

  @override
  TokenRequest decode(dynamic json) {
    status = json['success'];
    requestToken = json['request_token'];
    return this;
  }
}

class ErrorResponse implements Exception {
  String? message;

  ErrorResponse({this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(message: json['message'] ?? 'Something went wrong.');
  }

  @override
  String toString() {
    return message ?? 'Failed to convert message to string.';
  }
}