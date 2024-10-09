class MatchModel {
  final int id;
  final String name;
  final int leagueId;
  final int seasonId;
  final DateTime startTime;
  final String leagueName;
  final String seasonName;
  final String statusType;
  final int awayTeamId;
  final int homeTeamId;
  final String statusReason;
  final int tournamentId;
  final String awayTeamName;
  final String homeTeamName;
  final int awayTeamScore; // Might not be provided for upcoming matches
  final int homeTeamScore; // Might not be provided for upcoming matches
  final String tournamentName;
  final String leagueHashImage;
  final String awayTeamHashImage;
  final String homeTeamHashImage;
  final int tournamentImportance;

  MatchModel({
    required this.id,
    required this.name,
    required this.leagueId,
    required this.seasonId,
    required this.startTime,
    required this.leagueName,
    required this.seasonName,
    required this.statusType,
    required this.awayTeamId,
    required this.homeTeamId,
    required this.statusReason,
    required this.tournamentId,
    required this.awayTeamName,
    required this.homeTeamName,
    required this.awayTeamScore,
    required this.homeTeamScore,
    required this.tournamentName,
    required this.leagueHashImage,
    required this.awayTeamHashImage,
    required this.homeTeamHashImage,
    required this.tournamentImportance,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Match',
      leagueId: json['league_id'] ?? 0,
      seasonId: json['season_id'] ?? 0,
      startTime: DateTime.tryParse(json['start_time']) ?? DateTime.now(),
      leagueName: json['league_name'] ?? 'Unknown League',
      seasonName: json['season_name'] ?? 'Unknown Season',
      statusType: json['status'] ?? 'Unknown Status',
      awayTeamId: json['away_team_id'] ?? 0,
      homeTeamId: json['home_team_id'] ?? 0,
      statusReason: json['status_reason'] ?? 'No reason provided',
      tournamentId: json['tournament_id'] ?? 0,
      awayTeamName: json['away_team_name'] ?? 'Unknown Away Team',
      homeTeamName: json['home_team_name'] ?? 'Unknown Home Team',
      awayTeamScore: json.containsKey('away_team_score')
          ? (json['away_team_score'] ?? 0)
          : 0, // Safely check if it exists
      homeTeamScore: json.containsKey('home_team_score')
          ? (json['home_team_score'] ?? 0)
          : 0, // Safely check if it exists
      tournamentName: json['tournament_name'] ?? 'Unknown Tournament',
      leagueHashImage: json['league_hash_image'] ?? '',
      awayTeamHashImage: json['away_team_hash_image'] ?? '',
      homeTeamHashImage: json['home_team_hash_image'] ?? '',
      tournamentImportance: json['tournament_importance'] ?? 0,
    );
  }
}
