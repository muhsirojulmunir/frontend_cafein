import 'package:cafein/models/podcast_model.dart';
import 'package:cafein/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class PodcastDetailPage extends StatelessWidget {
  final PodcastModel podcast;

  const PodcastDetailPage({super.key, required this.podcast});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppGradient.pageBackgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 2.h),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Wrap content
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Hero(
                                tag: podcast.imageUrl,
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    podcast.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        Text(
                          podcast.title,
                          style: TextStyleApp.bodyTextBold.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          podcast.category,
                          style: TextStyleApp.bodyTextSmall.copyWith(
                            color: Colors.grey,
                            fontSize: 13.sp,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _launchURL(podcast.videoUrl);
                            },
                            icon: Icon(Icons.play_arrow, color: Colors.white),
                            label: Text(
                              'Tonton di youtube',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h), // Bottom spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Image.asset(appImages.imgLogoCafein.path, height: 11.h),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Popcast CafeIN',
              style: TextStyleApp.bodyTextBold.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ),

          Icon(Icons.bookmark_border, color: Colors.white),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
