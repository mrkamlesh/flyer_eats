import 'package:clients/model/bank.dart';
import 'package:clients/model/fe_offer.dart';

class BankOfferState {
  final List<Bank> banks;

  BankOfferState({this.banks});
}

class LoadingBankOfferState extends BankOfferState {}

class ErrorBankOfferState extends BankOfferState {
  final String message;

  ErrorBankOfferState(this.message);
}
