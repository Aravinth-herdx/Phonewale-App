import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinKit;
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart' ;
import 'package:syncfusion_flutter_charts/charts.dart';

// Role Enum
enum UserRole {
  superAdmin,
  adminHO,
  storeAdmin,
  bmAM,
  franchisee,
  storeStaff,
  externalAuditor,
  hr,
}

// App State Controller
class AppStateController extends GetxController {
  UserRole? currentRole;
  String accountName = 'Default Account';

  void login(UserRole role, String name) {
    currentRole = role;
    accountName = name;
    update();
  }

  void logout() {
    currentRole = null;
    update();
  }
}

// Drawer Controller
class DrawerController extends GetxController {
  var selectedRoute = '/dashboard'.obs;

  void selectRoute(String route) {
    selectedRoute.value = route;
  }
}

// Main Entry
void main() {
  Get.put(AppStateController());
  Get.put(DrawerController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Phonewale App',
      defaultTransition: Transition.fadeIn,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF001E36),
          primary: const Color(0xFF001E36),
          secondary: const Color(0xFFD35400),
          background: const Color(0xFFF5F5F5),
        ),
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD35400),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          labelStyle: const TextStyle(color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF001E36),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const LoginScreen()),
        GetPage(name: '/dashboard', page: () => const ModernDashboardScreen()),
      ],
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}

// Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'rajesh@phonewale.in');
  final _passwordController = TextEditingController(text: 'password123');
  UserRole? _selectedRole = UserRole.superAdmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;
          return SingleChildScrollView(
            child: Center(
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  width: isWide ? 600 : constraints.maxWidth,
                  padding: EdgeInsets.all(isWide ? 64 : 32),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: 'https://picsum.photos/seed/phonewale/300/100',
                            fit: BoxFit.cover,
                            height: 100,
                            placeholder: (context, url) => const spinKit.SpinKitCircle(color: Color(0xFFD35400)),
                          ),
                          const SizedBox(height: 32),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email/Username',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButton<UserRole>(
                            hint: const Text('Select Role'),
                            value: _selectedRole,
                            isExpanded: true,
                            onChanged: (role) => setState(() => _selectedRole = role),
                            items: UserRole.values.map((role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Text(role.toString().split('.').last.toUpperCase()),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          GFButton(
                            onPressed: () {
                              if (_selectedRole != null && _emailController.text.isNotEmpty) {
                                Get.find<AppStateController>().login(
                                  _selectedRole!,
                                  '${_selectedRole.toString().split('.').last.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[0]}').trim()} Account - ${_emailController.text.split('@')[0]}',
                                );
                                Get.toNamed('/dashboard');
                              } else {
                                Get.snackbar('Error', 'Please fill all fields');
                              }
                            },
                            text: 'Login',
                            icon: const Icon(Icons.login),
                            color: const Color(0xFFD35400),
                            fullWidthButton: true,
                            size: GFSize.LARGE,
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.lock_reset),
                            label: const Text('Forgot Password?'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Reset Password'),
                                  content: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Email',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                        Get.snackbar('Success', 'Reset link sent to your email (Mock)');
                                      },
                                      child: const Text('Send Reset Link'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Modern Dashboard Screen
class ModernDashboardScreen extends StatefulWidget {
  const ModernDashboardScreen({super.key});

  @override
  State<ModernDashboardScreen> createState() => _ModernDashboardScreenState();
}

class _ModernDashboardScreenState extends State<ModernDashboardScreen> {
  bool _isDrawerExpanded = true;
  final double _expandedDrawerWidth = 280.0;
  final double _minimizedDrawerWidth = 80.0;
  final DrawerController _drawerController = Get.find<DrawerController>();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: _buildDrawer(context, false),
      mainScreen: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 800;
          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            drawer: isWide ? null : _buildDrawer(context, false),
            body: Row(
              children: [
                if (isWide)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isDrawerExpanded ? _expandedDrawerWidth : _minimizedDrawerWidth,
                    child: _buildDrawer(context, true),
                  ),
                Expanded(
                  child: _buildDashboardContent(constraints),
                ),
              ],
            ),
          );
        },
      ),
      style: DrawerStyle.defaultStyle,
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
    );
  }

  Widget _buildDashboardContent(BoxConstraints constraints) {
    return Obx(() {
      switch (_drawerController.selectedRoute.value) {
        case '/dashboard':
          return _buildDashboardOverview(constraints);
        case '/roles_management':
          return const RolesManagementScreen();
        case '/users_management':
          return const UsersManagementScreen();
        case '/stores_management':
          return const StoresManagementScreen();
        case '/cms_pages':
          return const CMSPagesScreen();
        case '/employee_records':
          return const EmployeeRecordsScreen();
        case '/payroll':
          return const PayrollScreen();
        case '/onboarding_exit':
          return const OnboardingExitScreen();
        case '/leave_management':
          return const LeaveManagementScreen();
        case '/write_to_hr':
          return const WriteToHRScreen();
        case '/org_chart':
          return const OrgChartScreen();
        case '/ticketing':
          return const TicketingScreen();
        case '/communication_hub':
          return const CommunicationHubScreen();
        case '/audit_module':
          return const AuditModuleScreen();
        case '/store_visit':
          return const StoreVisitScreen();
        case '/sales_upload':
          return const SalesUploadScreen();
        case '/store_scorecard':
          return const StoreScorecardScreen();
        case '/attendance_pjp':
          return const AttendancePJPScreen();
        case '/task_manager':
          return const TaskManagerScreen();
        case '/inventory':
          return const InventoryScreen();
        case '/nlc_files':
          return const NLCFilesHubScreen();
        case '/approvals':
          return const ApprovalsScreen();
        case '/reports':
          return const ReportsScreen();
        case '/time_tracking':
          return const TimeTrackingScreen();
        case '/po_management':
          return const POManagementScreen();
        case '/profit_invoice':
          return const ProfitInvoiceScreen();
        case '/ess':
          return const ESSScreen();
        case '/field_force':
          return const FieldForceScreen();
        case '/manage_profile':
          return const ManageProfileScreen();
        // case '/dashboard_content':
        //   return const DashboardContent();
        default:
          return Center(
            child: Text(
              'Screen: ${_drawerController.selectedRoute.value}\n(Not implemented yet)',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
            ),
          );
      }
    });
  }

  Widget _buildDashboardOverview(BoxConstraints constraints) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard Overview',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Mumbai Region - October 3, 2025',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 1200
                  ? 4
                  : (constraints.maxWidth > 800 ? 2 : 1);
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  _buildStatCard(
                    'Open Tickets',
                    '5',
                    'IT: 2, HR: 3',
                    Icons.warning_amber_rounded,
                    const Color(0xFFF59E0B),
                  ),
                  _buildStatCard(
                    'Approvals Pending',
                    '3',
                    'Expenses: ₹10,000',
                    Icons.schedule,
                    const Color(0xFF8B5CF6),
                  ),
                  _buildStatCard(
                    'Overdue Tasks',
                    '2',
                    'Audit for Delhi Store',
                    Icons.check_circle_outline,
                    const Color(0xFFEF4444),
                  ),
                  _buildStatCard(
                    'New Products',
                    '3',
                    'Samsung S25, etc.',
                    Icons.inventory_2_outlined,
                    const Color(0xFF10B981),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildSalesChart()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildHygieneChart()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildSalesChart(),
                    const SizedBox(height: 16),
                    _buildHygieneChart(),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildAttendanceChart()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStockUtilizationChart()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTicketBreakdownChart()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildAttendanceChart(),
                    const SizedBox(height: 16),
                    _buildStockUtilizationChart(),
                    const SizedBox(height: 16),
                    _buildTicketBreakdownChart(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sales Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Mumbai Region',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '₹5,00,000',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const Text(
                    'Target: ₹6,00,000',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '83% achieved',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFD97706),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFE5E7EB),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${(value / 1000).toInt()}k',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7280),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = ['Oct 1', 'Oct 2', 'Oct 3', 'Oct 4', 'Today'];
                        if (value.toInt() >= 0 && value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[value.toInt()],
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 4,
                minY: 400000,
                maxY: 600000,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 420000),
                      const FlSpot(1, 450000),
                      const FlSpot(2, 480000),
                      const FlSpot(3, 500000),
                      const FlSpot(4, 500000),
                    ],
                    isCurved: true,
                    color: const Color(0xFF3B82F6),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFF3B82F6),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF3B82F6).withOpacity(0.2),
                          const Color(0xFF3B82F6).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 500000),
                      const FlSpot(1, 520000),
                      const FlSpot(2, 540000),
                      const FlSpot(3, 560000),
                      const FlSpot(4, 600000),
                    ],
                    isCurved: true,
                    color: const Color(0xFF10B981),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dashArray: [5, 5],
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Sales', const Color(0xFF3B82F6)),
              const SizedBox(width: 24),
              _buildLegendItem('Target', const Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHygieneChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hygiene Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Across 10 Stores',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '85%',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Good',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFE5E7EB),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7280),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'S${value.toInt() + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 100,
                barGroups: [
                  _buildBarGroup(0, 88),
                  _buildBarGroup(1, 92),
                  _buildBarGroup(2, 78),
                  _buildBarGroup(3, 95),
                  _buildBarGroup(4, 82),
                  _buildBarGroup(5, 89),
                  _buildBarGroup(6, 91),
                  _buildBarGroup(7, 86),
                  _buildBarGroup(8, 84),
                  _buildBarGroup(9, 90),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(  // Wrap first Column in Flexible
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Employee Attendance',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                      overflow: TextOverflow.ellipsis,  // Handle long text
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This Week',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                      overflow: TextOverflow.ellipsis,  // Handle long text
                    ),
                  ],
                ),
              ),
              Flexible(  // Wrap second Column in Flexible
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '92%',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                      overflow: TextOverflow.ellipsis,  // Handle long text
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Diwali Prep Impact',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                      overflow: TextOverflow.ellipsis,  // Handle long text
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFE5E7EB),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7280),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Today'];
                        if (value.toInt() >= 0 && value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[value.toInt()],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 85,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 95),
                      FlSpot(1, 93),
                      FlSpot(2, 91),
                      FlSpot(3, 94),
                      FlSpot(4, 89),
                      FlSpot(5, 92),
                      FlSpot(6, 92),
                    ],
                    isCurved: true,
                    color: const Color(0xFF8B5CF6),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFF8B5CF6),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockUtilizationChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Franchisee Stock',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Utilization Rate',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 50,
                  sections: [
                    PieChartSectionData(
                      value: 75,
                      color: const Color(0xFF3B82F6),
                      title: '75%',
                      radius: 35,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 25,
                      color: const Color(0xFFE5E7EB),
                      title: '25%',
                      radius: 35,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Column(
              children: [
                Text(
                  '75%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Stock in use',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketBreakdownChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ticket Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'By Department',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                  sections: [
                    PieChartSectionData(
                      value: 2,
                      color: const Color(0xFF3B82F6),
                      title: 'IT\n2',
                      radius: 75,
                      titleStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 3,
                      color: const Color(0xFF8B5CF6),
                      title: 'HR\n3',
                      radius: 75,
                      titleStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildTicketLegendItem('IT Support', const Color(0xFF3B82F6), '2'),
          const SizedBox(height: 8),
          _buildTicketLegendItem('HR Issues', const Color(0xFF8B5CF6), '3'),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double value) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: const Color(0xFF3B82F6),
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildTicketLegendItem(String label, Color color, String count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        Text(
          count,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context, bool isFixed) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF001E36), Color(0xFF003A5D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isDrawerExpanded ? 'Phonewale' : 'PW',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_isDrawerExpanded) ...[
                        const SizedBox(height: 4),
                        const Text(
                          'Dashboard Menu',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (isFixed)
                  IconButton(
                    icon: Icon(
                      _isDrawerExpanded ? Icons.chevron_left : Icons.chevron_right,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isDrawerExpanded = !_isDrawerExpanded;
                      });
                    },
                  ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms),
          Expanded(
            child: Obx(() => ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: _getMenuItems().map((item) {
                bool isSelected = _drawerController.selectedRoute.value == item.route;
                return ListTile(
                  leading: Icon(
                    item.icon ?? Icons.error, // Provide fallback icon
                    color: isSelected ? const Color(0xFF0B69FF) : const Color(0xFF6B7280),
                    size: 22,
                  ),
                  title: _isDrawerExpanded
                      ? Text(
                    item.title ?? 'Unknown', // Provide fallback title
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? const Color(0xFF0B69FF) : const Color(0xFF6B7280),
                    ),
                  )
                      : null,
                  onTap: () {
                    if (item.route != null) { // Check for non-null route
                      _drawerController.selectRoute(item.route);
                      if (!isFixed) ZoomDrawer.of(context)?.close();
                    }
                  },
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: _isDrawerExpanded ? 16.0 : 24.0,
                    vertical: 8.0,
                  ),
                  minLeadingWidth: _isDrawerExpanded ? 40.0 : 20.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0);
              }).toList(),
            )),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF001E36),
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                if (_isDrawerExpanded) ...[
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rajesh Kumar',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Super Admin',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7280),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<MenuItem> _getMenuItems() {
    final appStateController = Get.find<AppStateController>();
    return _getMenuItemsForRole(appStateController.currentRole ?? UserRole.superAdmin);
  }
}

// Menu Item Model
class MenuItem {
  final String title;
  final IconData icon;
  final String route;

  MenuItem(this.title, this.icon, this.route);
}

// Get Menu Items per Role
List<MenuItem> _getMenuItemsForRole(UserRole role) {
  switch (role) {
    case UserRole.superAdmin:
      return [
        MenuItem('Dashboard', Icons.dashboard, '/dashboard'),
        MenuItem('Roles Management', Icons.security, '/roles_management'),
        MenuItem('Users Management', Icons.people, '/users_management'),
        MenuItem('Stores Management', Icons.store, '/stores_management'),
        MenuItem('CMS Pages', Icons.pages, '/cms_pages'),
        MenuItem('Employee Records', Icons.person, '/employee_records'),
        MenuItem('Payroll & Compliance', Icons.money, '/payroll'),
        MenuItem('Onboarding & Exit', Icons.door_front_door, '/onboarding_exit'),
        MenuItem('Leave Management', Icons.calendar_today, '/leave_management'),
        MenuItem('Write to HR', Icons.mail, '/write_to_hr'),
        MenuItem('Organization Chart', Icons.schema, '/org_chart'),
        MenuItem('Ticketing & Support', Icons.support, '/ticketing'),
        MenuItem('Communication Hub', Icons.chat, '/communication_hub'),
        MenuItem('Audit Module', Icons.checklist, '/audit_module'),
        MenuItem('Store Visit & Logs', Icons.location_on, '/store_visit'),
        MenuItem('Sales Upload', Icons.upload, '/sales_upload'),
        MenuItem('Store Scorecard', Icons.score, '/store_scorecard'),
        MenuItem('Attendance & PJP', Icons.access_time, '/attendance_pjp'),
        MenuItem('Task/Project Manager', Icons.task, '/task_manager'),
        MenuItem('Inventory & Stock', Icons.inventory, '/inventory'),
        MenuItem('NLC & Files Hub', Icons.file_copy, '/nlc_files'),
        MenuItem('Approvals & Workflows', Icons.approval, '/approvals'),
        MenuItem('Reports & Analytics', Icons.analytics, '/reports'),
        MenuItem('Time Tracking', Icons.timer, '/time_tracking'),
        MenuItem('PO Management', Icons.receipt, '/po_management'),
        MenuItem('Profit Invoice', Icons.receipt_long, '/profit_invoice'),
        MenuItem('Employee Self-Service', Icons.self_improvement, '/ess'),
        MenuItem('Field Force Tracking', Icons.track_changes, '/field_force'),
        MenuItem('Manage Profile', Icons.manage_accounts, '/manage_profile'),
      ];
    case UserRole.adminHO:
      return [
        MenuItem('Dashboard', Icons.dashboard, '/dashboard'),
        MenuItem('Users Management', Icons.people, '/users_management'),
        MenuItem('Stores Management', Icons.store, '/stores_management'),
        MenuItem('Employee Records', Icons.person, '/employee_records'),
        MenuItem('Payroll & Compliance', Icons.money, '/payroll'),
        MenuItem('Onboarding & Exit', Icons.door_front_door, '/onboarding_exit'),
        MenuItem('Leave Management', Icons.calendar_today, '/leave_management'),
        MenuItem('Write to HR', Icons.mail, '/write_to_hr'),
        MenuItem('Organization Chart', Icons.schema, '/org_chart'),
        MenuItem('Ticketing & Support', Icons.support, '/ticketing'),
        MenuItem('Communication Hub', Icons.chat, '/communication_hub'),
        MenuItem('Audit Module', Icons.checklist, '/audit_module'),
        MenuItem('Store Visit & Logs', Icons.location_on, '/store_visit'),
        MenuItem('Sales Upload', Icons.upload, '/sales_upload'),
        MenuItem('Store Scorecard', Icons.score, '/store_scorecard'),
        MenuItem('Attendance & PJP', Icons.access_time, '/attendance_pjp'),
        MenuItem('Task/Project Manager', Icons.task, '/task_manager'),
        MenuItem('Inventory & Stock', Icons.inventory, '/inventory'),
        MenuItem('NLC & Files Hub', Icons.file_copy, '/nlc_files'),
        MenuItem('Approvals & Workflows', Icons.approval, '/approvals'),
        MenuItem('Reports & Analytics', Icons.analytics, '/reports'),
        MenuItem('Time Tracking', Icons.timer, '/time_tracking'),
        MenuItem('PO Management', Icons.receipt, '/po_management'),
        MenuItem('Profit Invoice', Icons.receipt_long, '/profit_invoice'),
        MenuItem('Employee Self-Service', Icons.self_improvement, '/ess'),
        MenuItem('Field Force Tracking', Icons.track_changes, '/field_force'),
        MenuItem('Manage Profile', Icons.manage_accounts, '/manage_profile'),
      ];
    case UserRole.storeAdmin:
      return [
        MenuItem('Dashboard', Icons.dashboard, '/dashboard'),
        MenuItem('Users Management', Icons.people, '/users_management'),
        MenuItem('Stores Management', Icons.store, '/stores_management'),
        MenuItem('Sales Upload', Icons.upload, '/sales_upload'),
        MenuItem('Store Scorecard', Icons.score, '/store_scorecard'),
        MenuItem('Inventory & Stock', Icons.inventory, '/inventory'),
        MenuItem('Attendance & PJP', Icons.access_time, '/attendance_pjp'),
        MenuItem('Employee Self-Service', Icons.self_improvement, '/ess'),
        MenuItem('Leave Management', Icons.calendar_today, '/leave_management'),
        MenuItem('Time Tracking', Icons.timer, '/time_tracking'),
        MenuItem('Write to HR', Icons.mail, '/write_to_hr'),
        MenuItem('Ticketing & Support', Icons.support, '/ticketing'),
        MenuItem('Communication Hub', Icons.chat, '/communication_hub'),
        MenuItem('Task/Project Manager', Icons.task, '/task_manager'),
        MenuItem('Approvals & Workflows', Icons.approval, '/approvals'),
        MenuItem('Reports & Analytics', Icons.analytics, '/reports'),
        MenuItem('PO Management', Icons.receipt, '/po_management'),
        MenuItem('Profit Invoice', Icons.receipt_long, '/profit_invoice'),
        MenuItem('Audit Module', Icons.checklist, '/audit_module'),
        MenuItem('Store Visit & Logs', Icons.location_on, '/store_visit'),
        MenuItem('Manage Profile', Icons.manage_accounts, '/manage_profile'),
      ];
    case UserRole.bmAM:
      return [
        MenuItem('Dashboard', Icons.dashboard, '/dashboard'),
        MenuItem('Audit Module', Icons.checklist, '/audit_module'),
        MenuItem('Store Visit & Logs', Icons.location_on, '/store_visit'),
        MenuItem('Attendance & PJP', Icons.access_time, '/attendance_pjp'),
        MenuItem('Field Force Tracking', Icons.track_changes, '/field_force'),
        MenuItem('Task/Project Manager', Icons.task, '/task_manager'),
        MenuItem('Sales Upload', Icons.upload, '/sales_upload'),
        MenuItem('Store Scorecard', Icons.score, '/store_scorecard'),
        MenuItem('Inventory & Stock', Icons.inventory, '/inventory'),
        MenuItem('Approvals & Workflows', Icons.approval, '/approvals'),
        MenuItem('Ticketing & Support', Icons.support, '/ticketing'),
        MenuItem('Communication Hub', Icons.chat, '/communication_hub'),
        MenuItem('Employee Self-Service', Icons.self_improvement, '/ess'),
        MenuItem('Leave Management', Icons.calendar_today, '/leave_management'),
        MenuItem('Time Tracking', Icons.timer, '/time_tracking'),
        MenuItem('Write to HR', Icons.mail, '/write_to_hr'),
        MenuItem('Reports & Analytics', Icons.analytics, '/reports'),
        MenuItem('Manage Profile', Icons.manage_accounts, '/manage_profile'),
      ];
    case UserRole.franchisee:
      return [
        MenuItem('Dashboard', Icons.dashboard, '/dashboard'),
        MenuItem('Inventory & Stock', Icons.inventory, '/inventory'),
        MenuItem('NLC & Files Hub', Icons.file_copy, '/nlc_files'),
        MenuItem('PO Management', Icons.receipt, '/po_management'),
        MenuItem('Profit Invoice', Icons.receipt_long, '/profit_invoice'),
        MenuItem('Sales Upload', Icons.upload, '/sales_upload'),
        MenuItem('Store Scorecard', Icons.score, '/store_scorecard'),
        MenuItem('Attendance & PJP', Icons.access_time, '/attendance_pjp'),
        MenuItem('Ticketing & Support', Icons.support, '/ticketing'),
        MenuItem('Communication Hub', Icons.chat, '/communication_hub'),
        MenuItem('Task/Project Manager', Icons.task, '/task_manager'),
        MenuItem('Approvals & Workflows', Icons.approval, '/approvals'),
        MenuItem('Reports & Analytics', Icons.analytics, '/reports'),
        MenuItem('Employee Self-Service', Icons.self_improvement, '/ess'),
        MenuItem('Leave Management', Icons.calendar_today, '/leave_management'),
        MenuItem('Time Tracking', Icons.timer, '/time_tracking'),
        MenuItem('Write to HR', Icons.mail, '/write_to_hr'),
        MenuItem('Manage Profile', Icons.manage_accounts, '/manage_profile'),
      ];
    case UserRole.storeStaff:
      return [
        MenuItem('Dashboard', Icons.dashboard, '/dashboard'),
        MenuItem('Employee Self-Service', Icons.self_improvement, '/ess'),
        MenuItem('Time Tracking & Attendance', Icons.timer, '/time_tracking'),
        MenuItem('Leave Management', Icons.calendar_today, '/leave_management'),
        MenuItem('Write to HR', Icons.mail, '/write_to_hr'),
        MenuItem('Sales Upload', Icons.upload, '/sales_upload'),
        MenuItem('Task/Project Manager', Icons.task, '/task_manager'),
        MenuItem('Approvals & Workflows', Icons.approval, '/approvals'),
        MenuItem('Ticketing & Support', Icons.support, '/ticketing'),
        MenuItem('Communication Hub', Icons.chat, '/communication_hub'),
        MenuItem('Manage Profile', Icons.manage_accounts, '/manage_profile'),
      ];
    case UserRole.externalAuditor:
      return [
        MenuItem('Dashboard', Icons.dashboard, '/dashboard'),
        MenuItem('Audit Module', Icons.checklist, '/audit_module'),
        MenuItem('Manage Profile', Icons.manage_accounts, '/manage_profile'),
      ];
    case UserRole.hr:
      return [
        MenuItem('Dashboard', Icons.dashboard, '/dashboard'),
        MenuItem('Employee Records', Icons.person, '/employee_records'),
        MenuItem('Payroll & Compliance', Icons.money, '/payroll'),
        MenuItem('Onboarding & Exit', Icons.door_front_door, '/onboarding_exit'),
        MenuItem('Leave Management', Icons.calendar_today, '/leave_management'),
        MenuItem('Organization Chart', Icons.schema, '/org_chart'),
        MenuItem('Write to HR', Icons.mail, '/write_to_hr'),
        MenuItem('Users Management', Icons.people, '/users_management'),
        MenuItem('Reports & Analytics', Icons.analytics, '/reports'),
        MenuItem('Manage Profile', Icons.manage_accounts, '/manage_profile'),
      ];
  }
}


// Roles Management (Improved design with expandable cards and edit dialog)
// Notes: Allows super admins to define roles and permissions. Expandable tiles show permissions as chips. Add/Edit dialog with checkboxes for permissions. Mock save updates local list. In backend, this would call API to save roles. Scalable for multiple roles.
class RolesManagementScreen extends StatefulWidget {
  const RolesManagementScreen({super.key});

  @override
  State<RolesManagementScreen> createState() => _RolesManagementScreenState();
}

class _RolesManagementScreenState extends State<RolesManagementScreen> {
  final List<Map<String, dynamic>> _roles = [
    {'name': 'BM', 'permissions': ['View Audits', 'Edit Visits', 'Approve Expenses']},
    {'name': 'Store Admin', 'permissions': ['Manage Staff', 'Upload Sales', 'View Inventory']},
    {'name': 'Franchisee', 'permissions': ['View Stock Limits', 'Send PO', 'Upload Invoices']},
    {'name': 'HR', 'permissions': ['Manage Payroll', 'Leaves', 'Feedbacks']},
    {'name': 'External Auditor', 'permissions': ['Log Audits', 'Restricted Access']},
    {'name': 'Super Admin', 'permissions': ['All Access', 'Manage Roles', 'Manage Users']},
    {'name': 'Store Staff', 'permissions': ['Upload Sales', 'View Tasks', 'Self-Service']},
  ];

  void _showEditRoleDialog(Map<String, dynamic>? role) {
    List<String> allPermissions = [
      'View Audits', 'Edit Visits', 'Approve Expenses', 'Manage Staff', 'Upload Sales', 'View Inventory',
      'View Stock Limits', 'Send PO', 'Upload Invoices', 'Manage Payroll', 'Leaves', 'Feedbacks',
      'Log Audits', 'All Access', 'Manage Roles', 'Manage Users', 'Self-Service',
    ];
    List<String> selected = List.from(role?['permissions'] ?? []);

    Get.dialog(
      AlertDialog(
        title: Text(role == null ? 'Add Role' : 'Edit Role: ${role['name']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (role == null)
                const TextField(
                  decoration: InputDecoration(labelText: 'Role Name', border: OutlineInputBorder()),
                ),
              const SizedBox(height: 16),
              const Text('Permissions:'),
              ...allPermissions.map((perm) => CheckboxListTile(
                title: Text(perm),
                value: selected.contains(perm),
                onChanged: (val) {
                  setState(() {
                    if (val!) selected.add(perm); else selected.remove(perm);
                  });
                },
              )),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              setState(() {
                if (role == null) {
                  _roles.add({'name': 'New Role', 'permissions': selected});
                } else {
                  role['permissions'] = selected;
                }
              });
              Get.snackbar('Success', 'Role Saved (Mock)');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roles Management')),
      body: ListView.builder(
        itemCount: _roles.length,
        itemBuilder: (context, index) {
          final role = _roles[index];
          return FadeInDown(
            child: ExpansionTile(
              leading: const Icon(Icons.security, color: Color(0xFF001E36)),
              title: Text(role['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${role['permissions'].length} Permissions'),
              children: [
                Wrap(
                  spacing: 8,
                  children: role['permissions'].map<Widget>((perm) => Chip(label: Text(perm))).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditRoleDialog(role)),
                      IconButton(icon: const Icon(Icons.delete), onPressed: () {
                        setState(() => _roles.removeAt(index));
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD35400),
        child: const Icon(Icons.add),
        onPressed: () => _showEditRoleDialog(null),
      ),
    );
  }
}

// Users Management (Improved with avatars, more data, edit dialog)
// Notes: Manages all users connected to Phonewale (scalable to 30+ stores/franchises). List/DataTable shows users with avatars. Edit dialog for details. Add new user button. In backend, API for CRUD. Role-based filter (e.g., store admin sees only staff).
class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  final List<Map<String, dynamic>> _users = [
    {'id': 'U001', 'name': 'Rajesh Kumar', 'role': 'BM', 'store': 'Mumbai Store1', 'status': 'Active', 'avatarSeed': 'user1'},
    {'id': 'U002', 'name': 'Priya Sharma', 'role': 'Store Admin', 'store': 'Delhi Store1', 'status': 'Active', 'avatarSeed': 'user2'},
    {'id': 'U003', 'name': 'Amit Patel', 'role': 'Franchisee', 'store': 'Pune Franchise1', 'status': 'Inactive', 'avatarSeed': 'user3'},
    {'id': 'U004', 'name': 'Sunita Singh', 'role': 'HR', 'store': 'Head Office', 'status': 'Active', 'avatarSeed': 'user4'},
    {'id': 'U005', 'name': 'Vikram Reddy', 'role': 'Store Staff', 'store': 'Bangalore Store1', 'status': 'Active', 'avatarSeed': 'user5'},
    {'id': 'U006', 'name': 'Neha Gupta', 'role': 'External Auditor', 'store': 'Mumbai', 'status': 'Active', 'avatarSeed': 'user6'},
    {'id': 'U007', 'name': 'Rahul Verma', 'role': 'Admin HO', 'store': 'Head Office', 'status': 'Active', 'avatarSeed': 'user7'},
    {'id': 'U008', 'name': 'Anita Desai', 'role': 'Store Admin', 'store': 'Mumbai Store2', 'status': 'Active', 'avatarSeed': 'user8'},
    {'id': 'U009', 'name': 'Suresh Nair', 'role': 'Franchisee', 'store': 'Chennai Franchise1', 'status': 'Active', 'avatarSeed': 'user9'},
    {'id': 'U010', 'name': 'Meera Joshi', 'role': 'Store Staff', 'store': 'Delhi Store2', 'status': 'Inactive', 'avatarSeed': 'user10'},
    {'id': 'U011', 'name': 'Karan Singh', 'role': 'BM', 'store': 'Pune Store1', 'status': 'Active', 'avatarSeed': 'user11'},
  ];

  void _showEditUserDialog(Map<String, dynamic>? user) {
    Get.dialog(
      AlertDialog(
        title: Text(user == null ? 'Add User' : 'Edit User: ${user['name']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                controller: TextEditingController(text: user?['name'] ?? ''),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                hint: const Text('Role'),
                value: user?['role'],
                items: UserRole.values.map((r) => DropdownMenuItem(value: r.name, child: Text(r.name.toUpperCase()))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Store/Location', border: OutlineInputBorder()),
                controller: TextEditingController(text: user?['store'] ?? ''),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                hint: const Text('Status'),
                value: user?['status'],
                items: ['Active', 'Inactive'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              setState(() {
                if (user == null) {
                  _users.add({
                    'id': 'U${_users.length + 1}',
                    'name': 'New User',
                    'role': 'Store Staff',
                    'store': 'New Store',
                    'status': 'Active',
                    'avatarSeed': 'newuser',
                  });
                }
              });
              Get.snackbar('Success', 'User Saved (Mock)');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users Management')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;
          return isWide
              ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('User ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Store/Location')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _users.map((user) {
                    return DataRow(cells: [
                      DataCell(Text(user['id'])),
                      DataCell(Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage('https://picsum.photos/seed/${user['avatarSeed']}/50/50'),
                          ),
                          const SizedBox(width: 8),
                          Text(user['name']),
                        ],
                      )),
                      DataCell(Text(user['role'])),
                      DataCell(Text(user['store'])),
                      DataCell(Text(user['status'])),
                      DataCell(Row(children: [
                        IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditUserDialog(user)),
                        IconButton(icon: const Icon(Icons.lock), onPressed: () {}),
                      ])),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          )
              : ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return Animate(
                effects: const [FlipEffect()],
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('https://picsum.photos/seed/${user['avatarSeed']}/50/50'),
                    ),
                    title: Text(user['name']),
                    subtitle: Text('${user['role']} - ${user['store']} - ${user['status']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditUserDialog(user)),
                        IconButton(icon: const Icon(Icons.lock), onPressed: () {}),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD35400),
        child: const Icon(Icons.add),
        onPressed: () => _showEditUserDialog(null),
      ),
    );
  }
}

// Stores Management Screen (for scalability, mock 5 stores, can expand to 30+)
// Notes: Manages franchise stores (scalable to 30+). List of stores with details. Add/Edit/Delete buttons. In backend, API for store CRUD. Role-based: Admins manage all, store admins view own.
class StoresManagementScreen extends StatelessWidget {
  const StoresManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stores = [
      {'name': 'Mumbai Store1', 'location': 'Mumbai', 'manager': 'Rajesh Kumar', 'status': 'Active'},
      {'name': 'Delhi Store1', 'location': 'Delhi', 'manager': 'Priya Sharma', 'status': 'Active'},
      {'name': 'Pune Franchise1', 'location': 'Pune', 'manager': 'Amit Patel', 'status': 'Active'},
      {'name': 'Bangalore Store1', 'location': 'Bangalore', 'manager': 'Vikram Reddy', 'status': 'Active'},
      {'name': 'Chennai Franchise1', 'location': 'Chennai', 'manager': 'Suresh Nair', 'status': 'Active'},
      // Expandable to 30+
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Stores Management')),
      body: ListView.builder(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          return SlideInRight(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.store, color: Color(0xFF001E36)),
                title: Text(store['name']),
                subtitle: Text('Location: ${store['location']} - Manager: ${store['manager']} - Status: ${store['status']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () {
                      Get.snackbar('Edit', 'Edit store (Mock)');
                    }),
                    IconButton(icon: const Icon(Icons.delete), onPressed: () {
                      Get.snackbar('Delete', 'Store deleted (Mock)');
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD35400),
        child: const Icon(Icons.add),
        onPressed: () {
          Get.snackbar('Add', 'New store added (Mock)');
        },
      ),
    );
  }
}

// CMS Pages
// Notes: Admins manage static pages like Terms, Privacy. Text fields for editing content. Save button mocks update. In backend, API to save CMS content. Users view these in manage profile screen.
class CMSPagesScreen extends StatelessWidget {
  const CMSPagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CMS Pages')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Manage CMS Pages (Terms, Privacy, etc.)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            BounceInDown(
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Terms and Conditions',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('Mock Content: Phonewale Pvt Ltd, Mumbai. All rights reserved. Updated Oct 03, 2025.', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            BounceInDown(
              delay: const Duration(milliseconds: 200),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Privacy Policy',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('Mock Content: We respect your privacy. Data protected under Indian laws.', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            BounceInDown(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'FAQs',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('Mock: Q1: How to reset password? A: Use forgot password link.', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            BounceInDown(
              delay: const Duration(milliseconds: 600),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Contact Us',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('Mock: support@phonewale.in', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            BounceInDown(
              delay: const Duration(milliseconds: 800),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'About Us',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('Mock: Leading mobile retailer in India.', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            GFButton(
              onPressed: () {
                Get.snackbar('Success', 'CMS Updated (Mock)');
              },
              text: 'Save Changes',
              icon: const Icon(Icons.save),
              color: const Color(0xFFD35400),
              fullWidthButton: true,
            ),
          ],
        ),
      ),
    );
  }
}

// Employee Records
// Notes: Centralized database for employee details. DataTable shows profiles with docs. View button for details. Add button for new employees. In backend, API for employee CRUD, document storage.
class EmployeeRecordsScreen extends StatelessWidget {
  const EmployeeRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Records')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Emp ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Location')),
                    DataColumn(label: Text('Docs')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('E001')),
                      DataCell(Text('Rajesh Kumar')),
                      DataCell(Text('BM')),
                      DataCell(Text('Mumbai')),
                      DataCell(Text('Aadhaar, PAN Uploaded')),
                      DataCell(IconButton(icon: const Icon(Icons.visibility), onPressed: () {
                        Get.snackbar('View', 'Employee details (Mock)');
                      })),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('E002')),
                      DataCell(Text('Priya Sharma')),
                      DataCell(Text('Store Admin')),
                      DataCell(Text('Delhi')),
                      DataCell(Text('Offer Letter, ID Card')),
                      DataCell(IconButton(icon: const Icon(Icons.visibility), onPressed: () {
                        Get.snackbar('View', 'Employee details (Mock)');
                      })),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('E003')),
                      DataCell(Text('Amit Patel')),
                      DataCell(Text('Franchisee')),
                      DataCell(Text('Pune')),
                      DataCell(Text('Compliance Records')),
                      DataCell(IconButton(icon: const Icon(Icons.visibility), onPressed: () {
                        Get.snackbar('View', 'Employee details (Mock)');
                      })),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('E004')),
                      DataCell(Text('Sunita Singh')),
                      DataCell(Text('HR')),
                      DataCell(Text('Head Office')),
                      DataCell(Text('All Docs Complete')),
                      DataCell(IconButton(icon: const Icon(Icons.visibility), onPressed: () {
                        Get.snackbar('View', 'Employee details (Mock)');
                      })),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('E005')),
                      DataCell(Text('Vikram Reddy')),
                      DataCell(Text('Store Staff')),
                      DataCell(Text('Bangalore')),
                      DataCell(Text('Aadhaar Pending')),
                      DataCell(IconButton(icon: const Icon(Icons.visibility), onPressed: () {
                        Get.snackbar('View', 'Employee details (Mock)');
                      })),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('E006')),
                      DataCell(Text('Neha Gupta')),
                      DataCell(Text('External Auditor')),
                      DataCell(Text('Chennai')),
                      DataCell(Text('PAN Uploaded')),
                      DataCell(IconButton(icon: const Icon(Icons.visibility), onPressed: () {
                        Get.snackbar('View', 'Employee details (Mock)');
                      })),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('E007')),
                      DataCell(Text('Rahul Verma')),
                      DataCell(Text('Admin HO')),
                      DataCell(Text('Head Office')),
                      DataCell(Text('All Docs')),
                      DataCell(IconButton(icon: const Icon(Icons.visibility), onPressed: () {
                        Get.snackbar('View', 'Employee details (Mock)');
                      })),
                    ]),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD35400),
        child: const Icon(Icons.add),
        onPressed: () {
          Get.snackbar('Add', 'New employee added (Mock)');
        },
      ),
    );
  }
}

