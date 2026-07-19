import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final String number;
  final String name;
  final IconData icon;
  const AdditionalInfo({
    super.key,
    required this.number,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(icon),
          Text(name),
          Text(number, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
