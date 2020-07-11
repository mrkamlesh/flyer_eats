import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletEvent extends Equatable {
  const WalletEvent();
}

class GetWalletInfo extends WalletEvent {
  final String token;

  GetWalletInfo(this.token);

  @override
  List<Object> get props => [token];
}

class AddWallet extends WalletEvent {
  final String token;

  AddWallet(this.token);

  @override
  List<Object> get props => [token];
}

class InitAmount extends WalletEvent {
  final double amount;

  InitAmount(this.amount);

  @override
  List<Object> get props => [amount];
}
