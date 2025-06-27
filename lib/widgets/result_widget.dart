import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  final String classification;

  const ResultWidget({Key? key, required this.classification})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isRecyclable = classification.toLowerCase() == 'recyclable';
    final Color resultColor = isRecyclable ? Colors.blue : Colors.green;
    final IconData resultIcon = isRecyclable ? Icons.recycling : Icons.eco;
    final String resultText =
        isRecyclable ? 'Recyclable Waste' : 'Organic Waste';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: resultColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: resultColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Icon(resultIcon, size: 60, color: resultColor),
          const SizedBox(height: 15),
          Text(
            'Classification Result:',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            resultText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: resultColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
