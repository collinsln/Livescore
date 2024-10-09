class MatchModel {
  final String homeTeamName;
  final String awayTeamName;
  final int homeTeamScore;
  final int awayTeamScore;
  final String status;
  final String time;
  final String tournamentName;
  final String seasonName;
  final String startTime;

  MatchModel({
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamScore,
    required this.awayTeamScore,
    required this.status,
    required this.time,
    required this.tournamentName,
    required this.seasonName,
    required this.startTime,
  });

  // Factory constructor to create an instance from JSON with null safety
  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      homeTeamName:
          json['home_team_name'] ?? 'Unknown Home Team', // Fallback for null
      awayTeamName:
          json['away_team_name'] ?? 'Unknown Away Team', // Fallback for null
      homeTeamScore:
          json['home_team_score']?['current'] ?? 0, // Fallback for null
      awayTeamScore:
          json['away_team_score']?['current'] ?? 0, // Fallback for null
      status: (json['status']?['type'] ?? 'Unknown Status') +
          ' - ' +
          (json['status']?['reason'] ?? ''),
      time: json['time'] ?? '0\'', // Fallback for null
      tournamentName: json['tournament_name'] ?? 'Unknown Tournament',
      seasonName: json['season_name'] ?? 'Unknown Season',
      startTime: json['start_time'] ?? 'Unknown Start Time',
    );
  }

  // Static method to create a list of matches from a JSON array
  static List<MatchModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MatchModel.fromJson(json)).toList();
  }
}
