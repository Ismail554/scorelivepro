/// Utility for sanitizing sports-related text to remove trademarked
/// organization names (e.g. FIFA, UEFA, AFC, CAF, CONMEBOL, CONCACAF, OFC)
/// from display strings while keeping the meaningful part intact.
///
/// This ensures compliance with Apple App Store Guideline 5.2.1.
class StringSanitizer {
  StringSanitizer._();

  /// Map of trademarked prefixes to their safe replacements.
  /// Order matters: longer/more-specific patterns first to avoid partial matches.
  static const _replacements = <String, String>{
    // Full branded tournament names → generic equivalents
    'FIFA World Cup': 'International World Cup',
    'FIFA Club World Cup': 'International Club World Cup',
    'FIFA U-20 World Cup': 'International U-20 World Cup',
    'FIFA U-17 World Cup': 'International U-17 World Cup',
    'FIFA Women\'s World Cup': 'International Women\'s World Cup',
    'FIFA Friendlies': 'International Friendlies',
    'FIFA Arab Cup': 'Arab Cup',

    // Standalone org name prefixes
    'FIFA ': '',
    'UEFA ': 'UeFa ',
    'AFC ': 'AfC ',
    'CAF ': 'cAf ',
    'CONMEBOL ': 'conmebol ',
    'CONCACAF ': 'concacaf ',
    'OFC ': 'ofc ',
  };

  /// Removes trademarked organization names from [text].
  ///
  /// Returns the original string if null/empty, otherwise a sanitized copy.
  /// Example: "FIFA World Cup" → "World Cup"
  static String? sanitize(String? text) {
    if (text == null || text.isEmpty) return text;

    String result = text;

    for (final entry in _replacements.entries) {
      // Case-insensitive replacement
      result = result.replaceAll(
        RegExp(RegExp.escape(entry.key), caseSensitive: false),
        entry.value,
      );
    }

    // Clean up any double spaces left by removals and trim
    result = result.replaceAll(RegExp(r'\s{2,}'), ' ').trim();

    return result;
  }
}
