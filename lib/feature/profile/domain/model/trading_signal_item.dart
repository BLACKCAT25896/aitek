import 'package:mighty_school/helper/price_converter.dart';

class TradingSignalItem {
  int? id;
  int? actualTime;
  String? comment;
  String? pair;
  int? cmd;
  int? tradingSystem;
  String? period;
  double? price;
  double? sl;
  double? tp;

  TradingSignalItem(
      {this.id,
        this.actualTime,
        this.comment,
        this.pair,
        this.cmd,
        this.tradingSystem,
        this.period,
        this.price,
        this.sl,
        this.tp});

  TradingSignalItem.fromJson(Map<String, dynamic> json) {
    id = PriceConverter.parseInt(json['Id']);
    actualTime = PriceConverter.parseInt(json['ActualTime']);
    comment = json['Comment'];
    pair = json['Pair'];
    cmd = PriceConverter.parseInt(json['Cmd']);
    tradingSystem = PriceConverter.parseInt(json['TradingSystem']);
    period = json['Period'];
    price = PriceConverter.parseAmount(json['Price']);
    sl = PriceConverter.parseAmount(json['Sl']);
    tp = PriceConverter.parseAmount(json['Tp']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ActualTime'] = actualTime;
    data['Comment'] = comment;
    data['Pair'] = pair;
    data['Cmd'] = cmd;
    data['TradingSystem'] = tradingSystem;
    data['Period'] = period;
    data['Price'] = price;
    data['Sl'] = sl;
    data['Tp'] = tp;
    return data;
  }


  bool get isBuy => cmd == 0 || cmd == 2 || cmd == 4;

  String get cmdLabel {
    switch (cmd) {
      case 0: return 'BUY';
      case 1: return 'SELL';
      case 2: return 'BUY LIMIT';
      case 3: return 'SELL LIMIT';
      case 4: return 'BUY STOP';
      case 5: return 'SELL STOP';
      default: return 'ORDER';
    }
  }


  DateTime get time => DateTime.fromMillisecondsSinceEpoch((actualTime ?? 0) * 1000);
}