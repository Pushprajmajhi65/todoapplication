import 'package:flutter/material.dart';
import 'package:test12/themes/themes.dart';



class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _handleThemeChange(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    widget.onThemeChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? darkTheme : lightTheme;
    final themeData = Theme.of(context);
    return Scaffold(
      
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Preferences Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text(
                'User Preferences',
                style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text(
                'Manage your personal preferences.',
                style: theme.textTheme.bodyMedium,
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: theme.textTheme.bodyLarge?.color),
              onTap: () {
                // Navigate to User Preferences screen
              },
            ),
          ),
          SizedBox(height: 16.0),

          // Notifications Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text(
                'Notifications',
                style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text(
                'Set your notification preferences.',
                style: theme.textTheme.bodyMedium,
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: theme.textTheme.bodyLarge?.color),
              onTap: () {
                // Navigate to Notifications settings screen
              },
            ),
          ),
          SizedBox(height: 16.0),

          // Theme Toggle Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SwitchListTile(
              title: Text(
                'Dark Mode',
                style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text(
                _isDarkMode ? 'Currently enabled' : 'Currently disabled',
                style: theme.textTheme.bodyMedium,
              ),
              value: _isDarkMode,
              onChanged: _handleThemeChange,
              activeColor: theme.primaryColor,
              secondary: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode, color: theme.textTheme.bodyLarge?.color),
            ),
          ),
          SizedBox(height: 16.0),

          // Account Settings Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text(
                'Account Settings',
                style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text(
                'Update your account details and password.',
                style: theme.textTheme.bodyMedium,
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: theme.textTheme.bodyLarge?.color),
              onTap: () {
                // Navigate to Account Settings screen
              },
            ),
          ),
          SizedBox(height: 16.0),

          // Privacy and Security Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text(
                'Privacy & Security',
                style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text(
                'Manage your privacy and security settings.',
                style: theme.textTheme.bodyMedium,
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: theme.textTheme.bodyLarge?.color),
              onTap: () {
                // Navigate to Privacy & Security screen
              },
            ),
          ),
        ],
      ),
    );
  }
}