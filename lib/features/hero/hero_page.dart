import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeroPage extends StatefulWidget {
  const HeroPage({super.key, required this.title, required this.description});
  final String title;
  final String description;

  @override
  State<HeroPage> createState() => _HeroPageWidgetState();
}

class _HeroPageWidgetState extends State<HeroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              Text(
                widget.description,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              SvgPicture.asset(
                'assets/images/hero.svg',
                semanticsLabel: 'Hero page image',
                width: 500,
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.lightBlue.shade100,
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.blue.shade800,
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.lightBlue.shade100,
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.blue.shade800,
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: Text(
                    'Register Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
