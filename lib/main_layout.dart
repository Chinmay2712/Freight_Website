import 'package:flutter/material.dart';
import 'package:freight_website/screens/bookings.dart';
import 'package:freight_website/screens/freight_page.dart';
import 'package:freight_website/screens/profile.dart';
import 'package:freight_website/screens/settings.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;
  const MainLayout({Key? key, this.initialIndex = 1}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return const Bookings();
      case 1:
        return FreightPage();
      case 2:
        return const Settings();
      default:
        return FreightPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F9FC),
      body: Row(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 10),
                child: Image.asset(
                  'assets/demo.png',
                  height: 120,
                ),
              ),
              Expanded(
                child: NavigationRail(
                  indicatorColor: const Color(0xffE6EBFF),
                  selectedLabelTextStyle: const TextStyle(
                    color: Color(0xFF0139FF),
                  ),
                  selectedIconTheme: const IconThemeData(color: Color(0xFF0139FF)),
                  backgroundColor: const Color(0xffF6F9FC),
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.search),
                      label: Text('Bookings'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insert_drive_file),
                      label: Text('Quotations'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to Profile page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Profile()));
                        },
                        child: const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage('assets/person.png'),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Profile',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: _getSelectedPage(),
          ),
        ],
      ),
    );
  }
}
