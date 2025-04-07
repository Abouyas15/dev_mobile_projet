import 'package:flutter/material.dart';
import 'package:ibamedt/Login%20Signup/Screen/connexion.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart'; // Pour les animations Lottie

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  bool _isLastPage = false;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentPage = 0;

  // Liste des couleurs de fond avec dégradés
  final List<List<Color>> _backgroundGradients = [
    [const Color(0xFF6200EE), const Color(0xFF7E3FF2)],
    [const Color(0xFF3700B3), const Color(0xFF5C29D2)],
    [const Color(0xFF03DAC5), const Color(0xFF00F5D4)],
    [const Color(0xFF018786), const Color(0xFF02A3A1)],
  ];

  // Liste des chemins d'animations Lottie (à remplacer par vos propres animations)
  final List<String> _lottieAnimations = [
    'assets/animations/welcome_animation.json',
    'assets/animations/student_animation.json',
    'assets/animations/teacher_animation.json',
    'assets/animations/admin_animation.json',
  ];

  @override
  void initState() {
    super.initState();
    // Configuration des animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );

    // Démarrer l'animation lors de l'initialisation
    _animationController.forward();

    // Ajouter un listener pour détecter les changements de page
    _controller.addListener(() {
      // Obtenir la page courante (peut être un nombre à virgule pendant la transition)
      final currentPage = _controller.page ?? 0;
      // Mettre à jour l'état uniquement si la page entière a changé
      if (currentPage.round() != _currentPage) {
        setState(() {
          _currentPage = currentPage.round();
        });
        // Redémarrer l'animation lors du changement de page
        _animationController.reset();
        _animationController.forward();

        // Effet de vibration tactile lors du changement de page
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Méthode pour construire l'arrière-plan avec dégradé animé
  Widget _buildAnimatedBackground(int pageIndex) {
    final List<Color> gradientColors = _backgroundGradients[pageIndex];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan animé
          _buildAnimatedBackground(_currentPage),

          // Effet de particules flottantes (simulé par des cercles animés)
          ..._buildFloatingParticles(),

          SafeArea(
            child: Column(
              children: [
                // PageView qui prend l'espace restant sans overflow
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        _isLastPage = index == 3;
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildOnboardingPage(
                        title: 'Bienvenue sur IBAMEDT',
                        description:
                            'Gérez facilement vos emplois du temps à l\'IBAM',
                        lottieAnimPath: _lottieAnimations[0],
                        fallbackImagePath: 'images/welcome.png',
                        textColor: Colors.white,
                        pageIndex: 0,
                      ),
                      _buildOnboardingPage(
                        title: 'Pour les étudiants',
                        description:
                            'Consultez votre emploi du temps hebdomadaire et recevez des notifications pour vos cours',
                        lottieAnimPath: _lottieAnimations[1],
                        fallbackImagePath: 'images/students.png',
                        textColor: Colors.white,
                        pageIndex: 1,
                      ),
                      _buildOnboardingPage(
                        title: 'Pour les enseignants',
                        description:
                            'Gérez vos disponibilités et vos cours programmés en toute simplicité',
                        lottieAnimPath: _lottieAnimations[2],
                        fallbackImagePath: 'images/teachers.png',
                        textColor: Colors.black87,
                        pageIndex: 2,
                      ),
                      _buildOnboardingPage(
                        title: 'Pour l\'administration',
                        description:
                            'Planifiez et organisez les cours en fonction des disponibilités des enseignants',
                        lottieAnimPath: _lottieAnimations[3],
                        fallbackImagePath: 'images/admin.png',
                        textColor: Colors.white,
                        pageIndex: 3,
                      ),
                    ],
                  ),
                ),

                // Navigation et indicateurs
                _buildNavigationControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour construire chaque page d'onboarding avec animations
  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required String lottieAnimPath,
    required String fallbackImagePath,
    required Color textColor,
    required int pageIndex,
  }) {
    return SizedBox(
      width: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animation d'entrée pour l'illustration
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: _buildIllustration(lottieAnimPath, fallbackImagePath),
                ),
              ),

              const SizedBox(height: 40),

              // Animation d'entrée pour le titre
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.3, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0.2, 0.7, curve: Curves.easeOut),
                  ),
                ),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.2, 0.7, curve: Curves.easeIn),
                    ),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: textColor,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(1, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Animation d'entrée pour la description
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0.4, 0.9, curve: Curves.easeOut),
                  ),
                ),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.4, 0.9, curve: Curves.easeIn),
                    ),
                  ),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 18,
                      color: textColor.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Essaye de charger une animation Lottie, sinon utilise l'image statique
  Widget _buildIllustration(String lottieAnimPath, String fallbackImagePath) {
    return Hero(
      tag: 'onboarding_illustration_$_currentPage',
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.8, end: 1.0),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: _tryLoadLottie(lottieAnimPath, fallbackImagePath),
        ),
      ),
    );
  }

  // Tentative de chargement d'une animation Lottie avec fallback sur image
  Widget _tryLoadLottie(String lottieAnimPath, String fallbackImagePath) {
    try {
      return Lottie.asset(
        lottieAnimPath,
        fit: BoxFit.contain,
        repeat: true,
        errorBuilder: (context, error, stackTrace) {
          // En cas d'échec, utiliser l'image statique
          return Image.asset(fallbackImagePath, fit: BoxFit.contain);
        },
      );
    } catch (e) {
      // En cas d'exception, utiliser l'image statique
      return Image.asset(fallbackImagePath, fit: BoxFit.contain);
    }
  }

  // Construire les contrôles de navigation avec animations
  Widget _buildNavigationControls() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Indicateur de page amélioré
          SmoothPageIndicator(
            controller: _controller,
            count: 4,
            effect: WormEffect(
              activeDotColor: _currentPage == 2 ? Colors.black87 : Colors.white,
              dotColor: (_currentPage == 2 ? Colors.black87 : Colors.white)
                  .withOpacity(0.3),
              dotHeight: 10,
              dotWidth: 10,
              spacing: 8,
              strokeWidth: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // Boutons de navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bouton Précédent
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: _currentPage > 0 ? value : 0.3,
                    child: ElevatedButton.icon(
                      onPressed:
                          _currentPage > 0
                              ? () {
                                _controller.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                                HapticFeedback.lightImpact();
                              }
                              : null,
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('Précédent'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            _currentPage == 2 ? Colors.black87 : Colors.white,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: (_currentPage == 2
                                    ? Colors.black87
                                    : Colors.white)
                                .withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Bouton Suivant / Commencer
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.9, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isLastPage) {
                          // Animation avant de naviguer vers l'écran de connexion
                          _animateTransition(() {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const LoginScreen(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  var begin = const Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.easeInOutQuart;
                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(
                                  milliseconds: 800,
                                ),
                              ),
                            );
                          });
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          HapticFeedback.lightImpact();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: _backgroundGradients[_currentPage][0],
                        backgroundColor:
                            _currentPage == 2 ? Colors.black87 : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isLastPage ? 'Commencer' : 'Suivant',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _isLastPage ? Icons.login : Icons.arrow_forward,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Création d'effets de particules flottantes pour l'arrière-plan
  List<Widget> _buildFloatingParticles() {
    final random = math.Random();
    final List<Widget> particles = [];

    // Générer des particules aléatoires
    for (int i = 0; i < 20; i++) {
      final size = random.nextDouble() * 10 + 5;
      final posX = random.nextDouble() * MediaQuery.of(context).size.width;
      final posY = random.nextDouble() * MediaQuery.of(context).size.height;
      final opacity = random.nextDouble() * 0.2 + 0.1;
      final duration = Duration(milliseconds: random.nextInt(5000) + 10000);
      final delay = Duration(milliseconds: random.nextInt(5000));

      particles.add(
        Positioned(
          left: posX,
          top: posY,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: delay,
            onEnd: () {},
            builder: (context, delayValue, child) {
              return Opacity(
                opacity: delayValue * opacity,
                child: TweenAnimationBuilder<Offset>(
                  tween: Tween<Offset>(
                    begin: Offset(posX / 100, posY / 100),
                    end: Offset(posX / 100 + 0.1, posY / 100 - 0.1),
                  ),
                  duration: duration,
                  builder: (context, offset, child) {
                    return Transform.translate(
                      offset: Offset(offset.dx * 50, offset.dy * 50),
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
    }

    return particles;
  }

  // Animation de transition avant de naviguer vers l'écran suivant
  void _animateTransition(VoidCallback onComplete) {
    // Effet de vibration tactile
    HapticFeedback.mediumImpact();

    // Séquence d'animation pour une transition fluide
    _animationController.reset();
    _animationController.duration = const Duration(milliseconds: 400);
    _animationController.forward().then((_) {
      onComplete();
    });
  }
}
