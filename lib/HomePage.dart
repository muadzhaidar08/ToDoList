import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'project_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sertifikat_model.dart';
import 'skill_model.dart';
import 'dart:ui';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final firestore = FirebaseFirestore.instance;
  late final Future<List<Project>> _projectsFuture;
  late final Future<List<Certificate>> _certificatesFuture;
  late final Future<List<Skill>> _skillsFuture;

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _certificatesKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();

  bool _isProfileHovered = false;

  @override
  void initState() {
    super.initState();
    _projectsFuture = _fetchProjects();
    _certificatesFuture = _fetchCertificates();
    _skillsFuture = _fetchSkills();
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

  Future<List<Certificate>> _fetchCertificates() async {
    try {
      final snapshot = await firestore.collection('certificates').get();
      final certificates = snapshot.docs.map((doc) {
        return Certificate.fromJson(doc.data());
      }).toList();
      return certificates;
    } catch (e) {
      print('Error fetching certificates from Firestore');
      return [];
    }
  }

  Future<List<Skill>> _fetchSkills() async {
    try {
      final snapshot = await firestore.collection('skills').get();
      final skills = snapshot.docs.map((doc) {
        return Skill.fromJson(doc.data());
      }).toList();
      return skills;
    } catch (e) {
      print('Error fetching skills from Firestore');
      ;
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
      case 'flutter':
        return FontAwesomeIcons.flutter;
      case 'dart':
        return FontAwesomeIcons.dartLang;
      case 'firebase':
        return FontAwesomeIcons.fire;
      case 'github':
        return FontAwesomeIcons.github;
      case 'figma':
        return FontAwesomeIcons.figma;
      case 'supabase':
        return FontAwesomeIcons.database;
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
                SizedBox(key: _aboutKey, child: buildAboutMeSection(context)),
                SizedBox(
                  key: _projectsKey,
                  child: buildProjectSection(context),
                ),
                SizedBox(key: _skillsKey, child: buildSkillsSection(context)),
                SizedBox(
                  key: _certificatesKey,
                  child: buildCertificatesSection(context),
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
                _navButton('About', () => _scrollToSection(_aboutKey)),
                _navButton("Projects", () => _scrollToSection(_projectsKey)),
                _navButton('Skills', () => _scrollToSection(_skillsKey)),
                _navButton(
                  'Certificates',
                  () => _scrollToSection(_certificatesKey),
                ),
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
              style: isDesktop
                ? Theme.of(context).textTheme.displaySmall!
                : Theme.of(context).textTheme.headlineMedium!,
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
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: _isProfileHovered
                      ? [Colors.purple, Colors.blue, Colors.green, Colors.red]
                      : [Colors.blue, Colors.green, Colors.red, Colors.purple],
                  begin: _isProfileHovered
                      ? Alignment.topLeft
                      : Alignment.bottomRight,
                  end: _isProfileHovered
                      ? Alignment.bottomRight
                      : Alignment.topLeft,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isProfileHovered
                        ? Colors.purple.withOpacity(0.5)
                        : Colors.blue.withOpacity(0.5),
                    blurRadius: _isProfileHovered ? 40 : 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
            ),
            MouseRegion(
              onEnter: (_) => setState(() => _isProfileHovered = true),
              onExit: (_) => setState(() => _isProfileHovered = false),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(
                  _isProfileHovered ? -15 : 0,
                  _isProfileHovered ? -20 : 0,
                  0,
                )..rotateZ(_isProfileHovered ? 0.03 : 0),
                child: Padding(
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

  Widget buildAboutMeSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Text("Tentang Saya", style: Theme.of(context).textTheme.displaySmall),
          SizedBox(height: 16),
          Text(
            "Beberapa hal tentang gw",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 48),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Halo! Nama gw Ahmad Muadz Haidar, Gw adalah seorang Junior Flutter Developer, Gw membangun aplikasi iOS dan Android menggunakan Flutter dan Dart.",
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 20),
                Text(
                  "Di luar coding, saya sangat suka investasi tubuh untuk membangun pribadi yang kuat dan lebih berprinsip. Mari terhubung",
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 32),
                OutlinedButton(
                  onPressed: () => _scrollToSection(_contactKey),
                  child: Text("Hubungi Saya"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProjectSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
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

  Widget buildSkillsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Text(
            "Keahlian Saya",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(height: 16),
          Text(
            "Teknologi dan tools yang gw kuasai",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 48),
          FutureBuilder(
            future: _skillsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Gagal memuat skill");
              }
              final skills = snapshot.data;
              if (skills == null || skills.isEmpty) {
                return Text("belum ada skill untuk ditampilkan");
              }
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: skills
                    .map(
                      (skill) => SkillCard(
                        name: skill.name,
                        iconData: _getIconData(skill.iconName),
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

  Widget buildCertificatesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Text("Sertifikasi", style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 16),
          Text(
            "Beberapa sertifikasi yang telah saya peroleh.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 48),
          FutureBuilder<List<Certificate>>(
            future: _certificatesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text("Gagal memuat sertifikat: ${snapshot.error}");
              }
              final certificates = snapshot.data;
              if (certificates == null || certificates.isEmpty) {
                return const Text("Belum ada sertifikat untuk ditampilkan.");
              }
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: certificates
                    .map(
                      (cert) => CertificateCard(
                        title: cert.title,
                        issuer: cert.issuer,
                        date: cert.date,
                        imageUrl: cert.imageUrl,
                        credentialUrl: cert.credentialUrl,
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
      color: Colors.white,
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

  Widget _buildPlaceHolder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Center(
        child: Icon(Icons.code, size: 40, color: Colors.grey.shade400),
      ),
    );
  }

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
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceHolder(),
                  ),
                )
              else
                _buildPlaceHolder(),

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
                    SizedBox(
                      height: 50,
                      child: Text(
                        widget.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
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

class SkillCard extends StatelessWidget {
  final String name;
  final IconData iconData;

  const SkillCard({Key? key, required this.name, required this.iconData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(iconData, size: 40, color: Theme.of(context).primaryColor),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class CertificateCard extends StatefulWidget {
  final String title;
  final String issuer;
  final String date;
  final String? imageUrl;
  final String? credentialUrl;

  const CertificateCard({
    Key? key,
    required this.title,
    required this.issuer,
    required this.date,
    this.imageUrl,
    this.credentialUrl,
  }) : super(key: key);

  @override
  State<CertificateCard> createState() => _CertificateCardState();
}

class _CertificateCardState extends State<CertificateCard> {
  bool isHovered = false;

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.grey.shade100,
      child: const Center(
        child: Icon(Icons.description, size: 50, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: widget.credentialUrl != null && widget.credentialUrl!.isNotEmpty
            ? () => _launchURL(widget.credentialUrl!)
            : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              isHovered
                  ? BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  : BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    widget.imageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholderImage(),
                  ),
                )
              else
                _buildPlaceholderImage(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.issuer,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.date,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                    ),
                    if (widget.credentialUrl != null &&
                        widget.credentialUrl!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          children: [
                            Text(
                              "Lihat Kredensial",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.open_in_new,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
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
