class Percent {
  final int fmu;

  /// Precision could be more no more than 100000
  final int precision;

  double get amount => fmu / precision;

  const Percent._({
    required this.fmu,
    required this.precision,
  });

  const Percent.init([
    this.fmu = 0,
    this.precision = 100,
  ]);

  factory Percent.fromFMU(int fmu, [int precision = 100]) {
    precision = precision > 1000 ? 1000 : precision;
    precision = precision < 100 ? 100 : precision;
    return Percent._(fmu: fmu, precision: precision);
  }

  factory Percent(double amount, [int precision = 100]) {
    precision = precision > 1000 ? 1000 : precision;
    precision = precision < 100 ? 100 : precision;

    List<String> decimals = [];
    switch (precision) {
      case 10:
        decimals = amount.toStringAsFixed(1).split('.');
        break;
      case 100:
        decimals = amount.toStringAsFixed(2).split('.');
        break;
      case 1000:
        decimals = amount.toStringAsFixed(3).split('.');
        break;
      case 10000:
        decimals = amount.toStringAsFixed(4).split('.');
        break;
      default:
        decimals = amount.toStringAsFixed(5).split('.');
        break;
    }
    if (decimals.isEmpty) decimals.addAll(['0', '00000']);

    final whole = int.tryParse(decimals.first) ?? 0;
    final fractions = int.tryParse(decimals.last) ?? 0;

    var fmu = whole * precision;
    fmu = amount.isNegative ? fmu + (-fractions) : fmu + fractions;
    return Percent._(fmu: fmu, precision: precision);
  }

  factory Percent.fromMap(Map<String, dynamic>? json) {
    if (json == null) return const Percent.init();
    return Percent._(
      fmu: _toInt(json['fmu']),
      precision: _toInt(json['precision']),
    );
  }

  static int _toInt(dynamic data) {
    try {
      return ((data ?? 0) as num).toInt();
    } catch (e) {
      return 0;
    }
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'fmu': fmu,
      'precision': precision,
    };
  }

  @override
  String toString() => '$amount %';

  @override
  bool operator ==(other) {
    if (other is! Percent) return false;
    return fmu == other.fmu && precision == other.precision;
  }

  bool operator >=(other) {
    if (other is! Percent) return false;
    return fmu >= other.fmu && precision == other.precision;
  }

  bool operator <=(other) {
    if (other is! Percent) return false;
    return fmu <= other.fmu && precision == other.precision;
  }

  bool operator >(other) {
    if (other is! Percent) return false;
    return fmu > other.fmu && precision == other.precision;
  }

  bool operator <(other) {
    if (other is! Percent) return false;
    return fmu < other.fmu && precision == other.precision;
  }

  Percent operator +(Percent other) {
    if (precision != other.precision) throw 'precisions-do-not-match';
    return Percent.fromFMU(fmu + other.fmu, precision);
  }

  Percent operator -(Percent other) {
    if (precision != other.precision) throw 'precisions-do-not-match';
    return Percent.fromFMU(fmu - other.fmu, precision);
  }

  @override
  int get hashCode => fmu.hashCode ^ precision.hashCode;
}
