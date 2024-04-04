import 'package:flutter_test/flutter_test.dart';
import 'package:laamsui/models.dart';

void main() {
  test('Check Money Instantiation', () {
    var moneyList = <Map<double, String>>[
      {100: 'RUP'},
      {1000: 'AFN'},
      {10000: 'EU'},
      {100000: 'USD'},
      {1000000: 'EU'},
      {10000000: 'AFN'},
      {100000000: 'USD'},
      {100.01: 'USD'},
      {100.02: 'USD'},
      {100.03: 'USD'},
      {100.04: 'USD'},
      {100.05: 'USD'},
      {100.06: 'USD'},
      {100.07: 'USD'},
      {100.08: 'USD'},
      {100.09: 'USD'},
      {100.10: 'USD'},
      {100.15: 'USD'},
      {100.30: 'USD'},
      {100.35: 'USD'},
      {100.40: 'USD'},
      {100.45: 'AUS'},
      {100.50: 'USD'},
      {100.60: 'USD'},
      {100.70: 'USD'},
      {100.80: 'USD'},
      {100.90: 'USD'},
      {100.100: 'USD'},
      {100.100000000: 'USD'},
      {100.10000000000: 'USD'},
      {100.1000000000000000000000000000000000000: 'USD'},
      {10000000.01: 'USD'},
      {10000000.02: 'USD'},
      {10000000.03: 'USD'},
      {10000000.04: 'USD'},
      {10000000.05: 'USD'},
      {10000000.06: 'USD'},
      {10000000.07: 'USD'},
      {10000000.08: 'USD'},
      {10000000.09: 'USD'},
      {10000000.10: 'USD'},
      {10000000.15: 'USD'},
      {10000000.30: 'USD'},
      {10000000.35: 'USD'},
      {10000000.40: 'USD'},
      {10000000.45: 'USD'},
      {10000000.50: 'USD'},
      {10000000.60: 'USD'},
      {10000000.70: 'USD'},
      {10000000.80: 'USD'},
      {10000000.90: 'USD'},
      {10000000.100: 'USD'},
      {10000000.23490: 'RYL'},
      {10000000.23908: 'RYL'},
      {100.100000000: 'USD'},
      {100.10000000000: 'USD'},
      {100.1000000000000000000000000000000000000: 'USD'},
    ];
    for (var money in moneyList) {
      var instance = Money(money.keys.first, money.values.first);
      expect(instance.amount, money.keys.first);
      expect(instance.currency, money.values.first);
    }
  });

  test('Money: Comparison Equallity Operators', () {
    var money1 = Money(10.1, 'USD');
    var money2 = Money(10.1, 'USD');
    expect(money1 == money2, true);
    var money3 = Money(11.1, 'USD');
    expect(money1 == money3, false);
    var money4 = Money(11.1, 'AFN');
    expect(money4 == money3, false);

    expect(money1 < money3, true);
    expect(money1 > money3, false);
    expect(money1 >= money3, false);
    expect(money3 > money1, true);
    expect(money3 >= money1, true);
  });

  test('Money: Check Greater or Equallity Operators', () {
    var money1 = Money(10.1, 'USD');
    var money2 = Money(10.1, 'USD');
    expect(money1 >= money2, true);
    var money3 = Money(11.1, 'USD');
    expect(money1 <= money3, true);
    var money4 = Money(11.1, 'AFN');
    expect(money4 <= money3, false);
  });
}
