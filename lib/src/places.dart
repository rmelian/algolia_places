import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'core.dart';
import 'utils.dart';

class AlgoliaPlaces extends AlgoliaPlacesWebService {
  AlgoliaPlaces({
    String apiKey,
    Client httpClient,
  }) : super(apiKey: apiKey, httpClient: httpClient);

  Future<PlacesAutocompleteResponse> autocomplete(
    String input, {
    String type,
    int hitsPerPage,
    String language,
    List<String> countries,
    String aroundLatLng,
    bool aroundLatLngViaIP,
    int aroundRadius,
    bool getRankingInfo,
  }) async {
    final query = Query(
      input,
      type: type,
      hitsPerPage: hitsPerPage,
      language: language,
      countries: countries,
      aroundLatLng: aroundLatLng,
      aroundLatLngViaIP: aroundLatLngViaIP,
      aroundRadius: aroundRadius,
      getRankingInfo: getRankingInfo,
    );
    return _decodeAutocompleteResponse(await doPost(json.encode(query)));
  }

  PlacesAutocompleteResponse _decodeAutocompleteResponse(Response res) =>
      PlacesAutocompleteResponse.fromJson(json.decode(res.body));
}

class PlacesAutocompleteResponse extends GoogleResponseStatus {
  final List<Hit> hits;
  final int nbHits;
  final int processingTimeMS;
  final String query;
  final String params;
  final bool degradedQuery;

  PlacesAutocompleteResponse(
    this.hits,
    this.nbHits,
    this.processingTimeMS,
    this.query,
    this.params,
    this.degradedQuery,
    int status,
    String errorMessage,
  ) : super(
          status,
          errorMessage,
        );

  factory PlacesAutocompleteResponse.fromJson(Map json) => json != null
      ? PlacesAutocompleteResponse(
          json['hits']
              ?.map((dynamic p) => Hit.fromJson(p))
              ?.toList()
              ?.cast<Hit>(),
          json['nbHits'],
          json['processingTimeMS'],
          json['query'],
          json['params'],
          json['degradedQuery'],
          json['status'],
          json['errorMessage'],
        )
      : null;

  @override
  String toString() {
    if (super.isInvalid) {
      return 'status: ${super.status}, errorMessage: ${super.errorMessage}';
    }
    return 'PlacesAutocompleteResponse{hits: $hits, nbHits: $nbHits, processingTimeMS: $processingTimeMS, query: $query, params: $params, degradedQuery: $degradedQuery }';
  }
}

class Suggestion {
  Suggestion(this.hit);

  final Hit hit;

  String get name => hit.localeNames[0];
  String get country => hit.country;
  String get administrative =>
      (hit.administrative != null && hit.administrative[0] != name)
          ? hit.administrative[0]
          : null;
  String get city =>
      (hit.city != null && hit.city[0] != name) ? hit.city[0] : null;
  String get suburb =>
      (hit.suburb != null && hit.suburb[0] != name) ? hit.suburb[0] : null;
  String get county =>
      (hit.county != null && hit.county[0] != name) ? hit.county[0] : null;

  String get description => name;

  @override
  String toString() {
    return 'Suggestion{hit: $hit}';
  }

//  const { postcode, highlightedPostcode } =
//hit.postcode && hit.postcode.length
//? getBestPostcode(hit.postcode, hit._highlightResult.postcode)
//    : { postcode: undefined, highlightedPostcode: undefined };

}

class Hit {
  Hit({
    this.country,
    this.isCountry,
    this.isHighway,
    this.importance,
    this.tags,
    this.postcode,
    this.county,
    this.population,
    this.countryCode,
    this.isCity,
    this.isPopular,
    this.administrative,
    this.suburb,
    this.city,
    this.adminLevel,
    this.isSuburb,
    this.localeNames,
    this.geoloc,
    this.objectID,
    this.highlightResult,
  });

  final String country;
  final bool isCountry;
  final bool isHighway;
  final int importance;
  final List<String> tags;
  final List<String> postcode;
  final List<String> county;
  final int population;
  final String countryCode;
  final bool isCity;
  final bool isPopular;
  final List<String> administrative;
  final List<String> city;
  final List<String> suburb;
  final int adminLevel;
  final bool isSuburb;
  final List<String> localeNames;
  final GeoLocation geoloc;
  final String objectID;
  final HighlightResult highlightResult;

  Suggestion get suggestion => Suggestion(this);

  factory Hit.fromJson(Map<String, dynamic> json) => json != null
      ? Hit(
          country: json['country'],
          isCountry: json['isCountry'],
          isHighway: json['isHighway'],
          importance: json['importance'],
          tags: (json['_tags'])?.cast<String>(),
          postcode: (json['postcode'])?.cast<String>(),
          county: (json['county'])?.cast<String>(),
          population: json['population'],
          countryCode: json['country_code'],
          isCity: json['is_city'],
          isPopular: json['is_popular'],
          administrative: (json['administrative'])?.cast<String>(),
          city: (json['city'])?.cast<String>(),
          suburb: (json['suburb'])?.cast<String>(),
          adminLevel: json['admin_level'],
          isSuburb: json['is_suburb'],
          localeNames: (json['locale_names'])?.cast<String>(),
          geoloc: GeoLocation.fromJson(json['_geoloc']),
          objectID: json['objectID'],
          highlightResult: HighlightResult.fromJson(json['_highlightResult']),
        )
      : null;

  @override
  String toString() {
    return 'Hit{highlightResult: $highlightResult}';
  }
}

