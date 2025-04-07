import 'package:flutter/material.dart';
import 'dart:math' show sin;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ibamedt/Screen/Acceuil.dart';
import 'package:ibamedt/Login%20With%20Google/google_auth.dart';
import 'package:ibamedt/Screen/edt.dart';
import '../Services/authentication.dart';
import '../Widget/snackbar.dart';
import '../Widget/text_field.dart';
import 'package:ibamedt/Login%20Signup/Screen/inscription.dart';
import '../Widget/button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ibamedt/Password%20Forgot/forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscureText = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isFormFilled = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    emailController.addListener(_updateFormState);
    passwordController.addListener(_updateFormState);

    _emailFocus.addListener(() {
      setState(() {});
    });

    _passwordFocus.addListener(() {
      setState(() {});
    });
  }

  void _updateFormState() {
    String email = emailController.text;
    bool emailValid =
        email.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

    String password = passwordController.text;
    bool passwordValid = password.isNotEmpty;

    setState(() {
      _isEmailValid = emailValid;
      _isPasswordValid = passwordValid;
      _isFormFilled = emailValid && passwordValid;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void loginUser() async {
    if (!_formKey.currentState!.validate()) {
      _animateError();
      return;
    }

    setState(() => isLoading = true);

    try {
      String res = await AuthMethod().loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      setState(() => isLoading = false);

      if (res == "success") {
        _showSuccessDialog();
      } else {
        _animateError();
        showSnackBar(context, res);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _animateError();
      showSnackBar(context, "Erreur d'authentification: ${e.toString()}");
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
                // Remplacer Lottie par une animation Flutter personnalisée
                _buildCustomSuccessAnimation(),
                const Text(
                  'Connexion réussie!',
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
                ),
              ],
            ),
          ),
    );

    // Rediriger vers la page d'accueil après un délai
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const EDTScreen()),
      );
    });
  }

  Widget _buildCustomSuccessAnimation() {
    return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.white,
            ),
          ),
        )
        .animate(
          onComplete: (controller) {
            controller.repeat(
              reverse: true,
              period: const Duration(milliseconds: 1500),
            );
          },
        )
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1.1, 1.1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
        )
        .then()
        .shimmer(
          duration: const Duration(milliseconds: 1000),
          delay: const Duration(milliseconds: 500),
          color: Colors.white.withOpacity(0.7),
        );
  }

  void _animateError() {
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: SafeArea(
                  child: AnimatedBuilder(
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

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Header avec animation
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  height: constraints.maxHeight / 3,
                                  width: constraints.maxWidth,
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
                                  child: Hero(
                                    tag: 'login_image',
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      ),
                                      child: Image.asset(
                                        'images/login.jpg',
                                        fit: BoxFit.cover,
                                      ),
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
                                        "Connectez-vous",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fade(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                    )
                                    .scale(),
                              ],
                            ).animate().slideY(
                              begin: -0.1,
                              end: 0,
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutQuart,
                            ),

                            const SizedBox(height: 20),

                            // Champ email
                            _buildInputFieldWithIndicator(
                              icon: Icons.email,
                              controller: emailController,
                              hintText: 'Entrez votre email',
                              textInputType: TextInputType.emailAddress,
                              focusNode: _emailFocus,
                              isValid: _isEmailValid,
                              hasValue: emailController.text.isNotEmpty,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre email';
                                }
                                bool emailValid = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value);
                                if (!emailValid) {
                                  return 'Veuillez entrer un email valide';
                                }
                                return null;
                              },
                              animation: 300,
                            ),

                            const SizedBox(height: 15),

                            // Champ mot de passe
                            _buildInputFieldWithIndicator(
                              icon: Icons.lock,
                              controller: passwordController,
                              hintText: 'Entrez votre mot de passe',
                              textInputType: TextInputType.visiblePassword,
                              isPass: true,
                              focusNode: _passwordFocus,
                              isValid: _isPasswordValid,
                              hasValue: passwordController.text.isNotEmpty,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre mot de passe';
                                }
                                return null;
                              },
                              onTogglePassword: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              isPasswordVisible: !_obscureText,
                              animation: 400,
                            ),

                            // Bouton Mot de passe oublié
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const ForgotPassword(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Mot de passe oublié ?',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Bouton de connexion
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed:
                                    _isFormFilled && !isLoading
                                        ? loginUser
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: _isFormFilled ? 8 : 0,
                                  shadowColor: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.5),
                                ),
                                child:
                                    isLoading
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        )
                                        : const Text(
                                          "Se connecter",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ).animate().slideY(
                              begin: 0.5,
                              end: 0,
                              delay: const Duration(milliseconds: 500),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutQuad,
                            ),

                            const SizedBox(height: 20),

                            // Divider
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                        color: Colors.black26,
                                        thickness: 1,
                                      )
                                      .animate()
                                      .fade(
                                        delay: const Duration(
                                          milliseconds: 400,
                                        ),
                                      )
                                      .slideX(begin: -0.2, end: 0),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    "ou",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                        color: Colors.black26,
                                        thickness: 1,
                                      )
                                      .animate()
                                      .fade(
                                        delay: const Duration(
                                          milliseconds: 400,
                                        ),
                                      )
                                      .slideX(begin: 0.2, end: 0),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Bouton Google
                            Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueGrey,
                                      foregroundColor: Colors.white,
                                      elevation: 3,
                                      shadowColor: Colors.grey.withOpacity(0.3),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      try {
                                        await FirebaseServices()
                                            .signInWithGoogle();

                                        if (!mounted) return;
                                        setState(() {
                                          isLoading = false;
                                        });

                                        _showSuccessDialog();
                                      } catch (e) {
                                        if (!mounted) return;
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showSnackBar(
                                          context,
                                          "Erreur de connexion Google: ${e.toString()}",
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Image.network(
                                            "https://ouch-cdn2.icons8.com/VGHyfDgzIiyEwg3RIll1nYupfj653vnEPRLr0AeoJ8g/rs:fit:456:456/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODg2/LzRjNzU2YThjLTQx/MjgtNGZlZS04MDNl/LTAwMTM0YzEwOTMy/Ny5wbmc.png",
                                            height: 35,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Flexible(
                                          child: Text(
                                            "Continue with Google",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .animate()
                                .fade(delay: const Duration(milliseconds: 600))
                                .scale(
                                  delay: const Duration(milliseconds: 600),
                                  duration: const Duration(milliseconds: 300),
                                ),

                            // Lien d'inscription
                            _buildSignupLink()
                                .animate()
                                .fade(delay: const Duration(milliseconds: 700))
                                .slideY(
                                  delay: const Duration(milliseconds: 700),
                                  begin: 0.2,
                                  end: 0,
                                ),

                            const SizedBox(
                              height: 20,
                            ), // Espace supplémentaire en bas
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputFieldWithIndicator({
    required IconData icon,
    required TextEditingController controller,
    required String hintText,
    required TextInputType textInputType,
    required FocusNode focusNode,
    required String? Function(String?) validator,
    required bool isValid,
    required bool hasValue,
    bool isPass = false,
    Function()? onTogglePassword,
    bool isPasswordVisible = false,
    required int animation,
  }) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
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
                onChanged: (value) {
                  setState(() {
                    if (isPass) {
                      _isPasswordValid = value.isNotEmpty;
                    } else {
                      _isEmailValid =
                          value.isNotEmpty &&
                          RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value);
                    }
                    _isFormFilled = _isEmailValid && _isPasswordValid;
                  });
                },
              ),
            ),
            if (hasValue)
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                child: Row(
                  children: [
                    Icon(
                      isValid ? Icons.check_circle : Icons.error,
                      color: isValid ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isValid
                          ? (isPass ? "Format valide" : "Format email valide")
                          : (isPass
                              ? "Format invalide"
                              : "Format email invalide"),
                      style: TextStyle(
                        color: isValid ? Colors.green : Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
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

  Widget _buildSignupLink() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              "Vous n'avez pas de compte ?",
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const SignupScreen(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    var begin = const Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.easeInOut;
                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "S'inscrire",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
