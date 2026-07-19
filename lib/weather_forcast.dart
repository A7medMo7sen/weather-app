import 'package:flutter/material.dart';

class WeatherForcast extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  const WeatherForcast({
    super.key,
    required this.time,
    required this.temp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          
          child: Column(
            children: [
              Text(time, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Icon(icon, size: 30,),
              Text(temp)
            ],
          ),
        ),
      ),
    );
    // return Card(
    //   elevation: 6,

    //   child: Container(
    //     width: 100,
    //     padding: EdgeInsets.all(10),
    //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
    //     child: Column(
    //       children: [
    //         Text(
    //           time,
    //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    //         ),
    //         Icon(icon, size: 30),
    //         Text(temp),
    //       ],
    //     ),
    //   ),
    // );
  }
}
