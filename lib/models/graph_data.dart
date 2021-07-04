class GraphData {
  GraphData({this.id, this.memoryName, this.scoresPerDay, this.totalWords});

  int? id;
  String? memoryName;
  //this will take the total nmber of words to be memorized
  int? totalWords;
  //have total wrongs on a particular day out of total words for that day
  Map<DateTime, List<int>>? scoresPerDay;

  void addDayScore(DateTime time, List<int> score) {
    scoresPerDay?[time] = score;
  }
}
