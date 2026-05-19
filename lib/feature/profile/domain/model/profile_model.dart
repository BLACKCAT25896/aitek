import 'package:aitek/helper/price_converter.dart';

class ProfileModel {
  String? address;
  double? balance;
  String? city;
  String? country;
  int? currency;
  int? currentTradesCount;
  int? currentTradesVolume;
  int? equity;
  int? freeMargin;
  bool? isAnyOpenTrades;
  bool? isSwapFree;
  int? leverage;
  String? name;
  String? phone;
  int? totalTradesCount;
  int? totalTradesVolume;
  int? type;
  int? verificationLevel;
  String? zipCode;

  ProfileModel(
      {this.address,
        this.balance,
        this.city,
        this.country,
        this.currency,
        this.currentTradesCount,
        this.currentTradesVolume,
        this.equity,
        this.freeMargin,
        this.isAnyOpenTrades,
        this.isSwapFree,
        this.leverage,
        this.name,
        this.phone,
        this.totalTradesCount,
        this.totalTradesVolume,
        this.type,
        this.verificationLevel,
        this.zipCode});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    balance = PriceConverter.parseAmount(json['balance']);
    city = json['city'];
    country = json['country'];
    currency = PriceConverter.parseInt(json['currency']);
    currentTradesCount = PriceConverter.parseInt(json['currentTradesCount']);
    currentTradesVolume = PriceConverter.parseInt(json['currentTradesVolume']);
    equity = PriceConverter.parseInt(json['equity']);
    freeMargin = PriceConverter.parseInt(json['freeMargin']);
    isAnyOpenTrades = json['isAnyOpenTrades'];
    isSwapFree = json['isSwapFree'];
    leverage = PriceConverter.parseInt(json['leverage']);
    name = json['name'];
    phone = json['phone'];
    totalTradesCount = PriceConverter.parseInt(json['totalTradesCount']);
    totalTradesVolume = PriceConverter.parseInt(json['totalTradesVolume']);
    type = PriceConverter.parseInt(json['type']);
    verificationLevel = PriceConverter.parseInt(json['verificationLevel']);
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['balance'] = balance;
    data['city'] = city;
    data['country'] = country;
    data['currency'] = currency;
    data['currentTradesCount'] = currentTradesCount;
    data['currentTradesVolume'] = currentTradesVolume;
    data['equity'] = equity;
    data['freeMargin'] = freeMargin;
    data['isAnyOpenTrades'] = isAnyOpenTrades;
    data['isSwapFree'] = isSwapFree;
    data['leverage'] = leverage;
    data['name'] = name;
    data['phone'] = phone;
    data['totalTradesCount'] = totalTradesCount;
    data['totalTradesVolume'] = totalTradesVolume;
    data['type'] = type;
    data['verificationLevel'] = verificationLevel;
    data['zipCode'] = zipCode;
    return data;
  }
}
