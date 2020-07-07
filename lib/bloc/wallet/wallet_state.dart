import 'package:flyereats/model/review.dart';
import 'package:flyereats/model/wallet.dart';

class WalletState {
  WalletState();
}

class LoadingWalletState extends WalletState {
  LoadingWalletState();
}

class SuccessWalletState extends WalletState {
  final Wallet wallet;

  SuccessWalletState(this.wallet);
}

class ErrorWalletState extends WalletState {
  final String message;

  ErrorWalletState(this.message);
}