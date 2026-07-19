import 'dart:ui';
import 'package:bead_beauty/models/reviewmodel.dart';
import 'package:bead_beauty/services/reviewservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildReviewsAndInstagram(BuildContext context) {
  return Consumer<ReviewProvider>(
    builder: (context, provider, child) {
      return Column(
        children: [
          const Text(
            "What Our Beauties Say 💖",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () => showFeedbackForm(context),
            icon: Icon(Icons.add),
            label: Text("Add Feedback"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.8),
              foregroundColor: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          provider.reviews.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "No reviews yet!",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    children: provider.reviews.map((review) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width > 800
                            ? 300
                            : MediaQuery.of(context).size.width * 0.9,
                        child: _buildReviewCard(review),
                      );
                    }).toList(),
                  ),
                ),

          const SizedBox(height: 50),

          const Text(
            "Follow Us on FaceBook",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildInstagramImage("assets/face1.jpeg"),
                _buildInstagramImage("assets/face2.jpeg"),
                _buildInstagramImage("assets/face3.jpeg"),
                _buildInstagramImage("assets/face4.jpeg"),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      );
    },
  );
}

// Instagram Image Widget
Widget _buildInstagramImage(String assetPath) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: Image.asset(
      assetPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.white.withOpacity(0.1),
        child: Icon(Icons.broken_image, color: Colors.white),
      ),
    ),
  );
}

Widget _buildReviewCard(Review review) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              review.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                review.stars,
                (i) => Icon(Icons.star, color: Colors.amber, size: 16),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "- ${review.authorName}",
              style: const TextStyle(
                color: Color(0xFFFF4D79),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void showFeedbackForm(BuildContext context) {
  final nameCtrl = TextEditingController();
  final feedbackCtrl = TextEditingController();
  int rating = 0;

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setStat) => AlertDialog(
        title: Text("Leave a Review"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: "Your Name"),
            ),
            TextField(
              controller: feedbackCtrl,
              decoration: InputDecoration(labelText: "Your Feedback"),
            ),
            SizedBox(height: 10),
            Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < rating ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => setStat(() => rating = index + 1),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newReview = Review(
                id: 0,
                authorName: nameCtrl.text,
                content: feedbackCtrl.text,
                stars: rating,
              );
              Provider.of<ReviewProvider>(
                context,
                listen: false,
              ).addReview(newReview);
              Navigator.pop(ctx);
            },
            child: Text("Submit"),
          ),
        ],
      ),
    ),
  );
}
