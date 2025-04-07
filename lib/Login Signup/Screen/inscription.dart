import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibamedt/Login%20Signup/Widget/button.dart';
import '../../Screen/Acceuil.dart';
import '../Services/authentication.dart';
import '../Widget/snackbar.dart';
import '../Widget/text_field.dart';
import 'connexion.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();

  // Contrôleur de page pour l'onboarding
  final PageController _pageController = PageController();
  final int _currentPage = 0;

  // Pour l'animation de transition entre les champs
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Listeners pour les transitions de focus
    _nameFocus.addListener(() {
      if (_nameFocus.hasFocus) setState(() {});
    });
    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) setState(() {});
    });
    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) setState(() {});
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    _animationController.dispose();
    _pageController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void signupUser() async {
    if (!_formKey.currentState!.validate()) {
      // Vibrer légèrement pour indiquer une erreur
      _animationController.forward(from: 0.0);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String res = await AuthMethod().signupUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (res == "success") {
        // Animation de succès avant la redirection
        _showSuccessDialog();
      } else {
        _animationController.forward(from: 0.0);
        showSnackBar(context, res);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      _animationController.forward(from: 0.0);

      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          showSnackBar(context, "Cet email est déjà utilisé.");
        } else if (e.code == 'invalid-email') {
          showSnackBar(context, "Email invalide.");
        } else if (e.code == 'weak-password') {
          showSnackBar(context, "Le mot de passe est trop faible.");
        } else {
          showSnackBar(
            context,
            "Erreur lors de l'inscription. Veuillez réessayer.",
          );
        }
      } else {
        showSnackBar(context, "Une erreur est survenue. Veuillez réessayer.");
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animation de succès personnalisée avec Flutter Animate
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Cercle extérieur qui pulse
                      Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.3),
                            ),
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .scaleXY(
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.easeInOut,
                            begin: 0.8,
                            end: 1.2,
                          ),

                      // Icône de succès au centre
                      Icon(Icons.check_circle, color: Colors.white, size: 100)
                          .animate()
                          .scaleXY(
                            delay: const Duration(milliseconds: 300),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.elasticOut,
                          )
                          .fade(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                      'Inscription réussie!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fade(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 500),
                    )
                    .slideY(begin: 0.5, end: 0),
              ],
            ),
          ),
    );

    // Attendre puis naviguer vers l'écran d'accueil
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(initialIndex: 0),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final offsetAnimation = Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0.02, 0),
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.elasticIn,
            ),
          );

          return SlideTransition(position: offsetAnimation, child: child);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: height / 2.8,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          child: Image.asset(
                            'images/signup.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Créez votre compte",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .animate()
                          .fade(duration: const Duration(milliseconds: 500))
                          .scale(),
                    ],
                  ).animate().slideY(
                    begin: -0.1,
                    end: 0,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutQuart,
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildInputField(
                      icon: Icons.person,
                      controller: nameController,
                      hintText: 'Entrez votre nom',
                      textInputType: TextInputType.text,
                      focusNode: _nameFocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre nom';
                        }
                        return null;
                      },
                      animation: 300,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildInputField(
                      icon: Icons.email,
                      controller: emailController,
                      hintText: 'Entrez votre email',
                      textInputType: TextInputType.emailAddress,
                      focusNode: _emailFocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Veuillez entrer un email valide';
                        }
                        return null;
                      },
                      animation: 400,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildInputField(
                      icon: Icons.lock,
                      controller: passwordController,
                      hintText: 'Entrez votre mot de passe',
                      textInputType: TextInputType.visiblePassword,
                      isPass: true,
                      focusNode: _passwordFocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                      onTogglePassword: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      isPasswordVisible: isPasswordVisible,
                      animation: 500,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildSignupButton().animate().slideY(
                    begin: 0.5,
                    end: 0,
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutQuad,
                  ),

                  const SizedBox(height: 50),

                  _buildLoginLink().animate().fadeIn(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required TextEditingController controller,
    required String hintText,
    required TextInputType textInputType,
    required FocusNode focusNode,
    required String? Function(String?) validator,
    bool isPass = false,
    Function()? onTogglePassword,
    bool isPasswordVisible = false,
    required int animation,
  }) {
    return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color:
                    focusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
              ),
              suffixIcon:
                  isPass
                      ? IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color:
                              focusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                        ),
                        onPressed: onTogglePassword,
                      )
                      : null,
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            keyboardType: textInputType,
            obscureText: isPass && !isPasswordVisible,
            validator: validator,
          ),
        )
        .animate()
        .slideX(
          begin: 0.5,
          end: 0,
          delay: Duration(milliseconds: animation),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuad,
        )
        .fade(
          begin: 0,
          end: 1,
          delay: Duration(milliseconds: animation),
          duration: const Duration(milliseconds: 500),
        );
  }

  Widget _buildSignupButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : signupUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                : const Text(
                  "S'inscrire",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Vous avez déjà un compte ?",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
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
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          },
          child: Text(
            " Se connecter",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
