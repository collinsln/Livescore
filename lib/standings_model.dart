import 'dart:convert';

class Competitor {
  final int wins;
  final int draws;
  final int losses;
  final int points;
  final int matches;
  final int teamId;
  final int position;
  final String teamName;
  final int scoresFor;
  final int scoresAgainst;
  final String teamHashImage;

  Competitor({
    required this.wins,
    required this.draws,
    required this.losses,
    required this.points,
    required this.matches,
    required this.teamId,
    required this.position,
    required this.teamName,
    required this.scoresFor,
    required this.scoresAgainst,
    required this.teamHashImage,
  });

  factory Competitor.fromJson(Map<String, dynamic> json) {
    return Competitor(
      wins: json['wins'],
      draws: json['draws'],
      losses: json['losses'],
      points: json['points'],
      matches: json['matches'],
      teamId: json['team_id'],
      position: json['position'],
      teamName: json['team_name'],
      scoresFor: json['scores_for'],
      scoresAgainst: json['scores_against'],
      teamHashImage: json['team_hash_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'points': points,
      'matches': matches,
      'team_id': teamId,
      'position': position,
      'team_name': teamName,
      'scores_for': scoresFor,
      'scores_against': scoresAgainst,
      'team_hash_image': teamHashImage,
    };
  }
}

class Standing {
  final int id;
  final int tournamentId;
  final String type;
  final String name;
  final int seasonId;
  final String seasonName;
  final int leagueId;
  final String leagueName;
  final String leagueHashImage;
  final List<Competitor> competitors;

  Standing({
    required this.id,
    required this.tournamentId,
    required this.type,
    required this.name,
    required this.seasonId,
    required this.seasonName,
    required this.leagueId,
    required this.leagueName,
    required this.leagueHashImage,
    required this.competitors,
  });

  factory Standing.fromJson(Map<String, dynamic> json) {
    var competitorsJson = json['competitors'] as List;
    List<Competitor> competitorsList = competitorsJson
        .map((competitorJson) => Competitor.fromJson(competitorJson))
        .toList();

    return Standing(
      id: json['id'],
      tournamentId: json['tournament_id'],
      type: json['type'],
      name: json['name'],
      seasonId: json['season_id'],
      seasonName: json['season_name'],
      leagueId: json['league_id'],
      leagueName: json['league_name'],
      leagueHashImage: json['league_hash_image'],
      competitors: competitorsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournament_id': tournamentId,
      'type': type,
      'name': name,
      'season_id': seasonId,
      'season_name': seasonName,
      'league_id': leagueId,
      'league_name': leagueName,
      'league_hash_image': leagueHashImage,
      'competitors':
          competitors.map((competitor) => competitor.toJson()).toList(),
    };
  }
}

// Function to parse the JSON string into a list of standings
List<Standing> parseStandings(String jsonStr) {
  final List<dynamic> jsonData = json.decode(jsonStr);
  return jsonData.map((jsonItem) => Standing.fromJson(jsonItem)).toList();
}
