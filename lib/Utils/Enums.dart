import 'package:flutter/material.dart';

enum TrendingSCategoryFor {
  artists('Artists'),
  genres( 'Genres'),
  radio( 'Radio'),
  tracks( 'Tracks'),
  mixes('Mixes'),
  albums('Albums'),
  playList('Playlists');

  final String value;

   const TrendingSCategoryFor(this.value);
}
