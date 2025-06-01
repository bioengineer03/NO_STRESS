import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HealthCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String unit;
  final VoidCallback onTap;

  const HealthCard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.unit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Left: Title and value
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Time Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: Colors.orange, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Value + Unit
                  Row(
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right: Mini bar chart + arrow
            Column(
              children: [
                Row(
                  children: [
                    _buildBar(25),
                    _buildBar(40),
                    _buildBar(30),
                    _buildBar(15),
                    _buildBar(45),
                    _buildBar(50, color: Colors.orange),
                  ],
                ),
                const SizedBox(height: 6),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double height, {Color color = Colors.grey}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.6),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}