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
    } else if (event is AddWallet) {
      yield* mapAddWalletToState(event.token);
    } else if (event is InitAmount) {
      yield* mapInitAmountToState(event.amount);
    }
  }

  Stream<WalletState> mapGetWalletInfoToState(String token) async* {
    yield LoadingWalletState();
    try {
      Wallet wallet = await repository.getWalletInfo(token);
      yield WalletState(wallet: wallet);
    } catch (e) {
      yield ErrorWalletState(e.toString());
    }
  }

  Stream<WalletState> mapAddWalletToState(String token) async* {
    yield LoadingAddWallet(wallet: state.wallet, amount: state.amount);

    try {
      bool isSuccess = await repository.addWallet(token, state.amount);

      if (isSuccess) {
        yield WalletState(wallet: state.wallet);
      } else {
        yield ErrorAddWallet("", wallet: state.wallet);
      }
    } catch (e) {
      yield ErrorAddWallet(e.toString(), wallet: state.wallet);
    }
  }

  Stream<WalletState> mapInitAmountToState(double amount) async* {
    yield WalletState(amount: amount, wallet: state.wallet);
  }
}