// Payroll & Compliance
// Notes: Processes salaries with configurable heads. DataTable for payroll details. Generate buttons for forms. Compliance section shows filings. Loan management list. In backend, API for payroll calculation, compliance filings.
class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payroll & Compliance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Salary Processing (Oct 2025)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Emp ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Basic')),
                      DataColumn(label: Text('HRA')),
                      DataColumn(label: Text('PF Deduction')),
                      DataColumn(label: Text('Net Pay')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('E001')),
                        DataCell(Text('Rajesh Kumar')),
                        DataCell(Text('₹30,000')),
                        DataCell(Text('₹12,000')),
                        DataCell(Text('₹3,600')),
                        DataCell(Text('₹38,400')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('E002')),
                        DataCell(Text('Priya Sharma')),
                        DataCell(Text('₹25,000')),
                        DataCell(Text('₹10,000')),
                        DataCell(Text('₹3,000')),
                        DataCell(Text('₹32,000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('E003')),
                        DataCell(Text('Amit Patel')),
                        DataCell(Text('₹28,000')),
                        DataCell(Text('₹11,200')),
                        DataCell(Text('₹3,360')),
                        DataCell(Text('₹35,840')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('E004')),
                        DataCell(Text('Sunita Singh')),
                        DataCell(Text('₹35,000')),
                        DataCell(Text('₹14,000')),
                        DataCell(Text('₹4,200')),
                        DataCell(Text('₹44,800')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('E005')),
                        DataCell(Text('Vikram Reddy')),
                        DataCell(Text('₹22,000')),
                        DataCell(Text('₹8,800')),
                        DataCell(Text('₹2,640')),
                        DataCell(Text('₹28,160')),
                      ]),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            GFButton(
              onPressed: () {
                Get.snackbar('Success', 'Form 16 Generated (Mock)');
              },
              text: 'Generate Form 16 / 12BB',
              icon: const Icon(Icons.download),
              color: const Color(0xFFD35400),
              fullWidthButton: true,
            ),
            const SizedBox(height: 16),
            const Text('Statutory Compliance: PF, ESI, TDS Filed for Q3 2025'),
            const SizedBox(height: 16),
            const Text('Loan & Advance Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const ListTile(title: Text('Rajesh Kumar: EMI ₹2,000 - Remaining 5 months')),
            const ListTile(title: Text('Priya Sharma: Advance ₹5,000 - Recovered')),
          ],
        ),
      ),
    );
  }
}

