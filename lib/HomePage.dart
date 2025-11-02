import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'project_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final firestore = FirebaseFirestore.instance;
  late final Future<List<Project>> _projectsFuture;

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _projectsFuture = _fetchProjects();
  }

  Future<List<Project>> _fetchProjects() async {
    try {
      final snapshot = await firestore.collection('projects').get();
      final projects = snapshot.docs.map((doc) {
        return Project.fromJson(doc.data());
      }).toList();
      return projects;
    } catch (e) {
      print('Error fetching projects from Firestore: $e');
      return [];
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'rocket':
        return Icons.rocket_launch;
      case 'palette':
        return Icons.color_lens;
      case 'music':
        return Icons.music_note;
      case 'list':
        return FontAwesomeIcons.listCheck;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                SizedBox(key: _heroKey, child: buildHeroSection(context)),
                SizedBox(
                  key: _projectsKey,
                  child: buildProjectSection(context),
                ),
                SizedBox(
                  key: _educationKey,
                  child: buildEducationSection(context),
                ),
                SizedBox(key: _contactKey, child: buildContactSection(context)),
                buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Muadz Haidar",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Theme.of(context).primaryColor,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (MediaQuery.of(context).size.width > 700)
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Row(
              children: [
                _navButton("Home", () => _scrollToSection(_heroKey)),
                _navButton("Projects", () => _scrollToSection(_projectsKey)),
                _navButton("Education", () => _scrollToSection(_educationKey)),
                _navButton("Contact", () => _scrollToSection(_contactKey)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _navButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF333333).withOpacity(0.8),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildHeroSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;

        final heroText = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: isDesktop
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Text(
              "Junior Flutter Developer",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.displaySmall!,
              textAlign: isDesktop ? TextAlign.left : TextAlign.center,
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    "Halo, Gw Muadz Haidar",
                    speed: Duration(milliseconds: 100),
                  ),
                ],
                repeatForever: true,
                pause: Duration(milliseconds: 2000),
              ),
            ),
            SizedBox(height: 24),

            Text(
              "Gw adalah seorang junior flutter developer, selamat datang di portofolio gw!!!",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: 18),
              textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            ),
            SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => _scrollToSection(_projectsKey),
              child: const Text("Lihat Proyek Saya"),
            ),
          ],
        );
        final heroImage = Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: isDesktop ? 0 : 32),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'asset/gw.JPG',
                  width: 350,
                  height: 350,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 350,
                    width: 350,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: isDesktop ? 20 : 0,
              left: isDesktop ? 20 : null,
              right: isDesktop ? null : 20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
          height: MediaQuery.of(context).size.height * 1.0,
          child: isDesktop
              ? Row(
                  children: [
                    Expanded(child: heroText, flex: 3),
                    Expanded(child: heroImage, flex: 2),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [heroImage, SizedBox(height: 32), heroText],
                ),
        );
      },
    );
  }

  Widget buildProjectSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Text(
            "Proyek Pilihan",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(height: 16),
          Text(
            "Beberapa Proyek yang telah dibangun",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 48),
          FutureBuilder<List<Project>>(
            future: _projectsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text("Gagal memuat proyek");
              }
              final projects = snapshot.data;
              if (projects == null || projects.isEmpty) {
                return const Text("Belum ada proyek untuk ditampilkan.");
              }
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: projects
                    .map(
                      (project) => ProjectCard(
                        title: project.judul,
                        description: project.deskripsi,
                        onTap: () => _launchURL(project.linkProject),
                        imagePath: project.imagePath,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildEducationSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Text(
            "Riwayat Pendidikan",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(height: 16),
          Text(
            "Perjalanan akademis yang telah saya tempuh.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              EducationCard(
                school: "SMP IDN Boarding School",
                major: "IT",
                years: "2021-2024",
                icon: Icons.school,
              ),
              EducationCard(
                school: "SMA Rabbaanii Islamic School",
                major: "Mobile Developer",
                years: "2024-now",
                icon: Icons.computer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildContactSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          Text("Hubungi Saya", style: Theme.of(context).textTheme.displaySmall),
          SizedBox(height: 16),
          Text(
            "Mari berkolaborasi! Hubungi saya melalui:",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialButton(
                icon: FontAwesomeIcons.github,
                url: 'https://github.com/muadzhaidar08',
              ),
              SizedBox(width: 16),
              SocialButton(
                icon: FontAwesomeIcons.linkedin,
                url: 'https://www.linkedin.com/in/ahmad-muadz-haidar/',
              ),
              SizedBox(width: 16),
              SocialButton(
                icon: FontAwesomeIcons.envelope,
                url: 'mailto:muadzhaidar08@gmail.com',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      width: double.infinity,
      color: Color(0xFF333333),
      child: Text(
        "© ${DateTime.now().year} Muadz Haidar. Dibuat dengan Hati 💙",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final String school;
  final String major;
  final String years;
  final IconData icon;

  const EducationCard({
    Key? key,
    required this.school,
    required this.major,
    required this.years,
    this.icon = Icons.school,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Theme.of(context).primaryColor),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  school,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontSize: 22),
                ),
                SizedBox(height: 4),
                Text(
                  major,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  years,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final String? imagePath;

  const ProjectCard({
    Key? key,
    required this.title,
    required this.description,
    required this.onTap,
    this.imagePath,
  }) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              isHovered
                  ? BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    )
                  : BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.imagePath != null && widget.imagePath!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    widget.imagePath!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.code,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Lihat Proyek",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
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

class SocialButton extends StatefulWidget {
  final IconData icon;
  final String url;

  const SocialButton({Key? key, required this.icon, required this.url})
    : super(key: key);

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _isHovered = false;

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    final onSurfaceColor = Color(0xFF333333);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () => _launchURL(widget.url),
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FaIcon(
            widget.icon,
            size: 30,
            color: _isHovered ? color : onSurfaceColor.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
