import 'package:flutter/material.dart';
import 'package:test12/screens/Aboutpage.dart';
import 'package:test12/screens/Settingpage.dart';
import 'package:test12/screens/Task_page.dart';
import 'package:test12/screens/home_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconColor = Theme.of(context).iconTheme.color ?? Colors.black;
    final Color appBarTextColor = Theme.of(context).appBarTheme.titleTextStyle?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(), style: TextStyle(color: appBarTextColor)),
        backgroundColor: primaryColor,
      ),
      body: _getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: iconColor),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task, color: iconColor),
            label: 'Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: iconColor),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: iconColor),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  // Method to get the title for the AppBar based on the selected index
  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Task';
      case 2:
        return 'Settings';
      case 3:
        return 'About';
      default:
        return 'Home';
    }
  }

  // Method to return the widget for the selected tab
  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return homePage();
      case 1:
        return TaskPage();
      case 2:
        return SettingsPage(isDarkMode: true, onThemeChanged: (bool value) { /* Handle theme change */ });
      case 3:
        return AboutPage();
      default:
        return homePage();
    }
  }
}