import 'package:control_shizuya_weight_flutter/screens/activity_report/activity_report_screen.dart';
import 'package:control_shizuya_weight_flutter/screens/support_message/support_message_screen.dart';
import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ActivityReportScreen();
      case 2:
        return const SupportMessageScreen();
      default:
        return const HomeScreen();
    }
  }
}
