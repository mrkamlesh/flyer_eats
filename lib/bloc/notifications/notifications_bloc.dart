import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/notification.dart';
import './bloc.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  DataRepository repository = DataRepository();

  @override
  NotificationsState get initialState =>
      NotificationsState(isLoading: true, hasReachedMax: false, listNotification: List<NotificationItem>(), page: 0);

  @override
  Stream<NotificationsState> mapEventToState(
    NotificationsEvent event,
  ) async* {
    if (event is GetNotification) {
      yield* mapGetNotificationToState(event.token);
    }
  }

  Stream<NotificationsState> mapGetNotificationToState(String token) async* {
    yield NotificationsState(
        page: state.page, isLoading: true, hasReachedMax: state.hasReachedMax, listNotification: state.listNotification);

    try {
      List<NotificationItem> list = await repository.getNotificationList(token, state.page);

      if (list.isEmpty) {
        yield NotificationsState(
            listNotification: state.listNotification, isLoading: false, hasReachedMax: true, page: state.page);
      } else {
        yield NotificationsState(
            listNotification: state.listNotification + list,
            isLoading: false,
            hasReachedMax: false,
            page: state.page + 1);
      }
    } catch (e) {
      yield NotificationsState(
          listNotification: state.listNotification,
          isLoading: false,
          hasReachedMax: state.hasReachedMax,
          page: state.page);
    }
  }
}