class HighlightResult {
  HighlightResult({
    this.country,
    this.postcode,
    this.county,
    this.administrative,
    this.localeNames,
  });

  final Highlight country;
  final List<Highlight> postcode;
  final List<Highlight> county;
  final List<Highlight> administrative;
  final List<Highlight> localeNames;

  factory HighlightResult.fromJson(Map<String, dynamic> json) => json != null
      ? HighlightResult(
          country: Highlight.fromJson(json['country']),
          postcode: json['postcode']
              ?.map((dynamic p) => Highlight.fromJson(p))
              ?.toList()
              ?.cast<Highlight>(),
          county: json['county']
              ?.map((dynamic p) => Highlight.fromJson(p))
              ?.toList()
              ?.cast<Highlight>(),
          administrative: json['administrative']
              ?.map((dynamic p) => Highlight.fromJson(p))
              ?.toList()
              ?.cast<Highlight>(),
          localeNames: json['locale_names']
              ?.map((dynamic p) => Highlight.fromJson(p))
              ?.toList()
              ?.cast<Highlight>(),
        )
      : null;

  @override
  String toString() {
    return 'HighlightResult{country: $country, postcode: $postcode, county: $county, administrative: $administrative, localeNames: $localeNames}';
  }
}

class Highlight {
  Highlight(
      {this.value, this.matchLevel, this.matchedWords, this.fullyHighlighted});

  final String value;
  final String matchLevel;
  final List<String> matchedWords;
  final bool fullyHighlighted;

  factory Highlight.fromJson(Map<String, dynamic> json) => json != null
      ? Highlight(
          value: json['value'],
          matchLevel: json['matchLevel'],
          fullyHighlighted: json['fullyHighlighted'],
          matchedWords: (json['matchedWords'])?.cast<String>(),
        )
      : null;

  @override
  String toString() {
    return 'Highlight{value: $value, matchLevel: $matchLevel, matchedWords: $matchedWords, fullyHighlighted: $fullyHighlighted}';
  }
}

class Query {
  Query(
    this.query, {
    this.type,
    this.hitsPerPage: 20,
    this.language,
    this.countries,
    this.aroundLatLng,
    this.aroundLatLngViaIP: true,
    this.aroundRadius,
    this.getRankingInfo: false,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'query': query,
      if (type != null)
        'type': type,
      if (hitsPerPage != null)
        'hitsPerPage': hitsPerPage,
      if (language != null)
        'language': language,
//      if (countries?.isNotEmpty) 'countries': countries,
      if (aroundLatLng != null)
        'aroundLatLng': aroundLatLng,
      if (aroundLatLngViaIP != null)
        'aroundLatLngViaIP': aroundLatLngViaIP,
      if (aroundRadius != null)
        'aroundRadius': aroundRadius,
      if (aroundRadius != null)
        'getRankingInfo': getRankingInfo,
    };
  }

  final String query;
  final String type;
  final int hitsPerPage;
  final String language;
  final List<String> countries;
  final String aroundLatLng;
  final bool aroundLatLngViaIP;
  final int aroundRadius;
  final bool getRankingInfo;

  @override
  String toString() {
    return 'Query{query: $query, language: $language}';
  }
}

//class Prediction {
//  final String description;
//  final String id;
//  final List<Term> terms;
//
//  /// JSON place_id
//  final String placeId;
//  final String reference;
//  final List<String> types;
//
//  /// JSON matched_substrings
//  final List<MatchedSubstring> matchedSubstrings;
//
//  final StructuredFormatting structuredFormatting;
//
//  Prediction(
//      this.description,
//      this.id,
//      this.terms,
//      this.placeId,
//      this.reference,
//      this.types,
//      this.matchedSubstrings,
//      this.structuredFormatting);
//
//  factory Prediction.fromJson(Map json) => json != null
//      ? Prediction(
//          json['description'],
//          json['id'],
//          json['terms']?.map((t) => Term.fromJson(t))?.toList()?.cast<Term>(),
//          json['place_id'],
//          json['reference'],
//          (json['types'] as List)?.cast<String>(),
//          json['matched_substrings']
//              ?.map((m) => MatchedSubstring.fromJson(m))
//              ?.toList()
//              ?.cast<MatchedSubstring>(),
//          StructuredFormatting.fromJson(json['structured_formatting']),
//        )
//      : null;
//}

//class Term {
//  final num offset;
//  final String value;
//
//  Term(this.offset, this.value);
//
//  factory Term.fromJson(Map json) =>
//      json != null ? Term(json['offset'], json['value']) : null;
//}
//
//class MatchedSubstring {
//  final num offset;
//  final num length;
//
//  MatchedSubstring(this.offset, this.length);
//
//  factory MatchedSubstring.fromJson(Map json) =>
//      json != null ? MatchedSubstring(json['offset'], json['length']) : null;
//}
//
//class StructuredFormatting {
//  final String mainText;
//  final List<MatchedSubstring> mainTextMatchedSubstrings;
//  final String secondaryText;
//
//  StructuredFormatting(
//    this.mainText,
//    this.mainTextMatchedSubstrings,
//    this.secondaryText,
//  );
//
//  factory StructuredFormatting.fromJson(Map json) => json != null
//      ? StructuredFormatting(
//          json['main_text'],
//          json['main_text_matched_substrings']
//              ?.map((m) => MatchedSubstring.fromJson(m))
//              ?.toList()
//              ?.cast<MatchedSubstring>(),
//          json['secondary_text'])
//      : null;
//}
