import 'package:algolia_places/places.dart';

void main() async {
  final aPlces = AlgoliaPlaces();
  final PlacesAutocompleteResponse result = await aPlces.autocomplete(
    "Miami",
    language: 'en',
    hitsPerPage: 5,
  );
  result.hits.forEach((Hit hit) => print(hit.suggestion.toString()));
//
}