// Onboarding & Exit Management
// Notes: Digital workflows for onboarding (forms, docs, eSignatures) and exit (clearance, settlement). ListTiles for pending processes. Finalize buttons mock completion, freeze user ID on exit. In backend, workflow API, document archive.
class OnboardingExitScreen extends StatelessWidget {
  const OnboardingExitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding & Exit Management')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Onboarding Workflow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(child: const ListTile(
              title: Text('New Hire: Priya Sharma'),
              subtitle: Text('Documents: Aadhaar Uploaded, PAN Pending - Start Date: Oct 10, 2025'),
            )).animate().fadeIn(duration: 600.ms),
            Card(child: const ListTile(
              title: Text('New Hire: Vikram Reddy'),
              subtitle: Text('All Docs Complete - eSignature Done'),
            )).animate().fadeIn(delay: 200.ms, duration: 600.ms),
            Card(child: const ListTile(
              title: Text('New Hire: Neha Gupta'),
              subtitle: Text('Forms Submitted, Letters Generated'),
            )).animate().fadeIn(delay: 400.ms, duration: 600.ms),
            const SizedBox(height: 16),
            GFButton(
              onPressed: () {
                Get.snackbar('Success', 'Onboarding Completed (Mock)');
              },
              text: 'Complete Onboarding',
              icon: const Icon(Icons.check),
              color: const Color(0xFFD35400),
              fullWidthButton: true,
            ),
            const SizedBox(height: 32),
            const Text('Exit Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(child: const ListTile(
              title: Text('Exit: Amit Patel'),
              subtitle: Text('Clearance: HR Approved, Finance Pending - Last Date: Oct 31, 2025 - User Frozen'),
            )).animate().slideX(duration: 600.ms),
            Card(child: const ListTile(
              title: Text('Exit: Sunita Singh'),
              subtitle: Text('Settlement Done, Letter Generated'),
            )).animate().slideX(delay: 200.ms, duration: 600.ms),
            Card(child: const ListTile(
              title: Text('Exit: Rahul Verma'),
              subtitle: Text('Archive Ready, Compliance Checked'),
            )).animate().slideX(delay: 400.ms, duration: 600.ms),
            const SizedBox(height: 16),
            GFButton(
              onPressed: () {
                Get.snackbar('Success', 'Exit Process Completed (Mock)');
              },
              text: 'Finalize Exit',
              icon: const Icon(Icons.exit_to_app),
              color: const Color(0xFFD35400),
              fullWidthButton: true,
            ),
          ],
        ),
      ),
    );
  }
}

