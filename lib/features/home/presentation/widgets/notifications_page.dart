import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/features/home/domain/entities/notifications_entity.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_event.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_state.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';

class NotificationsPage extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;
  const NotificationsPage({super.key, required this.isGuest, required this.user});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      if (mounted && context.read<NotificationBloc>().state is! NotificationsLoaded) {
        context.read<NotificationBloc>().add(GetNotificationsEvent());
      }
    });
  }

  List<NotificationEntity> notifications = [];

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).cardColor,
            title:  Text(
              "Notifications",
                style: Theme.of(context).textTheme.bodyMedium
            ),
            centerTitle: true,
            elevation: 2,
          ),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationsLoaded) {
                    notifications = state.notifications;
                    return ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      itemCount: notifications.length,
                      itemBuilder: (BuildContext context, int index) {
                        final notification = notifications[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Color(0xFF212121)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title['text'] ?? 'No Title',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "By: ${notification.by['name'] ?? 'Unknown'}",
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    notification.description['content'] ?? 'No Description',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  if (notification.image != null &&
                                      notification.image is Map<String, dynamic> &&
                                      notification.image?['url'] != null &&
                                      (notification.image?['url'] as String).isNotEmpty)
                                    Column(
                                      children: [
                                        const SizedBox(height: 12),
                                        Container(
                                          width: double.infinity,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: NetworkImage(notification.image!['url']),
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.high,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                    );
                  } else if (state is NotificationsError) {
                    return Center(
                      child: Text(
                        "Error loading notifications: ${state.message}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          floatingActionButton: widget.isGuest?null: FloatingActionButton(
            onPressed: () {
              GoRouter.of(context).pushNamed(
                UhlLinkRoutesNames.addNotification,
                pathParameters: {"user": jsonEncode(widget.user)},
              );
            },
            child: const Icon(Icons.add),
          ),
        );

  }
}
