import 'package:clients/model/user.dart';
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

class AddWalletToServer extends WalletEvent {
  final String token;

  AddWalletToServer(this.token);

  @override
  List<Object> get props => [token];
}

class InitAmount extends WalletEvent {
  final double amount;

  InitAmount(this.amount);

  @override
  List<Object> get props => [amount];
}

class InitAddWalletViaCashfree extends WalletEvent {
  final User user;

  InitAddWalletViaCashfree(this.user);

  @override
  List<Object> get props => [];
}

class AddWalletViaStripe extends WalletEvent {
  final String token;

  AddWalletViaStripe(this.token);

  @override
  List<Object> get props => [];
}
