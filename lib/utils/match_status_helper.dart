import 'package:scorelivepro/widget/home/match_card.dart';

class MatchStatusHelper {
  static MatchStatus getMatchStatus(String? shortStatus) {
    if (shortStatus == null) return MatchStatus.upcoming;

    switch (shortStatus.toUpperCase()) {
      case "1H":
      case "2H":
      case "ET":
      case "P":
      case "LIVE":
      case "BT": // Break Time (sometimes used)
        return MatchStatus.live;
      case "HT":
        return MatchStatus.halfTime;
      case "FT":
      case "AET":
      case "PEN":
        return MatchStatus.finished;
      case "NS":
      case "TBD":
      case "CANC":
      case "PST":
      case "SUSP":
      case "INT":
      case "ABD":
      case "WO":
        return MatchStatus
            .upcoming; // Treat scheduled/cancelled/postponed as non-live for now or handle separately
      default:
        return MatchStatus.upcoming;
    }
  }
}
