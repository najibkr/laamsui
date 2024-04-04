class PhoneNumber {
  final String? countryCode;
  final String? areaCode;
  final String? number;

  const PhoneNumber({
    required this.countryCode,
    required this.areaCode,
    required this.number,
  });

  const PhoneNumber.init({
    this.countryCode,
    this.areaCode,
    this.number,
  });

  PhoneNumber copyWith({
    String? countryCode,
    String? areaCode,
    String? number,
  }) {
    return PhoneNumber(
      countryCode: countryCode ?? this.countryCode,
      areaCode: areaCode ?? this.areaCode,
      number: number ?? this.number,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    var map = <String, dynamic>{
      'countryCode': countryCode,
      'areaCode': areaCode,
      'number': number,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory PhoneNumber.fromMap(Map<String, dynamic>? map, [String? id]) {
    if (map == null) return const PhoneNumber.init();
    return PhoneNumber(
      countryCode: map['countryCode'],
      areaCode: map['areaCode'],
      number: map['number'],
    );
  }
  static List<PhoneNumber> listFromMaps(List? list) {
    if (list == null || list.isEmpty) return const [];
    return list.map((e) => PhoneNumber.fromMap(e)).toList();
  }
}
