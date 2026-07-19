import 'dart:ui';
import 'dart:ui' as ui;
import 'package:bead_beauty/models/rolemodel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GlassTeamCard extends StatelessWidget {
  final TeamMember member;

  const GlassTeamCard({super.key, required this.member});

  Future<void> _launchWhatsApp(String number) async {
    final String whatsappUrl = "https://wa.me/$number";
    final Uri url = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch WhatsApp for $number");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFF1493), width: 2),
                  image: DecorationImage(
                    image: AssetImage(member.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.role,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF1493),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // මෙන්න මේ InkWell එකට තමයි Flexible දැම්මේ
                    Flexible(
                      child: InkWell(
                        onTap: () => _launchWhatsApp(member.whatsappNumber),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat, color: Colors.white, size: 16),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "Contact Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
