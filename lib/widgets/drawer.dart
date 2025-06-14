import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.grey[900],
            child: const Center(
              child: Text(
                'Todo App',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ),
          const SizedBox(height: 10),
          infoTiles(
              Icons.person, 'About Me', 'This app was built by Tony Johnson.'),
          infoTiles(Icons.email, 'Contact Me',
              'Tony\'s Email - 2003tonyc123@gmail.com'),
        ],
      ),
    );
  }

  Widget infoTiles(IconData icon, String title, String content) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[900],
        size: 30,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.grey[900],
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )
              ],
            ),
            content: Text(content),
          ),
        );
      },
    );
  }
}
