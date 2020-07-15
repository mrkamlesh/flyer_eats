import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/bloc/notifications/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/notification.dart';
import 'package:clients/widget/app_bar.dart';

class NotificationSListPage extends StatefulWidget {
  @override
  _NotificationSListPageState createState() => _NotificationSListPageState();
}

class _NotificationSListPageState extends State<NotificationSListPage> {
  NotificationsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = NotificationsBloc();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<NotificationsBloc>(
          create: (context) {
            return _bloc..add(GetNotification(loginState.user.token));
          },
          child: BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              return Scaffold(
                body: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: AppUtil.getScreenWidth(context),
                          height: AppUtil.getBannerHeight(context),
                          child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.asset(
                                "assets/allrestaurant.png",
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              )),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.black54),
                      width: AppUtil.getScreenWidth(context),
                      height: AppUtil.getBannerHeight(context),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Builder(
                        builder: (context) {
                          return CustomAppBar(
                            leading: "assets/back.svg",
                            title: "Notifications",
                            onTapLeading: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: Colors.transparent,
                          );
                        },
                      ),
                    ),
                    DraggableScrollableSheet(
                      initialChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                          AppUtil.getScreenHeight(context),
                      minChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                          AppUtil.getScreenHeight(context),
                      maxChildSize: 1.0,
                      builder: (context, controller) {
                        controller.addListener(() {
                          double maxScroll = controller.position.maxScrollExtent;
                          double currentScroll = controller.position.pixels;

                          if (currentScroll == maxScroll && !state.hasReachedMax)
                            _bloc.add(GetNotification(loginState.user.token));
                        });

                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                          child: ListView.builder(
                            controller: controller,
                            itemBuilder: (context, i) {
                              if (i == state.listNotification.length) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: horizontalPaddingDraggable, right: horizontalPaddingDraggable, top: 20),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return NotificationItemWidget(
                                notificationItem: state.listNotification[i],
                              );
                            },
                            itemCount:
                                state.isLoading ? state.listNotification.length + 1 : state.listNotification.length,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class NotificationItemWidget extends StatelessWidget {
  final NotificationItem notificationItem;

  const NotificationItemWidget({Key key, this.notificationItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: horizontalPaddingDraggable, right: horizontalPaddingDraggable, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              notificationItem.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  notificationItem.dateCreated,
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              notificationItem.message,
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
          ),
          Divider(
            color: Colors.black12,
            height: 0.5,
          )
        ],
      ),
    );
  }
}
