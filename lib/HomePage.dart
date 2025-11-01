import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'project_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final supabase = Supabase.instance.client;
  late final Future<List<Project>> _projectsFuture;

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _projectsFuture = _fetchProjects();
  }

  Future<List<Project>> _fetchProjects() async {
    try {
      final data = await supabase
          .from('projects')
          .select()
          .order('created_at', ascending: true);
      final projects = data.map((json) => Project.fromJson(json)).toList();
      return projects;
    } catch (e) {
      print('Error fetching projects: $e');
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
              "Saya adalah seorang junior flutter developer, selamat datang di portofolio saya!!!",
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
          Text("Proyek Saya", style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 48),
          FutureBuilder<List<Project>>(
            future: _projectsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Image.asset('asset/profil.JPG', height: 150);
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
                url: 'https://github.com/akun-gw',
              ),
              SizedBox(width: 16),
              SocialButton(
                icon: FontAwesomeIcons.linkedin,
                url: 'https://linkedin.com/in/akun-kamu',
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

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const ProjectCard({
    Key? key,
    required this.title,
    required this.description,
    required this.onTap,
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
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              isHovered
                  ? BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    )
                  : BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
            ],
          ),
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
