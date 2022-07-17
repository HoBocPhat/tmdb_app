import 'package:tmdb_app/api/api_client.dart';
import 'package:tmdb_app/model/TV.dart';

import 'package:tmdb_app/model/keyword_response.dart';

import 'package:tmdb_app/model/movie_demo.dart';
import 'package:tmdb_app/model/movie_detail_response.dart';

import 'package:tmdb_app/model/person_response.dart';

import 'package:tmdb_app/model/tv_detail_response.dart';
import 'package:tmdb_app/model/video_response.dart';
import 'package:tmdb_app/model/search_response.dart';

import 'package:tmdb_app/src/url.dart';

import '../api/api_response.dart';
import '../api/api_route.dart';
import '../model/cast.dart';
import '../model/trending_response.dart';

class ApiRepository {
  final APIClient client;

  ApiRepository(this.client);

  Future<List<MovieDetailResponse>> fetchMoviePopular() async {
    Map<String,dynamic> param = {
      "page": "1",
      "api_key" : apiKey
    };
    final result = await client.request(
        route: APIRoute(APIType.popularMovies, param: param),
        create: () => APIListResponse<MovieDetailResponse>(create:() => MovieDetailResponse()));

    final movie = result.response?.data;

    if (movie != null) {
      return movie;
    }

    throw ErrorResponse(message: 'Movie not found');

  }

  Future<List<TVDetailResponse>> fetchTVPopular() async {
    Map<String,dynamic> param = {
      "page": "1",
      "api_key" : apiKey
    };
    final result = await client.request(
        route: APIRoute(APIType.popularTV, param: param),
        create: () => APIListResponse<TVDetailResponse>(create:() => TVDetailResponse()));

    final tv = result.response?.data;

    if (tv != null) {
      return tv;
    }

    throw ErrorResponse(message: 'Movie not found');

  }

