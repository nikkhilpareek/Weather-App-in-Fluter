import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({super.key, required this.time, required this.Temperature, required this.icon,});
  final String time;
  final String Temperature;
  final IconData icon;



  @override
  Widget build(BuildContext context) {
    return Card(
                      elevation: 6,
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(
                          children: [
                            Text(
                              time,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8,),
                            Icon(
                              icon,
                              size: 32,
                            ),
                            const SizedBox(height: 8,),
                            Text(
                              Temperature,
                            ),
                          ],
                        ),
                      ),
                    );
  }

}