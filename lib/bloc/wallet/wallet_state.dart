import 'package:clients/model/wallet.dart';

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
  LoadingAddWallet({double amount, Wallet wallet})
      : super(amount: amount, wallet: wallet);
}

class ErrorAddWallet extends WalletState {
  final String message;

  ErrorAddWallet(this.message, {double amount, Wallet wallet})
      : super(amount: amount, wallet: wallet);
}

class SuccessAddWallet extends WalletState {
  final double amountAdded;

  SuccessAddWallet(this.amountAdded, {double amount, Wallet wallet})
      : super(amount: amount, wallet: wallet);
}

class CancelledAddWallet extends WalletState {
  final String message;

  CancelledAddWallet(this.message, {double amount, Wallet wallet})
      : super(amount: amount, wallet: wallet);
}

class FailedAddWalletViaCashfree extends WalletState {
  final String message;

  FailedAddWalletViaCashfree(this.message, {double amount, Wallet wallet})
      : super(amount: amount, wallet: wallet);
}
