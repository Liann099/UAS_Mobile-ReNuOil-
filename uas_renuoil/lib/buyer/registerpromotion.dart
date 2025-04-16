import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
      ),
      home: const PromotionScreen(),
    );
  }
}

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({Key? key}) : super(key: key);

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    // Yellow header with back button and title
                    _buildHeader(),
                    
                    // Tab bar
                    _buildTabBar(),
                    
                    // Main content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Register Promotion Tab
                          _buildPromotionTab(constraints, orientation),
                          
                          // Available Promotion Tab
                          _buildAvailablePromotionsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
  
  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;
        
        // Calculate responsive sizes
        final fontSize = isSmallScreen 
            ? (screenWidth * 0.055 > 26 ? 26.0 : screenWidth * 0.055)
            : (screenWidth * 0.03 > 30 ? 30.0 : screenWidth * 0.03);
            
        final iconSize = isSmallScreen 
            ? (screenWidth * 0.06 > 28 ? 28.0 : screenWidth * 0.06)
            : (screenWidth * 0.03 > 30 ? 30.0 : screenWidth * 0.03);
            
        final paddingVertical = isSmallScreen 
            ? (screenWidth * 0.04 > 20 ? 20.0 : screenWidth * 0.04)
            : (screenWidth * 0.02 > 22 ? 22.0 : screenWidth * 0.02);
            
        final paddingHorizontal = isSmallScreen 
            ? (screenWidth * 0.05 > 24 ? 24.0 : screenWidth * 0.05)
            : (screenWidth * 0.03 > 30 ? 30.0 : screenWidth * 0.03);
            
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: paddingVertical,
            horizontal: paddingHorizontal,
          ),
          color: const Color(0xFFFFD358), // Yellow background color
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // Add navigation logic here
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: iconSize,
                ),
              ),
              Text(
                'Promotion',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Empty space to balance the back button
              SizedBox(width: iconSize),
            ],
          ),
        );
      }
    );
  }
  
  Widget _buildTabBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;
        
        // Calculate responsive sizes
        final containerHeight = isSmallScreen 
            ? (screenWidth * 0.15 > 80 ? 80.0 : screenWidth * 0.15)
            : (screenWidth * 0.08 > 90 ? 90.0 : screenWidth * 0.08);
            
        final horizontalPadding = isSmallScreen 
            ? (screenWidth * 0.05 > 24 ? 24.0 : screenWidth * 0.05)
            : (screenWidth * 0.03 > 30 ? 30.0 : screenWidth * 0.03);
            
        final verticalPadding = isSmallScreen 
            ? (screenWidth * 0.025 > 12 ? 12.0 : screenWidth * 0.025)
            : (screenWidth * 0.015 > 15 ? 15.0 : screenWidth * 0.015);
            
        final borderRadius = isSmallScreen 
            ? (screenWidth * 0.07 > 35 ? 35.0 : screenWidth * 0.07)
            : (screenWidth * 0.04 > 40 ? 40.0 : screenWidth * 0.04);
            
        final fontSize = isSmallScreen 
            ? (screenWidth * 0.04 > 18 ? 18.0 : screenWidth * 0.04)
            : (screenWidth * 0.02 > 20 ? 20.0 : screenWidth * 0.02);
          
        return Container(
          height: containerHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFD358), // Yellow background color
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  // Override text theme just for the TabBar
                  textTheme: TextTheme(
                    bodyLarge: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'Register Promotion'),
                    Tab(text: 'Available Promotion'),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
  
  Widget _buildPromotionTab(BoxConstraints constraints, Orientation orientation) {
    // Adjust layout based on orientation and screen size
    final isLandscape = orientation == Orientation.landscape;
    final screenWidth = constraints.maxWidth;
    
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // Responsive horizontal padding
          vertical: isLandscape ? 10.0 : 20.0,
        ),
        child: isLandscape && screenWidth > 600
            ? _buildLandscapeLayout(constraints)
            : _buildPortraitLayout(constraints),
      ),
    );
  }
  
  Widget _buildPortraitLayout(BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenWidth * 0.05),
        
        // Mascot with speech bubble - improved layout
        _buildMascotWithSpeechBubble(),
        
        SizedBox(height: screenWidth * 0.05),
        
        // Promotion banner
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/3.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        
        SizedBox(height: screenWidth * 0.04),
        
        // Promo code
        Container(
          width: screenWidth > 600 ? screenWidth * 0.6 : double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.025,
            horizontal: screenWidth * 0.05,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD358),
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
          ),
          child: Text(
            'Code: CKI88OIL',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.045 > 24 ? 24 : screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        SizedBox(height: screenWidth * 0.1),
      ],
    );
  }
  
  Widget _buildLandscapeLayout(BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side - Mascot with speech bubble
        Expanded(
          flex: 3,
          child: _buildMascotWithSpeechBubble(),
        ),
        
        // Right side - Banner and promo code
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Promotion banner
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/3.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              
              SizedBox(height: screenWidth * 0.02),
              
              // Promo code
              Container(
                width: screenWidth * 0.4,
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.015,
                  horizontal: screenWidth * 0.03,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD358),
                  borderRadius: BorderRadius.circular(screenWidth * 0.015),
                ),
                child: Text(
                  'Code: CKI88OIL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.025 > 22 ? 22 : screenWidth * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildMascotWithSpeechBubble() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if this is a small, medium, or large screen
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;
        final isLargeScreen = screenWidth > 900;
        
        // Calculate sizes based on available width and screen size
        final mascotSize = isSmallScreen 
            ? screenWidth * 0.45
            : isLargeScreen 
                ? 200.0 
                : screenWidth * 0.35;
                
        final bubbleWidth = isSmallScreen 
            ? screenWidth * 0.55
            : isLargeScreen 
                ? 300.0 
                : screenWidth * 0.45;
        
        // Get orientation
        final orientation = MediaQuery.of(context).orientation;
        final isLandscape = orientation == Orientation.landscape;
        
        // Adjust layout for landscape on smaller devices
        if (isLandscape && screenWidth < 900) {
          return SizedBox(
            height: mascotSize * 1.2,
            child: Stack(
              children: [
                // Mascot image
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: mascotSize,
                    height: mascotSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF7ADCCB), // Teal circle background
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(mascotSize * 0.02), // Proportional padding
                      child: Image.asset(
                        'assets/images/mascottulisan.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                
                // Speech bubble adjusted for landscape
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: bubbleWidth,
                    padding: EdgeInsets.symmetric(
                      vertical: mascotSize * 0.1,
                      horizontal: mascotSize * 0.08,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD358), // Yellow bubble color
                      borderRadius: BorderRadius.circular(mascotSize * 0.15),
                    ),
                    // Removed text as requested
                  ),
                ),
              ],
            ),
          );
        }
        
        // Default layout (portrait or large landscape)
        return SizedBox(
          height: mascotSize * 1.2,
          child: Stack(
            clipBehavior: Clip.none, // Prevent clipping of child widgets
            children: [
              // Mascot image with proper size and positioning
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: mascotSize,
                  height: mascotSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF7ADCCB), // Teal circle background
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(mascotSize * 0.02), // Proportional padding
                    child: Image.asset(
                      'assets/images/mascottulisan.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              
              // Speech bubble with responsive width
              Positioned(
                right: 0,
                bottom: mascotSize * 0.25,
                child: Container(
                  width: bubbleWidth,
                  padding: EdgeInsets.symmetric(
                    vertical: mascotSize * 0.12,
                    horizontal: mascotSize * 0.08,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD358), // Yellow bubble color
                    borderRadius: BorderRadius.circular(mascotSize * 0.15),
                  ),
                  // Removed text as requested
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildAvailablePromotionsTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final isSmallScreen = screenWidth < 600;
        final orientation = MediaQuery.of(context).orientation;
        final isLandscape = orientation == Orientation.landscape;
        
        // Adjust icon and text sizes based on screen size
        final iconSize = isSmallScreen 
            ? screenWidth * 0.15 
            : screenWidth * 0.08;
        final titleFontSize = isSmallScreen 
            ? screenWidth * 0.045 
            : screenWidth * 0.025;
        final subtitleFontSize = isSmallScreen 
            ? screenWidth * 0.035 
            : screenWidth * 0.018;
            
        // Max sizes to prevent text/icons from becoming too large
        final finalIconSize = iconSize > 100 ? 100.0 : iconSize;
        final finalTitleSize = titleFontSize > 24 ? 24.0 : titleFontSize;
        final finalSubtitleSize = subtitleFontSize > 18 ? 18.0 : subtitleFontSize;
        
        return Container(
          color: Colors.white,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: isLandscape ? 10.0 : 20.0,
              ),
              child: isLandscape && screenWidth > 600
                  ? _buildLandscapeAvailablePromotions(constraints, finalIconSize, finalTitleSize, finalSubtitleSize)
                  : _buildPortraitAvailablePromotions(constraints, finalIconSize, finalTitleSize, finalSubtitleSize),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildPortraitAvailablePromotions(BoxConstraints constraints, double iconSize, double titleSize, double subtitleSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: constraints.maxHeight * 0.15),
        Icon(
          Icons.local_offer,
          size: iconSize,
          color: Colors.grey[400],
        ),
        SizedBox(height: constraints.maxHeight * 0.03),
        Text(
          'No Available Promotions',
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.01),
        Text(
          'Check back later for new offers',
          style: TextStyle(
            fontSize: subtitleSize,
            color: Colors.grey[500],
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.02),
        Container(
          width: constraints.maxWidth * 0.6,
          padding: EdgeInsets.symmetric(
            vertical: constraints.maxWidth * 0.03,
            horizontal: constraints.maxWidth * 0.05,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color(0xFFFFD358),
          ),
          child: Text(
            'Refresh',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleSize * 0.9,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.15),
      ],
    );
  }
  
  Widget _buildLandscapeAvailablePromotions(BoxConstraints constraints, double iconSize, double titleSize, double subtitleSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Icon(
            Icons.local_offer,
            size: iconSize,
            color: Colors.grey[400],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No Available Promotions',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.02),
              Text(
                'Check back later for new offers',
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.04),
              Container(
                width: constraints.maxWidth * 0.3,
                padding: EdgeInsets.symmetric(
                  vertical: constraints.maxWidth * 0.015,
                  horizontal: constraints.maxWidth * 0.02,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFFFFD358),
                ),
                child: Text(
                  'Refresh',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSize * 0.9,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Responsive extensions

extension ScreenSize on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  
  bool get isSmallScreen => width < 600;
  bool get isMediumScreen => width >= 600 && width < 900;
  bool get isLargeScreen => width >= 900;
  
  double responsiveValue({
    required double small,
    double? medium,
    double? large,
  }) {
    if (isLargeScreen) return large ?? medium ?? small;
    if (isMediumScreen) return medium ?? small;
    return small;
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget? tabletLayout;
  final Widget? desktopLayout;

  const ResponsiveLayout({
    Key? key,
    required this.mobileLayout,
    this.tabletLayout,
    this.desktopLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.isLargeScreen && desktopLayout != null) {
      return desktopLayout!;
    } else if (context.isMediumScreen && tabletLayout != null) {
      return tabletLayout!;
    } else {
      return mobileLayout;
    }
  }
}