// Leave Management & Holiday Lists
// Notes: Employees apply for leaves with multi-level approval. Holiday calendar state-wise. Leave balances auto-update. DataTable for requests with approve/reject. In backend, API for leave CRUD, notifications.
class LeaveManagementScreen extends StatelessWidget {
  const LeaveManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Management & Holiday Lists')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Holiday Calendar 2025 (Maharashtra)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(child: const ListTile(title: Text('Diwali: Oct 31, 2025'))).animate().fadeIn(),
            Card(child: const ListTile(title: Text('Christmas: Dec 25, 2025'))).animate().fadeIn(delay: 100.ms),
            Card(child: const ListTile(title: Text('Republic Day: Jan 26, 2026'))).animate().fadeIn(delay: 200.ms),
            Card(child: const ListTile(title: Text('Holi: Mar 14, 2026'))).animate().fadeIn(delay: 300.ms),
            Card(child: const ListTile(title: Text('Independence Day: Aug 15, 2025'))).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 16),
            const Text('Leave Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Emp ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Dates')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('E001')),
                        DataCell(Text('Rajesh Kumar')),
                        DataCell(Text('Sick Leave')),
                        DataCell(Text('Oct 04 - Oct 05, 2025')),
                        DataCell(Text('Pending')),
                        DataCell(Row(children: [TextButton(child: const Text('Approve'), onPressed: () {}), TextButton(child: const Text('Reject'), onPressed: () {})])),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('E002')),
                        DataCell(Text('Priya Sharma')),
                        DataCell(Text('Casual Leave')),
                        DataCell(Text('Oct 30 - Nov 01, 2025 (Diwali)')),
                        DataCell(Text('Approved')),
                        DataCell(TextButton(child: const Text('View'), onPressed: () {})),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('E003')),
                        DataCell(Text('Amit Patel')),
                        DataCell(Text('Annual Leave')),
                        DataCell(Text('Dec 24 - Dec 26, 2025')),
                        DataCell(Text('Pending')),
                        DataCell(Row(children: [TextButton(child: const Text('Approve'), onPressed: () {}), TextButton(child: const Text('Reject'), onPressed: () {})])),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('E004')),
                        DataCell(Text('Sunita Singh')),
                        DataCell(Text('Maternity Leave')),
                        DataCell(Text('Nov 01 - Apr 01, 2026')),
                        DataCell(Text('Approved')),
                        DataCell(TextButton(child: const Text('View'), onPressed: () {})),
                      ]),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text('Apply for Leave', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: 'Leave Type', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: 'Dates (e.g., Oct 10 - Oct 12)', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            GFButton(
              onPressed: () {
                Get.snackbar('Success', 'Leave Applied (Mock)');
              },
              text: 'Submit Leave Request',
              icon: const Icon(Icons.send),
              color: const Color(0xFFD35400),
              fullWidthButton: true,
            ),
          ],
        ),
      ),
    );
  }
}

