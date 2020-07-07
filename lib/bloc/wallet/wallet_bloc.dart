import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/wallet.dart';
import './bloc.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  DataRepository repository = DataRepository();

  @override
  WalletState get initialState => LoadingWalletState();

  @override
  Stream<WalletState> mapEventToState(
    WalletEvent event,
  ) async* {
    if (event is GetWalletInfo) {
      yield* mapGetWalletInfoToState(event.token);
    }
  }

  Stream<WalletState> mapGetWalletInfoToState(String token) async* {
    try {
      Wallet wallet = await repository.getWalletInfo(token);
      yield SuccessWalletState(wallet);
    } catch (e) {
      yield ErrorWalletState(e.toString());
    }
  }
}
