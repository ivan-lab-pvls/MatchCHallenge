class LevelItem {
  int? levelNumber;
  bool? isCompleted;

  LevelItem({this.levelNumber, this.isCompleted});

  factory LevelItem.fromJson(Map<String, dynamic> parsedJson) {
    return LevelItem(
      levelNumber: parsedJson['levelNumber'] ?? "",
      isCompleted: parsedJson['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelNumber': levelNumber,
      'isCompleted': isCompleted,
    };
  }
}
