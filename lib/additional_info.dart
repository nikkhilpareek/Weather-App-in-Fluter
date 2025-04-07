import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
   

  const AdditionalInfo({
    super.key, required this.icon, required this.label, required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32,),
        SizedBox(height: 8,),
        Text(label,),
        SizedBox(height: 8,),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )
        )
      ],
    );
  }
}


