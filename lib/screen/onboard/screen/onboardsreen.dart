import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'; // For rendering HTML content in Flutter
import 'package:mycourse_flutter/model/onboard.dart'; // Model for onboarding data
import 'package:mycourse_flutter/screen/onboard/logic/onboardpresenter.dart'; // Presenter for managing onboarding logic
import 'package:mycourse_flutter/screen/onboard/logic/onboardview.dart'; // Interface for the Onboard view

// Main Onboard Screen Widget
class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  // Creating the state for OnboardScreen
  // ignore: library_private_types_in_public_api
  _OnboardScreenState createState() => _OnboardScreenState();
}

// State class for OnboardScreen
class _OnboardScreenState extends State<OnboardScreen> implements Onboardview {
  late OnboardPresenter presenter; // Presenter to handle business logic
  bool isLoading = false; // Loading state
  String errorMessage = ''; // Error message to display
  List<Onboards> onboardData = []; // List to hold onboarding data
  final PageController _pageController =
      PageController(); // Controller for PageView
  int _currentPage = 0; // Current page index

  @override
  void initState() {
    super.initState();
    presenter =
        OnboardPresenter(this); // Initializing presenter with current view
    presenter.getOnboardData(); // Fetch onboarding data
  }

  // Callback to update loading state
  @override
  void onLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  // Callback to update onboarding data
  @override
  void onResponse(List<Onboards> onboards) {
    setState(() {
      onboardData = onboards; // Storing the fetched data
    });
  }

  // Callback to handle fetch error
  @override
  void onFetchError(String message) {
    setState(() {
      errorMessage = message; // Storing error message
    });
  }

  // Navigates to the home page
  void _goToHomePage() {
    Navigator.pushReplacementNamed(context, '/mainpage');
  }

  // Callback for when the page changes
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index; // Update the current page index
    });
  }

  // Build method to construct the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.blue.shade400
            ], // Background gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Loading indicator
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(errorMessage,
                        style: const TextStyle(
                            color: Colors.white))) // Display error message
                : onboardData.isNotEmpty
                    ? Stack(
                        children: [
                          // PageView for displaying onboarding pages
                          PageView.builder(
                            controller: _pageController,
                            itemCount: onboardData.length,
                            onPageChanged: _onPageChanged,
                            itemBuilder: (context, index) {
                              final onboard = onboardData[index];
                              return OnboardPage(
                                  onboard:
                                      onboard); // Pass onboard data to OnboardPage
                            },
                          ),
                          // Positioned Skip button
                          Positioned(
                            top: 40,
                            right: 20,
                            child: TextButton(
                              onPressed: _goToHomePage,
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          // Positioned indicators for the pages
                          Positioned(
                            bottom: 40,
                            left: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  List.generate(onboardData.length, (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  height: 10,
                                  width: _currentPage == index ? 25 : 10,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? Colors.white
                                        : Colors.white54,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                );
                              }),
                            ),
                          ),
                          // Positioned Next/Start button
                          Positioned(
                            bottom: 40,
                            right: 20,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_currentPage < onboardData.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  _goToHomePage(); // Navigate to home page
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.green,
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                _currentPage < onboardData.length - 1
                                    ? 'Next'
                                    : 'Get Started',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Text('No Onboard Data',
                            style: TextStyle(color: Colors.white))),
      ),
    );
  }
}

// OnboardPage Widget to display individual onboarding data
class OnboardPage extends StatefulWidget {
  final Onboards onboard; // Onboarding data

  const OnboardPage({super.key, required this.onboard});

  @override
  // Creating the state for OnboardPage
  // ignore: library_private_types_in_public_api
  _OnboardPageState createState() => _OnboardPageState();
}

// State class for OnboardPage
class _OnboardPageState extends State<OnboardPage> {
  bool showFullContent = false; // State to control content visibility
  final int contentLimit =
      100; // Limit of characters before showing "Read More"

  @override
  Widget build(BuildContext context) {
    final String displayedContent = showFullContent ||
            widget.onboard.content.length <= contentLimit
        ? widget.onboard.content // Full content if expanded or short
        : '${widget.onboard.content.substring(0, contentLimit)}...'; // Shortened content

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 75), // Spacing at the top
        // Title below the skip button
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            widget.onboard.title, // Onboarding title
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        //const SizedBox(height: 6), // Added spacing here
        // Dashed Line
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            28,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                width: 8, // Length of each dash
                height: 2, // Thickness of each dash
                color: Colors.white.withOpacity(0.8), // Dash color
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Image with rounded borders
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Rounded corners
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 2), // Shadow for the image
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                30), // Clip the image with rounded corners
            child: Image.network(
              widget.onboard.imageurl, // Onboarding image URL
              height: 390.0, // Adjusted height for better spacing
              fit: BoxFit.cover, // Fit the image within the box
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Scrollable content area
        Expanded(
          // Ensure the scrollable area takes remaining space
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HtmlWidget(
                    displayedContent, // Rendered content
                    textStyle: const TextStyle(
                        color: Colors.white), // Text style for content
                  ),

                  // "Read More" button
                  if (widget.onboard.content.length >
                      contentLimit) // Show button if content is long
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showFullContent =
                              !showFullContent; // Toggle full content display
                        });
                      },
                      child: Text(
                        showFullContent ? 'Read Less' : 'Read More',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 80), // Spacing below content
      ],
    );
  }
}