// Add similar updates for all other screens... Due to length, I'll stop here and note that the pattern is applied similarly to all screens: add animations with flutter_animate or animate_do, use GFButton for buttons, use CachedNetworkImage for images, use Syncfusion charts if needed for advanced charts (replace fl_chart in _buildCard if desired), ensure responsiveness with LayoutBuilder.

/// Note: The full code would be too long for this response. The pattern is to wrap widgets with Animate or FadeInUp, etc., use GFButton for buttons, and ensure the theme is applied. For charts, you can replace LineChart with SfCartesianChart from syncfusion if needed.
// Write to HR
// Notes: Employees can submit queries or feedback to HR. Form with subject, message, and file upload. Submit button mocks sending. HR sees tickets in Ticketing screen. In backend, API for ticket creation, file storage.
class WriteToHRScreen extends StatelessWidget {
  const WriteToHRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write to HR')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Submit Query/Feedback to HR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: const TextField(
                decoration: InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Message', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: GFButton(
                onPressed: () {
                  // Mock file upload
                  Get.snackbar('Success', 'File Uploaded (Mock)');
                },
                text: 'Upload Attachment',
                icon: const Icon(Icons.attach_file),
                color: const Color(0xFF001E36),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Query Sent to HR (Mock)');
                },
                text: 'Submit to HR',
                icon: const Icon(Icons.send),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Previous Queries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Salary Issue - Oct 01, 2025'),
                subtitle: const Text('Status: Resolved - Response: Please check payslip.'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Get.snackbar('View', 'Query details (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}

// Organization Chart
// Notes: Displays company hierarchy (scalable to 30+ stores). Uses a simple tree view with expandable nodes. In backend, API for org structure. Role-based: HR/Admins see all, others see limited view.
class OrgChartScreen extends StatelessWidget {
  const OrgChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organization Chart')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Company Hierarchy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ExpansionTile(
              leading: const Icon(Icons.person, color: Color(0xFF001E36)),
              title: const Text('CEO - Anil Gupta'),
              children: [
                ExpansionTile(
                  leading: const Icon(Icons.person_outline, color: Color(0xFF001E36)),
                  title: const Text('Head Office - Admin HO'),
                  children: [
                    ListTile(
                      title: const Text('HR - Sunita Singh'),
                      trailing: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          Get.snackbar('Details', 'HR Profile (Mock)');
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Admin - Rahul Verma'),
                      trailing: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          Get.snackbar('Details', 'Admin Profile (Mock)');
                        },
                      ),
                    ),
                  ],
                ).animate().slideX(delay: 200.ms),
                ExpansionTile(
                  leading: const Icon(Icons.store, color: Color(0xFF001E36)),
                  title: const Text('Mumbai Region - BM Rajesh Kumar'),
                  children: [
                    ListTile(
                      title: const Text('Mumbai Store1 - Priya Sharma'),
                      trailing: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          Get.snackbar('Details', 'Store Admin Profile (Mock)');
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Mumbai Store2 - Anita Desai'),
                      trailing: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          Get.snackbar('Details', 'Store Admin Profile (Mock)');
                        },
                      ),
                    ),
                  ],
                ).animate().slideX(delay: 400.ms),
                ExpansionTile(
                  leading: const Icon(Icons.store, color: Color(0xFF001E36)),
                  title: const Text('Pune Franchise - Amit Patel'),
                  children: [
                    ListTile(
                      title: const Text('Store Staff - Vikram Reddy'),
                      trailing: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          Get.snackbar('Details', 'Staff Profile (Mock)');
                        },
                      ),
                    ),
                  ],
                ).animate().slideX(delay: 600.ms),
              ],
            ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }
}

