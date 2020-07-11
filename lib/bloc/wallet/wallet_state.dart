import 'package:flyereats/model/wallet.dart';

class WalletState {
  final double amount;
  final Wallet wallet;

  WalletState({this.amount, this.wallet});
}

class LoadingWalletState extends WalletState {
  LoadingWalletState() : super();
}

class ErrorWalletState extends WalletState {
  final String message;

  ErrorWalletState(this.message) : super();
}

class LoadingAddWallet extends WalletState {
  LoadingAddWallet({double amount, Wallet wallet}) : super(amount: amount, wallet: wallet);
}

class ErrorAddWallet extends WalletState {
  final String message;

  ErrorAddWallet(this.message, {double amount, Wallet wallet}) : super(amount: amount, wallet: wallet);
}
