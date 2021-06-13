import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;
import 'package:xml/xml.dart' as xml;
import 'package:app/infrastructure/hive_adapters/currency_model/currency_model.dart';

class CurrencyRepository {
  Future<List<CurrencyModel>> fetchCurrencies(String formattedDate) async {
    final uri = Uri.parse("https://www.cbar.az/currencies/$formattedDate.xml");
    final response = await http.get(uri);
    final decoded = utf8.decode(response.bodyBytes);

    final raw = xml.XmlDocument.parse(decoded);
    final elements = raw.findAllElements('Valute');
    const ignoreds = ["XPD", "XPT", "XAG", "XAU", "SDR"];

    final currencies = <CurrencyModel>[];
    for (xml.XmlElement element in elements) {
      final code = element.getAttribute('Code');
      if (ignoreds.contains(code)) continue;

      final nominal = int.tryParse(element.findElements('Nominal').first.text);
      String name = element.findElements('Name').first.text;
      int spaceIndex = name.indexOf(" ");
      if (spaceIndex > 0) name = name.substring(name.indexOf(" ") + 1);
      final value = double.tryParse(element.findElements('Value').first.text);
      final model = CurrencyModel(code: code, name: name, nominal: nominal, value: value);
      currencies.add(model);
    }
    return currencies;
  }
}