// Ticketing & Support
// Notes: Centralized ticketing for IT, HR, etc. DataTable for tickets with priority and status. Filter by category. Raise ticket form. In backend, API for ticket CRUD, notifications to assignees.
class TicketingScreen extends StatelessWidget {
  const TicketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticketing & Support')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Raise New Ticket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: const TextField(
                decoration: InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: DropdownButton<String>(
                hint: const Text('Category'),
                items: ['IT', 'HR', 'Maintenance', 'Finance'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Ticket Raised (Mock)');
                },
                text: 'Raise Ticket',
                icon: const Icon(Icons.send),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Open Tickets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Ticket ID')),
                      DataColumn(label: Text('Subject')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Priority')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('T001')),
                        DataCell(Text('Laptop Issue')),
                        DataCell(Text('IT')),
                        DataCell(Text('High')),
                        DataCell(Text('Open')),
                        DataCell(IconButton(icon: const Icon(Icons.visibility), onPressed: () {
                          Get.snackbar('View', 'Ticket Details (Mock)');
                        })),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('T002')),
                        DataCell(Text('Salary Query')),
                        DataCell(Text('HR')),
                        DataCell(Text('Medium')),
                        DataCell(Text('Resolved')),
                        DataCell(IconButton(icon: const Icon(Icons.visibility), onPressed: () {
                          Get.snackbar('View', 'Ticket Details (Mock)');
                        })),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('T003')),
                        DataCell(Text('Store AC Failure')),
                        DataCell(Text('Maintenance')),
                        DataCell(Text('High')),
                        DataCell(Text('Open')),
                        DataCell(IconButton(icon: const Icon(Icons.visibility), onPressed: () {
                          Get.snackbar('View', 'Ticket Details (Mock)');
                        })),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Communication Hub
// Notes: For announcements, notices, and circulars. List for sent/received messages with read status. Form to send new announcements. In backend, API for messaging, read tracking, and notifications.
class CommunicationHubScreen extends StatelessWidget {
  const CommunicationHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Communication Hub')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send Announcement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: const TextField(
                decoration: InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: DropdownButton<String>(
                hint: const Text('Target Audience'),
                items: ['All Employees', 'Store Admins', 'Franchisees', 'BM/AM'].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Message', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Announcement Sent (Mock)');
                },
                text: 'Send Announcement',
                icon: const Icon(Icons.send),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Received Announcements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Diwali Policy Update - Oct 01, 2025'),
                subtitle: const Text('Read: Yes - From: HR'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Get.snackbar('View', 'Announcement Details (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 800.ms),
            Card(
              child: ListTile(
                title: const Text('New Product Launch - Sep 30, 2025'),
                subtitle: const Text('Read: No - From: Admin HO'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Get.snackbar('View', 'Announcement Details (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}

// Audit Module
// Notes: For external auditors and BMs to log audits. Form for scores and observations. List of past audits. In backend, API for audit submission, photos, and reporting.
class AuditModuleScreen extends StatelessWidget {
  const AuditModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audit Module')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Log New Audit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: DropdownButton<String>(
                hint: const Text('Select Store'),
                items: ['Mumbai Store1', 'Delhi Store1', 'Pune Franchise1'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Hygiene Score (0-100)', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Financial Score (0-100)', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Observations', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Photo Uploaded (Mock)');
                },
                text: 'Upload Photos',
                icon: const Icon(Icons.camera_alt),
                color: const Color(0xFF001E36),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Audit Submitted (Mock)');
                },
                text: 'Submit Audit',
                icon: const Icon(Icons.send),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Past Audits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Mumbai Store1 - Sep 25, 2025'),
                subtitle: const Text('Hygiene: 85%, Financial: 90%'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Get.snackbar('View', 'Audit Details (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 1200.ms),
          ],
        ),
      ),
    );
  }
}

// Store Visit & Logs
// Notes: BMs log store visits with PJP compliance. Form for visit details and photos. List of past visits. In backend, API for visit logs, GPS verification, and photos.
class StoreVisitScreen extends StatelessWidget {
  const StoreVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Visit & Logs')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Log New Visit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: DropdownButton<String>(
                hint: const Text('Select Store'),
                items: ['Mumbai Store1', 'Delhi Store1', 'Pune Franchise1'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Visit Date', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Notes', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Photo Uploaded (Mock)');
                },
                text: 'Upload Photos',
                icon: const Icon(Icons.camera_alt),
                color: const Color(0xFF001E36),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Visit Logged (Mock)');
                },
                text: 'Log Visit',
                icon: const Icon(Icons.send),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Visit History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Mumbai Store1 - Sep 20, 2025'),
                subtitle: const Text('PJP Compliance: 90%'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Get.snackbar('View', 'Visit Details (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}

// Sales Upload
// Notes: Staff upload daily sales with details (brand, VAS). Form with file upload. List of past uploads. In backend, API for sales data, validation, and integration with inventory.
class SalesUploadScreen extends StatelessWidget {
  const SalesUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Upload')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Upload Daily Sales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: const TextField(
                decoration: InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Total Sales (₹)', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Brand Breakdown (e.g., Samsung: ₹50,000)', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: const TextField(
                decoration: InputDecoration(labelText: 'VAS Sales (₹)', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Sales File Uploaded (Mock)');
                },
                text: 'Upload Sales File',
                icon: const Icon(Icons.upload_file),
                color: const Color(0xFF001E36),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Sales Uploaded (Mock)');
                },
                text: 'Submit Sales',
                icon: const Icon(Icons.send),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Past Uploads', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Oct 02, 2025 - Mumbai Store1'),
                subtitle: const Text('Total: ₹1,00,000 (Samsung: ₹60,000, VAS: ₹10,000)'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Get.snackbar('View', 'Sales Details (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 1200.ms),
          ],
        ),
      ),
    );
  }
}

