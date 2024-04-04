class Money {
  final int fmu;
  final String currency;

  /// Precision could be more no more than 100000
  final int precision;

  double get amount => fmu / precision;

  const Money._({
    required this.fmu,
    required this.currency,
    required this.precision,
  });

  const Money.init([
    this.fmu = 0,
    this.currency = '',
    this.precision = 100000,
  ]);

  factory Money.fromFMU(int fmu, String currency, [int precision = 100000]) {
    precision = precision > 100000 ? 100000 : precision;
    precision = precision < 10 ? 10 : precision;
    return Money._(fmu: fmu, currency: currency, precision: precision);
  }

  factory Money(double amount, String currency, [int precision = 100000]) {
    precision = precision > 100000 ? 100000 : precision;
    precision = precision < 10 ? 10 : precision;

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
    return Money._(fmu: fmu, currency: currency, precision: precision);
  }

  /// `id` and `okey` do not meaning anything. its is used to meet the
  /// serialization convention of Laams data types.
  factory Money.fromMap(
    Map<String, dynamic>? json, [
    String? id,
    bool okey = false,
  ]) {
    if (json == null) return const Money.init();
    return Money._(
      fmu: _toInt(json['fmu']),
      precision: _toInt(json['precision']),
      currency: json['currency'] ?? '',
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
      'currency': currency,
      'precision': precision,
    };
  }

  @override
  String toString() => '$amount $currency';

  @override
  bool operator ==(other) {
    if (other is! Money) return false;
    return fmu == other.fmu &&
        currency == other.currency &&
        precision == other.precision;
  }

  bool operator >=(other) {
    if (other is! Money) return false;
    return fmu >= other.fmu &&
        currency == other.currency &&
        precision == other.precision;
  }

  bool operator <=(other) {
    if (other is! Money) return false;
    return fmu <= other.fmu &&
        currency == other.currency &&
        precision == other.precision;
  }

  bool operator >(other) {
    if (other is! Money) return false;
    return fmu > other.fmu &&
        currency == other.currency &&
        precision == other.precision;
  }

  bool operator <(other) {
    if (other is! Money) return false;
    return fmu < other.fmu &&
        currency == other.currency &&
        precision == other.precision;
  }

  Money operator +(Money other) {
    if (currency != other.currency) throw 'currencies-do-not-match';
    if (precision != other.precision) throw 'precisions-do-not-match';
    return Money.fromFMU(fmu + other.fmu, currency, precision);
  }

  Money operator -(Money other) {
    if (currency != other.currency) throw 'currencies-do-not-match';
    if (precision != other.precision) throw 'precisions-do-not-match';
    return Money.fromFMU(fmu - other.fmu, currency, precision);
  }

  @override
  int get hashCode => fmu.hashCode ^ currency.hashCode ^ precision.hashCode;
}
