import 'package:flutter/material.dart';
import '../screens/spending/spending_dashboard.dart';
import '../screens/savings/savings_dashboard.dart';

class DashBoardNavBar extends StatefulWidget {
  const DashBoardNavBar({required Key key}) : super(key: key);

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<DashBoardNavBar> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          SpendingDashboard(),
          SavingsDashboard(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[800],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Spending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Savings',
          ),
        ],
      ),
    );
  }
}