// Store Scorecard
// Notes: Displays store performance metrics (sales, hygiene, compliance). Syncfusion chart for trends. Filter by time/store. In backend, API for scorecard data, aggregated from sales/audits.
class StoreScorecardScreen extends StatelessWidget {
  const StoreScorecardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Scorecard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Store Performance (Oct 2025)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: DropdownButton<String>(
                hint: const Text('Select Store'),
                items: ['Mumbai Store1', 'Delhi Store1', 'Pune Franchise1'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: SizedBox(
                height: 200,
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  series: <CartesianSeries<Map<String, dynamic>, String>>[
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: [
                        {'month': 'Jul', 'sales': 500000},
                        {'month': 'Aug', 'sales': 600000},
                        {'month': 'Sep', 'sales': 550000},
                        {'month': 'Oct', 'sales': 700000},
                      ],
                      xValueMapper: (data, _) => data['month'] as String,
                      yValueMapper: (data, _) => data['sales'] as num,
                      color: const Color(0xFFD35400),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const Text('Key Metrics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Sales Achievement'),
                subtitle: const Text('₹7,00,000 / Target ₹8,00,000'),
              ),
            ).animate().fadeIn(delay: 600.ms),
            Card(
              child: ListTile(
                title: const Text('Hygiene Score'),
                subtitle: const Text('88% (Last Audit: Sep 25, 2025)'),
              ),
            ).animate().fadeIn(delay: 800.ms),
            Card(
              child: ListTile(
                title: const Text('Compliance'),
                subtitle: const Text('95% (All Filings Done)'),
              ),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}

// Attendance & PJP
// Notes: Tracks attendance and Planned Journey Plan (PJP) for BMs/staff. Form for check-in/out with GPS. DataTable for records. In backend, API for attendance, GPS validation.
class AttendancePJPScreen extends StatelessWidget {
  const AttendancePJPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance & PJP')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mark Attendance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Check-In Recorded (Mock, GPS: Mumbai)');
                },
                text: 'Check-In',
                icon: const Icon(Icons.login),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Check-Out Recorded (Mock, GPS: Mumbai)');
                },
                text: 'Check-Out',
                icon: const Icon(Icons.logout),
                color: const Color(0xFF001E36),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('PJP Planning', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Store to Visit', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'PJP Planned (Mock)');
                },
                text: 'Submit PJP',
                icon: const Icon(Icons.send),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Attendance Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Employee')),
                      DataColumn(label: Text('Check-In')),
                      DataColumn(label: Text('Check-Out')),
                      DataColumn(label: Text('Location')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('Oct 02, 2025')),
                        DataCell(Text('Rajesh Kumar')),
                        DataCell(Text('09:00 AM')),
                        DataCell(Text('06:00 PM')),
                        DataCell(Text('Mumbai Store1')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Oct 02, 2025')),
                        DataCell(Text('Priya Sharma')),
                        DataCell(Text('09:30 AM')),
                        DataCell(Text('05:30 PM')),
                        DataCell(Text('Delhi Store1')),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Task/Project Manager
// Notes: Assigns and tracks tasks/projects. Form for new tasks with assignees. List of tasks with status. In backend, API for task CRUD, notifications.
class TaskManagerScreen extends StatelessWidget {
  const TaskManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task/Project Manager')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create New Task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: const TextField(
                decoration: InputDecoration(labelText: 'Task Title', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: DropdownButton<String>(
                hint: const Text('Assignee'),
                items: ['Rajesh Kumar', 'Priya Sharma', 'Amit Patel'].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Due Date', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Task Assigned (Mock)');
                },
                text: 'Assign Task',
                icon: const Icon(Icons.send),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Task List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Inventory Check - Mumbai Store1'),
                subtitle: const Text('Assignee: Priya Sharma - Due: Oct 05, 2025 - Status: Pending'),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    Get.snackbar('Success', 'Task Marked Complete (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}

// Inventory & Stock
// Notes: Tracks stock across stores/franchisees. Form to update stock. DataTable for stock levels. In backend, API for inventory CRUD, sync with sales.
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory & Stock')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Update Stock', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: DropdownButton<String>(
                hint: const Text('Select Store'),
                items: ['Mumbai Store1', 'Delhi Store1', 'Pune Franchise1'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Product (e.g., Samsung S25)', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Stock Updated (Mock)');
                },
                text: 'Update Stock',
                icon: const Icon(Icons.send),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Stock Levels', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Store')),
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Last Updated')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('Mumbai Store1')),
                        DataCell(Text('Samsung S25')),
                        DataCell(Text('50')),
                        DataCell(Text('Oct 02, 2025')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Delhi Store1')),
                        DataCell(Text('iPhone 16')),
                        DataCell(Text('30')),
                        DataCell(Text('Oct 01, 2025')),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// NLC & Files Hub
// Notes: Centralized hub for notices, licenses, contracts. Upload form for new files. List with download/view options. In backend, API for file storage, access control.
class NLCFilesHubScreen extends StatelessWidget {
  const NLCFilesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NLC & Files Hub')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Upload New File', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: const TextField(
                decoration: InputDecoration(labelText: 'File Name', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: DropdownButton<String>(
                hint: const Text('Category'),
                items: ['Notice', 'License', 'Contract'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'File Uploaded (Mock)');
                },
                text: 'Upload File',
                icon: const Icon(Icons.upload_file),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('File Repository', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Diwali Notice 2025'),
                subtitle: const Text('Category: Notice - Uploaded: Oct 01, 2025'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    Get.snackbar('Success', 'File Downloaded (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 600.ms),
            Card(
              child: ListTile(
                title: const Text('Franchise License - Pune'),
                subtitle: const Text('Category: License - Uploaded: Sep 15, 2025'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    Get.snackbar('Success', 'File Downloaded (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}

// Approvals & Workflows
// Notes: Manages multi-level approvals (leaves, expenses, etc.). DataTable for pending approvals with approve/reject buttons. In backend, API for workflow management, notifications.
class ApprovalsScreen extends StatelessWidget {
  const ApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approvals & Workflows')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pending Approvals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Request ID')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Requested By')),
                      DataColumn(label: Text('Details')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('R001')),
                        DataCell(Text('Leave')),
                        DataCell(Text('Rajesh Kumar')),
                        DataCell(Text('Oct 04 - Oct 05, 2025')),
                        DataCell(Row(children: [
                          TextButton(child: const Text('Approve'), onPressed: () {
                            Get.snackbar('Success', 'Approved (Mock)');
                          }),
                          TextButton(child: const Text('Reject'), onPressed: () {
                            Get.snackbar('Success', 'Rejected (Mock)');
                          }),
                        ])),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('R002')),
                        DataCell(Text('Expense')),
                        DataCell(Text('Priya Sharma')),
                        DataCell(Text('₹10,000 - Marketing')),
                        DataCell(Row(children: [
                          TextButton(child: const Text('Approve'), onPressed: () {
                            Get.snackbar('Success', 'Approved (Mock)');
                          }),
                          TextButton(child: const Text('Reject'), onPressed: () {
                            Get.snackbar('Success', 'Rejected (Mock)');
                          }),
                        ])),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Reports & Analytics
// Notes: Generates reports for sales, attendance, audits, etc. Filters for time/store. Syncfusion charts for visualization. Download button for PDF/Excel. In backend, API for report generation.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Generate Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: DropdownButton<String>(
                hint: const Text('Report Type'),
                items: ['Sales', 'Attendance', 'Audit', 'Inventory'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: DropdownButton<String>(
                hint: const Text('Store'),
                items: ['All Stores', 'Mumbai Store1', 'Delhi Store1'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (_) {},
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Date Range', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Report Generated (Mock)');
                },
                text: 'Generate Report',
                icon: const Icon(Icons.analytics),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: SizedBox(
                height: 200,
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  series: <CartesianSeries<Map<String, dynamic>, String>>[
                    ColumnSeries<Map<String, dynamic>, String>(
                      dataSource: [
                        {'month': 'Jul', 'sales': 500000},
                        {'month': 'Aug', 'sales': 600000},
                        {'month': 'Sep', 'sales': 550000},
                        {'month': 'Oct', 'sales': 700000},
                      ],
                      xValueMapper: (data, _) => data['month'] as String,
                      yValueMapper: (data, _) => data['sales'] as num,
                      color: const Color(0xFFD35400),
                    ),
                  ],

                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Report Downloaded (Mock)');
                },
                text: 'Download PDF/Excel',
                icon: const Icon(Icons.download),
                color: const Color(0xFF001E36),
                fullWidthButton: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Time Tracking
// Notes: Tracks employee work hours. Form for manual entry. DataTable for logs. In backend, API for time tracking, integration with payroll.
class TimeTrackingScreen extends StatelessWidget {
  const TimeTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time Tracking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Log Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: const TextField(
                decoration: InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Hours Worked', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Task Description', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Time Logged (Mock)');
                },
                text: 'Log Time',
                icon: const Icon(Icons.timer),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Time Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Employee')),
                      DataColumn(label: Text('Hours')),
                      DataColumn(label: Text('Task')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('Oct 02, 2025')),
                        DataCell(Text('Rajesh Kumar')),
                        DataCell(Text('8')),
                        DataCell(Text('Store Audit')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Oct 02, 2025')),
                        DataCell(Text('Priya Sharma')),
                        DataCell(Text('7.5')),
                        DataCell(Text('Sales Upload')),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// PO Management
// Notes: Franchisees manage purchase orders. Form to create PO. List of open/closed POs. In backend, API for PO creation, approval workflow.
class POManagementScreen extends StatelessWidget {
  const POManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PO Management')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create Purchase Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: const TextField(
                decoration: InputDecoration(labelText: 'PO Number', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Supplier', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'PO Created (Mock)');
                },
                text: 'Create PO',
                icon: const Icon(Icons.send),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('PO List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('PO001 - Samsung Stock'),
                subtitle: const Text('Amount: ₹2,00,000 - Status: Pending'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Get.snackbar('View', 'PO Details (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}

// Profit Invoice
// Notes: Franchisees generate invoices for profit tracking. Form for invoice details. List of past invoices. In backend, API for invoice generation, integration with accounting.
class ProfitInvoiceScreen extends StatelessWidget {
  const ProfitInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profit Invoice')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Generate Invoice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: const TextField(
                decoration: InputDecoration(labelText: 'Invoice Number', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Customer', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const TextField(
                decoration: InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Invoice Generated (Mock)');
                },
                text: 'Generate Invoice',
                icon: const Icon(Icons.receipt),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Past Invoices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('INV001 - Oct 01, 2025'),
                subtitle: const Text('Customer: ABC Corp - Amount: ₹1,50,000'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    Get.snackbar('Success', 'Invoice Downloaded (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}

// Employee Self-Service (ESS)
// Notes: Employees view payslips, apply for leaves, update profiles. Links to other screens (e.g., Leave Management). In backend, API for ESS data, document access.
class ESSScreen extends StatelessWidget {
  const ESSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Self-Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage('https://picsum.photos/seed/user1/50/50'),
                ),
                title: const Text('Rajesh Kumar'),
                subtitle: const Text('Store Staff - Mumbai Store1'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Get.toNamed('/manage_profile');
                  },
                ),
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 16),
            const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FadeInUp(
              child: GFButton(
                onPressed: () {
                  Get.toNamed('/leave_management');
                },
                text: 'Apply for Leave',
                icon: const Icon(Icons.calendar_today),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Payslip Downloaded (Mock)');
                },
                text: 'Download Payslip',
                icon: const Icon(Icons.download),
                color: const Color(0xFF001E36),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: GFButton(
                onPressed: () {
                  Get.toNamed('/write_to_hr');
                },
                text: 'Write to HR',
                icon: const Icon(Icons.mail),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Recent Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Payslip - Sep 2025'),
                subtitle: const Text('Downloaded: Oct 01, 2025'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    Get.snackbar('Success', 'Document Downloaded (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}

// Field Force Tracking
// Notes: Tracks BMs/field staff via GPS. Map placeholder (integrate map API in backend). DataTable for location logs. In backend, API for real-time GPS tracking.
class FieldForceScreen extends StatelessWidget {
  const FieldForceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Field Force Tracking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Field Staff Locations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: Text('Map Placeholder (Integrate Google Maps API)')),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Location Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Employee')),
                      DataColumn(label: Text('Location')),
                      DataColumn(label: Text('Time')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('Rajesh Kumar')),
                        DataCell(Text('Mumbai Store1')),
                        DataCell(Text('Oct 02, 2025 10:00 AM')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Karan Singh')),
                        DataCell(Text('Pune Store1')),
                        DataCell(Text('Oct 02, 2025 11:00 AM')),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Manage Profile
// Notes: Employees update personal details, view CMS pages (e.g., Terms). Form for profile edits. In backend, API for profile updates, CMS content retrieval.
class ManageProfileScreen extends StatelessWidget {
  const ManageProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            FadeInUp(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://picsum.photos/seed/user1/100/100'),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                controller: TextEditingController(text: 'Rajesh Kumar'),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                controller: TextEditingController(text: 'rajesh@phonewale.in'),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
                controller: TextEditingController(text: '+91 9876543210'),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: GFButton(
                onPressed: () {
                  Get.snackbar('Success', 'Profile Updated (Mock)');
                },
                text: 'Update Profile',
                icon: const Icon(Icons.save),
                color: const Color(0xFFD35400),
                fullWidthButton: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Company Policies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Terms and Conditions'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Get.snackbar('View', 'Terms and Conditions (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 1000.ms),
            Card(
              child: ListTile(
                title: const Text('Privacy Policy'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Get.snackbar('View', 'Privacy Policy (Mock)');
                  },
                ),
              ),
            ).animate().fadeIn(delay: 1200.ms),
          ],
        ),
      ),
    );
  }
}