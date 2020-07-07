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
