import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('無法開啟 $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設計團隊')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 3),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/about/logo.png'),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "梁晨恩 (ryan940618)",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "大學生 | Flutter Dev",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                "熱愛程式設計與美食，致力於開發最直覺的無廣告App。如果有任何問題或合作邀約，歡迎透過下方社群聯繫。",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    'assets/about/insta.png', 
                    Colors.purple, 
                    "IG", 
                    "https://www.instagram.com/ryan940618"
                  ),
                  _buildSocialButton(
                    'assets/about/x.png', 
                    Colors.blue, 
                    "Twitter(X)", 
                    "https://x.com/ryan940618"
                  ),
                  _buildSocialButton(
                    'assets/about/github.png', 
                    Colors.white, 
                    "GitHub", 
                    "https://github.com/ryan940618"
                  ),
                  _buildSocialButton(
                    'assets/about/gmail.png', 
                    Colors.red, 
                    "Email", 
                    "mailto:ryan940618@gmail.com"
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildSocialButton(String assetPath, Color btnColor, String label, String url) {
  return Column(
    children: [
      ElevatedButton(
        onPressed: () {
          _launchUrl(url);
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          backgroundColor: btnColor,
        ),
        child: Image.asset(
          assetPath,
          width: 24,
          height: 24,
          fit: BoxFit.contain
        ),
      ),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );
}
}