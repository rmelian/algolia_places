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
    String sessionToken,
    num offset,
    GeoLocation location,
    num radius,
    String language,
    List<String> types,
    List<Component> components,
    bool strictbounds,
  }) async {
    final query = Query(input, language: "en");
    return _decodeAutocompleteResponse(await doPost(json.encode(query)));
  }

  PlacesAutocompleteResponse _decodeAutocompleteResponse(Response res) =>
      PlacesAutocompleteResponse.fromJson(json.decode(res.body));
}

//class PlacesSearchResponse extends GoogleResponseList<PlacesSearchResult> {
//  /// JSON html_attributions
//  final List<String> htmlAttributions;
//
//  /// JSON next_page_token
//  final String nextPageToken;
//
//  PlacesSearchResponse(
//    String status,
//    String errorMessage,
//    List<PlacesSearchResult> results,
//    this.htmlAttributions,
//    this.nextPageToken,
//  ) : super(
//          status,
//          errorMessage,
//          results,
//        );
//
//  factory PlacesSearchResponse.fromJson(Map json) => json != null
//      ? PlacesSearchResponse(
//          json['status'],
//          json['error_message'],
//          json['results']
//              .map((r) => PlacesSearchResult.fromJson(r))
//              .toList()
//              .cast<PlacesSearchResult>(),
//          (json['html_attributions'] as List).cast<String>(),
//          json['next_page_token'])
//      : null;
//}
//
//class PlacesSearchResult {
//  final String icon;
//  final Geometry geometry;
//  final String name;
//
//  /// JSON opening_hours
//  final OpeningHours openingHours;
//
//  final List<Photo> photos;
//
//  /// JSON place_id
//  final String placeId;
//
//  final String scope;
//
//  /// JSON alt_ids
//  final List<AlternativeId> altIds;
//
//  /// JSON price_level
//  final PriceLevel priceLevel;
//
//  final num rating;
//
//  final List<String> types;
//
//  final String vicinity;
//
//  /// JSON formatted_address
//  final String formattedAddress;
//
//  /// JSON permanently_closed
//  final bool permanentlyClosed;
//
//  final String id;
//
//  final String reference;
//
//  PlacesSearchResult(
//    this.icon,
//    this.geometry,
//    this.name,
//    this.openingHours,
//    this.photos,
//    this.placeId,
//    this.scope,
//    this.altIds,
//    this.priceLevel,
//    this.rating,
//    this.types,
//    this.vicinity,
//    this.formattedAddress,
//    this.permanentlyClosed,
//    this.id,
//    this.reference,
//  );
//
//  factory PlacesSearchResult.fromJson(Map json) => json != null
//      ? PlacesSearchResult(
//          json['icon'],
//          Geometry.fromJson(json['geometry']),
//          json['name'],
//          null,
//          json['photos']
//              ?.map((p) => Photo.fromJson(p))
//              ?.toList()
//              ?.cast<Photo>(),
//          json['place_id'],
//          json['scope'],
//          json['alt_ids']
//              ?.map((a) => AlternativeId.fromJson(a))
//              ?.toList()
//              ?.cast<AlternativeId>(),
//          json['price_level'] != null
//              ? PriceLevel.values.elementAt(json['price_level'])
//              : null,
//          json['rating'],
//          (json['types'] as List)?.cast<String>(),
//          json['vicinity'],
//          json['formatted_address'],
//          json['permanently_closed'],
//          json['id'],
//          json['reference'])
//      : null;
//}

class PlacesAutocompleteResponse extends GoogleResponseStatus {
//  final List<Prediction> predictions;

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
  Query(this.query, {this.language});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'query': query,
      if (language != null) 'language': language,
    };
  }

  final String query;
  final String language;

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
