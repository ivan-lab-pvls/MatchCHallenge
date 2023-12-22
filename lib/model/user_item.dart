class UserItem {
  int? hp;
  int? money;

  UserItem({this.hp = 4, this.money});

  factory UserItem.fromJson(Map<String, dynamic> parsedJson) {
    return UserItem(
      hp: parsedJson['hp'] ?? "",
      money: parsedJson['money'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hp': hp,
      'money': money,
    };
  }
}