  Future<TVDetailResponse> fetchDetailTV(int id) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey
    };
    final result = await client.request(
        route: APIRoute(APIType.detailTV, param: param, id: id),
        create: () => APIResponse<TVDetailResponse>(create:() => TVDetailResponse()));
    final tv = result.response?.data;
    if(tv != null){
      return tv;
    }
    throw ErrorResponse(message: 'Detail tv not found');
  }

  Future<MovieDetailResponse> fetchDetailMovie(int id) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey
    };
    final result = await client.request(
        route: APIRoute(APIType.detailMovie, param: param, id: id),
        create: () => APIResponse<MovieDetailResponse>(create:() => MovieDetailResponse()));
    final movie = result.response?.data;
    if(movie != null){
      return movie;
    }
    throw ErrorResponse(message: 'Detail movie not found');
  }

  Future<List<Cast>> fetchCast(int id, APIType apiType) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey
    };
    final result = await client.request(
        route: APIRoute(apiType, param: param, id: id),
        create: () => APIListCredit<Cast>(create:() => Cast()));
    final cast = result.response?.cast;
    if(cast != null){
      return cast;
    }
    throw ErrorResponse(message: 'Cast not found');
  }

  Future<TVKeyword> fetchKeywordTV(int id) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey
    };
    final result = await client.request(
        route: APIRoute(APIType.keywordTV, param: param, id: id),
        create: () => APIResponse<TVKeyword>(create:() => TVKeyword()));
    final keyword = result.response?.data;
    if(keyword != null){
      return keyword;
    }
    throw ErrorResponse(message: 'Keyword not found');
  }

  Future<MovieKeyword> fetchKeywordMovie(int id) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey
    };
    final result = await client.request(
        route: APIRoute(APIType.keywordMovie, param: param, id: id),
        create: () => APIResponse<MovieKeyword>(create:() => MovieKeyword()));
    final keyword = result.response?.data;
    if(keyword != null){
      return keyword;
    }
    throw ErrorResponse(message: 'Keyword not found');
  }

  Future<List<TV>> fetchRecommendTV(int id) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey
    };
    final result = await client.request(
        route: APIRoute(APIType.recommendTV, param: param, id: id),
        create: () => APIListResponse<TV>(create:() => TV()));
    final tv = result.response?.data;
    if(tv != null){
      return tv;
    }
    throw ErrorResponse(message: 'TV not found');
  }

  Future<List<MovieDemo>> fetchRecommendMovie(int id) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey
    };
    final result = await client.request(
        route: APIRoute(APIType.recommendMovie, param: param, id: id),
        create: () => APIListResponse<MovieDemo>(create:() => MovieDemo()));
    final movie = result.response?.data;
    if(movie != null){
      return movie;
    }
    throw ErrorResponse(message: 'Movie not found');
  }

  Future<Video> fetchTrailer(int id, APIType apiType) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey
    };
    final result = await client.request(
        route: APIRoute(apiType, param: param, id: id),
        create: () => APIVideo<Video>(create:() => Video()));
    final video = result.response?.results;
    if(video != null){
      return video;
    }
    throw ErrorResponse(message: 'Video not found');
  }

  Future<PersonResponse> fetchPersonDetail(int id) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey
    };
    final result = await client.request(
        route: APIRoute(APIType.personDetail, param: param, id: id),
        create: () => APIResponse<PersonResponse>(create:() => PersonResponse()));
    final person = result.response?.data;
    if(person != null){
      return person;
    }
    throw ErrorResponse(message: 'Person not found');
  }

  Future<List<SearchResponse>> fetchSearchResult(String query, {String? page}) async {
    Map<String,dynamic> param = {
      "query": query,
      "api_key" : apiKey,
      "page" : page
    };
    final result = await client.request(
        route: APIRoute(APIType.searchResult, param: param),
        create: () => APIListResponse<SearchResponse>(create:() => SearchResponse()));
    final search = result.response?.data;
    if(search != null){
      return search;
    }
    throw ErrorResponse(message: 'Search not found');
  }

  Future<List<TVDetailResponse>> fetchMoreTV(String page) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey,
      "page" : page
    };
    final result = await client.request(
        route: APIRoute(APIType.popularTV, param: param),
        create: () => APIListResponse<TVDetailResponse>(create:() => TVDetailResponse()));
    final tv = result.response?.data;
    if(tv != null){
      return tv;
    }
    throw ErrorResponse(message: 'Can get more TV');
  }

  Future<List<MovieDetailResponse>> fetchMoreMovie(String page) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey,
      "page" : page
    };
    final result = await client.request(
        route: APIRoute(APIType.popularMovies, param: param),
        create: () => APIListResponse<MovieDetailResponse>(create:() => MovieDetailResponse()
        ));
    final movie = result.response?.data;
    if(movie != null){
      return movie;
    }
    throw ErrorResponse(message: 'Can get more movie');
  }

  Future<List<SearchResponse>> fetchMoreSearch(String page) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey,
      "page" : page
    };
    final result = await client.request(
        route: APIRoute(APIType.searchResult, param: param),
        create: () => APIListResponse<SearchResponse>(create:() => SearchResponse()
        ));
    final search = result.response?.data;
    if(search != null){
      return search;
    }
    throw ErrorResponse(message: 'Can get more movie');
  }

  Future<List<TrendingResponse>> fetchTrendingDay() async {
    Map<String,dynamic> param = {
      "api_key" : apiKey,
      "page" : "1"
    };
    final result = await client.request(
        route: APIRoute(APIType.trendingDay, param: param),
        create: () => APIListResponse<TrendingResponse>(create:() => TrendingResponse()
        ));
    final trending = result.response?.data;
    if(trending != null){
      return trending;
    }
    throw ErrorResponse(message: 'Can get trending day');
  }

  Future<List<TrendingResponse>> fetchTrendingWeek() async {
    Map<String,dynamic> param = {
      "api_key" : apiKey,
      "page" : "1"
    };
    final result = await client.request(
        route: APIRoute(APIType.trendingWeek, param: param),
        create: () => APIListResponse<TrendingResponse>(create:() => TrendingResponse()
        ));
    final trending = result.response?.data;
    if(trending != null){
      return trending;
    }
    throw ErrorResponse(message: 'Can get trending day');
  }

  Future<List<TVDetailResponse>> fetchTrendingTodayTV() async {
    Map<String,dynamic> param = {
      "api_key" : apiKey,
      "page" : "1"
    };
    final result = await client.request(
        route: APIRoute(APIType.trendingTodayTV, param: param),
        create: () => APIListResponse<TVDetailResponse>(create:() => TVDetailResponse()
        ));
    final trending = result.response?.data;
    if(trending != null){
      return trending;
    }
    throw ErrorResponse(message: 'Can get trending today tv');
  }

  Future<List<MovieDetailResponse>> fetchTrendingTodayMovie() async {
    Map<String,dynamic> param = {
      "api_key" : apiKey,
      "page" : "1"
    };
    final result = await client.request(
        route: APIRoute(APIType.trendingTodayMovie, param: param),
        create: () => APIListResponse<MovieDetailResponse>(create:() => MovieDetailResponse()
        ));
    final trending = result.response?.data;
    if(trending != null){
      return trending;
    }
    throw ErrorResponse(message: 'Can get trending today movie');
  }

  Future<List<TVDetailResponse>> fetchTrendingWeekTV() async {
    Map<String,dynamic> param = {
      "api_key" : apiKey,
      "page" : "1"
    };
    final result = await client.request(
        route: APIRoute(APIType.trendingWeekTV, param: param),
        create: () => APIListResponse<TVDetailResponse>(create:() => TVDetailResponse()
        ));
    final trending = result.response?.data;
    if(trending != null){
      return trending;
    }
    throw ErrorResponse(message: 'Can get trending week tv');
  }

  Future<List<MovieDetailResponse>> fetchTrendingWeekMovie() async {
    Map<String,dynamic> param = {
      "api_key" : apiKey,
      "page" : "1"
    };
    final result = await client.request(
        route: APIRoute(APIType.trendingWeekMovie, param: param),
        create: () => APIListResponse<MovieDetailResponse>(create:() => MovieDetailResponse()
        ));
    final trending = result.response?.data;
    if(trending != null){
      return trending;
    }
    throw ErrorResponse(message: 'Can get trending week movie');
  }

}
