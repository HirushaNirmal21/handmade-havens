import 'dart:ui' as ui;
import 'dart:ui_web' as ui_web;
import 'package:bead_beauty/models/rolemodel.dart';
import 'package:bead_beauty/screens/admin/adminloginscreen.dart';
import 'package:bead_beauty/utils/backgroundgradient.dart';
import 'package:bead_beauty/widgets/aboutus/rolecard.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  int _tapCount = 0;
  void _handleAdminTap(BuildContext context) {
    _tapCount++;
    if (_tapCount == 7) {
      _tapCount = 0;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
      );
    }
  }

  final String mapEmbedUrl =
      "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d31697.585501755194!2d80.08985177431637!3d6.130843657375269!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3ae1770000000001%3A0x89e09d571d87e07f!2sHikkaduwa!5e0!3m2!1sen!2slk!4v1700000000000!5m2!1sen!2slk";
  late final WebViewController _mobileMapController;

  final List<TeamMember> ourTeam = [
    TeamMember(
      name: "Timashi Manawadu",
      role: "Owner & Founder 💖",
      imagePath: "assets/contact1.jpeg",
      whatsappNumber: "94757209765",
    ),
    TeamMember(
      name: "Dilusha Manawadu",
      role: "Store Manager 📦",
      imagePath: "assets/contact2.jpeg",
      whatsappNumber: "94760399793",
    ),
  ];

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      ui_web.platformViewRegistry.registerViewFactory(
        'google-maps-view',
        (int viewId) => html.IFrameElement()
          ..src = mapEmbedUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%',
      );
    } else {
      _mobileMapController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(mapEmbedUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "About Us ✨",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () => _handleAdminTap(context),
            child: Container(width: 40, height: 40, color: Colors.transparent),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: gradientColors),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "Handmade Haven",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black38,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Creating Elegant Handcrafted Jewellery Just For You 💖",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? screenWidth * 0.15 : 20.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildStoryTextGlass()),
                                const SizedBox(width: 30),
                                Expanded(child: _buildBrandCardGlass()),
                              ],
                            )
                          : Column(
                              children: [
                                _buildStoryTextGlass(),
                                const SizedBox(height: 25),
                                _buildBrandCardGlass(),
                              ],
                            ),
                      const SizedBox(height: 40),
                      const Divider(color: Colors.white30, thickness: 1),
                      const SizedBox(height: 20),
                      const Text(
                        "Contact Us 📍",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black26,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Feel free to reach out to our team directly via WhatsApp or visit our location.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 25),
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildTeamSection()),
                                const SizedBox(width: 30),
                                Expanded(child: _buildLiveMapSectionGlass()),
                              ],
                            )
                          : Column(
                              children: [
                                _buildTeamSection(),
                                const SizedBox(height: 25),
                                _buildLiveMapSectionGlass(),
                              ],
                            ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryTextGlass() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ), // Blur ප්‍රමාණය
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15), // Semi-transparent white
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Our Story 🌸",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Welcome to Handmade Haven! We specialize in crafting 100% handmade, premium quality beaded accessories including custom bangles, bracelets, necklaces, and more. Each piece is designed meticulously, keeping your unique style and elegance in mind.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "What started as a passionate hobby has now blossomed into a beautiful platform where we bring your dream designs to life. We guarantee the use of high-quality beads and materials to ensure durability and comfort.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandCardGlass() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Why Choose Us? ✨",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              _buildGlassListTile(
                Icons.favorite,
                "100% Handcrafted masterpieces",
              ),
              _buildGlassListTile(
                Icons.palette,
                "Custom designs made to order",
              ),
              _buildGlassListTile(
                Icons.local_shipping,
                "Island-wide reliable delivery",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassListTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Column(
      children: ourTeam
          .map(
            (member) => Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: GlassTeamCard(member: member),
            ),
          )
          .toList(),
    );
  }

  Widget _buildLiveMapSectionGlass() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Our Location 🗺️",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: kIsWeb
                      ? const HtmlElementView(viewType: 'google-maps-view')
                      : WebViewWidget(controller: _mobileMapController),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
