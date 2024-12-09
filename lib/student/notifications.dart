import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with TickerProviderStateMixin {
  TabController? _tabController;


  List<String> newNotifications = [];
  List<String> starredNotifications = [];
  List<String> oldNotifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _addNotification(String text) {
    setState(() {
      newNotifications.add(text);
    });
  }

  void _showAddNotificationDialog() {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Notification"),
          content: TextField(
            controller: _controller,
            decoration:
                const InputDecoration(hintText: "Enter notification text"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _addNotification(_controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "New"),
            Tab(text: "Starred"),
            Tab(text: "Old"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(newNotifications, "No new notifications"),
          _buildNotificationList(
              starredNotifications, "No starred notifications"),
          _buildNotificationList(oldNotifications, "No old notifications"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNotificationDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotificationList(
      List<String> notifications, String emptyMessage) {
    if (notifications.isEmpty) {
      return Center(child: Text(emptyMessage));
    }
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(notifications[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.star),
                onPressed: () {
                  setState(() {
                    starredNotifications.add(notifications[index]);
                    notifications.removeAt(index);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    oldNotifications.add(notifications[index]);
                    notifications.removeAt(index);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
