import 'package:dio/dio.dart';

enum APIType { popularMovies, popularTV, trendingDay, trendingWeek, detailTV
  , detailMovie, castTV, castMovie, keywordTV, keywordMovie, recommendTV
  , recommendMovie, trailerTV, trailerMovie, personDetail, searchResult, getToken
  , postLogin, trendingTodayTV, trendingTodayMovie
  , trendingWeekTV, trendingWeekMovie}

class APIRoute implements APIRouteConfigurable {
  final APIType type;
  final String? routeParams;
  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json'
  };
  final Map<String,dynamic>? param;
  final int? id;
  final Map<String,dynamic>? data;

  APIRoute(this.type, {this.routeParams, this.param, this.id, this.data});

  /// Return config of api (method, url, header)
  @override
  RequestOptions? getConfig() {

    switch (type) {

    //homepage
      case APIType.popularMovies:
        return RequestOptions(
            queryParameters: param,
            path: '/movie/popular',
            method: APIMethod.get);

      case APIType.popularTV:
        return RequestOptions(
          path: '/tv/popular',
          queryParameters: param,
          method: APIMethod.get,
        );

      case APIType.trendingDay:
        return RequestOptions(
            path: '/trending/all/day',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.trendingWeek:
        return RequestOptions(
            path: '/trending/all/week',
            queryParameters: param,
            method: APIMethod.get
        );
      //detail page
      case APIType.detailTV:
        return RequestOptions(
            path: '/tv/$id',
            queryParameters: param,
            method: APIMethod.get
        );
      case APIType.detailMovie:
        return RequestOptions(
            path: '/movie/$id',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.castTV:
        return RequestOptions(
            path: '/tv/$id/credits',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.castMovie:
        return RequestOptions(
            path: '/movie/$id/credits',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.keywordTV:
        return RequestOptions(
            path: '/tv/$id/keywords',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.keywordMovie:
        return RequestOptions(
            path: '/movie/$id/keywords',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.recommendTV:
        return RequestOptions(
            path: '/tv/$id/recommendations',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.recommendMovie:
        return RequestOptions(
            path: '/movie/$id/recommendations',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.trailerTV:
        return RequestOptions(
            path: '/tv/$id/videos',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.trailerMovie:
        return RequestOptions(
            path: '/movie/$id/videos',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.personDetail:
        return RequestOptions(
            path: '/person/$id',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.searchResult:
        return RequestOptions(
            path: '/search/multi',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.getToken:
        return RequestOptions(
            path: '/authentication/token/new',
            queryParameters: param,
            method: APIMethod.get
        );

      case APIType.postLogin:
        return RequestOptions(
            path: '/authentication/token/validate_with_login',
            queryParameters: param,
            method: APIMethod.post,
            data: data
        );
      case APIType.trendingTodayTV:
        return RequestOptions(
            path: '/trending/tv/day',
            queryParameters: param,
            method: APIMethod.get
        );
      case APIType.trendingTodayMovie:
        return RequestOptions(
            path: '/trending/movie/day',
            queryParameters: param,
            method: APIMethod.get
        );
      case APIType.trendingWeekTV:
        return RequestOptions(
            path: '/trending/tv/week',
            queryParameters: param,
            method: APIMethod.get
        );
      case APIType.trendingWeekMovie:
        return RequestOptions(
            path: '/trending/movie/week',
            queryParameters: param,
            method: APIMethod.get
        );
      default:
        return null;
    }
  }
}

// ignore: one_member_abstracts
abstract class APIRouteConfigurable {
  RequestOptions? getConfig();
}

class APIMethod {
  static const get = 'GET';
  static const post = 'POST';
}