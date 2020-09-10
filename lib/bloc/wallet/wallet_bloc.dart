import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/user.dart';
import 'package:clients/model/wallet.dart';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import './bloc.dart';
import 'package:http/http.dart' as http;

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
    } else if (event is AddWalletToServer) {
      yield* mapAddWalletToState(event.token);
    } else if (event is InitAmount) {
      yield* mapInitAmountToState(event.amount);
    } else if (event is AddWalletViaStripe) {
      yield* mapAddWalletViaStripeToState(event.token);
    } else if (event is InitAddWalletViaCashfree) {
      yield* mapInitAddWalletViaCashfreeToState(event.user);
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
        yield SuccessAddWallet(state.amount, wallet: state.wallet);
        add(GetWalletInfo(token));
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

  Stream<WalletState> mapAddWalletViaStripeToState(String token) async* {
    yield LoadingAddWallet(wallet: state.wallet, amount: state.amount);

    try {
      StripePayment.setOptions(StripeOptions(
          publishableKey: state.wallet.stripePublishKey,
          merchantId: "Flyer Eats",
          androidPayMode: 'test'));

      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());

      var paymentIntent;

      try {
        Map<String, dynamic> body = {
          'amount': (state.amount * 100.0).ceil().toString(),
          'currency': state.wallet.currencyCode,
          'payment_method_types[]': 'card'
        };
        Map<String, String> headers = {
          'Authorization': 'Bearer ${state.wallet.stripeSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        };
        var response = await http.post(
            "https://api.stripe.com/v1/payment_intents",
            body: body,
            headers: headers);
        paymentIntent = jsonDecode(response.body);
      } catch (err) {
        print('err charging user: ${err.toString()}');
      }

      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));

      if (response.status == 'succeeded') {
        add(AddWalletToServer(token));
      } else {
        yield ErrorAddWallet("Add Wallet via Stripe Failed",
            amount: state.amount, wallet: state.wallet);
      }
    } on PlatformException catch (e) {
      print(e);
      yield CancelledAddWallet("Add Wallet Cancelled",
          wallet: state.wallet, amount: state.amount);
    } catch (e) {
      yield ErrorAddWallet(e.toString(),
          amount: state.amount, wallet: state.wallet);
    }
  }

  Stream<WalletState> mapInitAddWalletViaCashfreeToState(User user) async* {
    yield LoadingAddWallet(wallet: state.wallet, amount: state.amount);
    try {
      Map<String, String> result = await repository.initCashfreePayment(
          user.token, state.amount.toString(), state.wallet.currencyCode);

      Map<String, dynamic> inputParams = {
        "orderId": result['order_id'],
        "orderAmount": state.amount.toString(),
        "customerName": user.name,
        "orderCurrency": state.wallet.currencyCode,
        "appId": result['app_id'],
        "tokenData": result['token'],
        "customerPhone": user.phone,
        "customerEmail": user.username,
        //"stage": "TEST"
        "stage": "PROD"
      };

      Map<dynamic, dynamic> map = await CashfreePGSDK.doPayment(inputParams);

      if (map['txStatus'] == 'SUCCESS') {
        add(AddWalletToServer(user.token));
      } else if (map['txStatus'] == 'CANCELLED') {
        yield CancelledAddWallet("Add Wallet Cancelled",
            amount: state.amount, wallet: state.wallet);
      } else {
        yield ErrorAddWallet(
            "Add wallet via Cashfree failed. Please try another payment method",
            wallet: state.wallet,
            amount: state.amount);
      }
    } catch (e) {
      yield FailedAddWalletViaCashfree(e.toString(),
          amount: state.amount, wallet: state.wallet);
    }
  }
}
