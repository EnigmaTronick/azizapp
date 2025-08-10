import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azizapp/components/sidebar/futuristic_sidebar.dart';
import '../components/navigation/futuristic_nav_bar.dart';
import '../components/common/futuristic_top_bar.dart';
import '../providers/theme_provider.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'scan_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  NavItem _currentNavItem = NavItem.home;
  bool _isSidebarOpen = false;
  
  final Map<NavItem, Widget> _screens = {
    NavItem.home: const HomeScreen(),
    NavItem.history: const HistoryScreen(),
    NavItem.scan: const ScanScreen(),
    NavItem.profile: const ProfileScreen(),
  };
  
  final Map<NavItem, String> _titles = {
    NavItem.home: 'Home',
    NavItem.history: 'History',
    NavItem.scan: 'Scan',
    NavItem.profile: 'Profile',
  };
  
  void _onNavItemTapped(NavItem item) {
    setState(() {
      _currentNavItem = item;
    });
  }
  
  void _openSidebar() {
    setState(() {
      _isSidebarOpen = true;
    });
  }
  
  void _closeSidebar() {
    setState(() {
      _isSidebarOpen = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.isDarkMode
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Stack(
              children: [
                // Main Content
                Column(
                  children: [
                    // Top Bar
                    FuturisticTopBar(
                      title: _titles[_currentNavItem] ?? 'AzizApp',
                      onMenuTap: _openSidebar,
                    ),
                    
                    // Screen Content
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          bottom: isSmallScreen ? 85 : 100,
                        ),
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: screenHeight - 
                                (kToolbarHeight + 20) - // top bar height
                                (isSmallScreen ? 85 : 100) - // navigation bar space
                                safeAreaBottom - // safe area
                                20, // extra padding
                            ),
                            child: _screens[_currentNavItem] ?? const HomeScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Bottom Navigation Bar
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: FuturisticNavBar(
                    currentIndex: _currentNavItem,
                    onTap: _onNavItemTapped,
                  ),
                ),
                
                // Sidebar Overlay
                if (_isSidebarOpen)
                  FuturisticSidebar(
                    onClose: _closeSidebar,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
