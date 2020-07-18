import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  @override
  NotificationState get initialState => NotReceiveNotification();

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is UpdateMessage) {
      yield* mapUpdateMessageToState(event.message);
    } else if (event is ResetMessage) {
      yield* mapResetMessageToState();
    }
  }

  Stream<NotificationState> mapUpdateMessageToState(Map<String, dynamic> message) async* {
    if (message['data']['push_type'] == 'order') {
      yield ReceiveOrderNotification(message: message);
    } else if (message['data']['type'] == 'campaign') {
      yield ReceiveCampaignNotification(message: message);
    }
  }

  Stream<NotificationState> mapResetMessageToState() async* {
    yield NotReceiveNotification();
  }
}
