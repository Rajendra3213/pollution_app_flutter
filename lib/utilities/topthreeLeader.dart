import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopThreeDisplay extends StatelessWidget {
  final List<Map<String, dynamic>> topThreeData;

  const TopThreeDisplay({Key? key, required this.topThreeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter topThreeData to get only first names
    final filteredData = topThreeData.where((element) => element.containsKey('name')).map((element) => {'name': element['name'].split(' ').first}).toList();

    return Center( // Center the entire widget
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end, // Align to bottom
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          _buildPositionContainer(
            position: 2,
            name: filteredData.length >= 2 ? filteredData[1]['name'] : '',
            isSecond: true,
          ),
          _buildPositionContainer(
            position: 1,
            name: filteredData.length >= 1 ? filteredData[0]['name'] : '',
            isWinner: true,
          ),
          _buildPositionContainer(
            position: 3,
            name: filteredData.length >= 3 ? filteredData[2]['name'] : '',
          ),
        ],
      ),
    );
  }

  Widget _buildPositionContainer({
    required int position,
    required String name,
    bool isWinner = false,
    bool isSecond = false,
  }) {

    Color containerColor = Colors.white; // Default container color

    switch (position) {
      case 1:
        containerColor = Colors.green.withOpacity(0.9); // Green tint for winner
        break;
      case 2:
        containerColor = Colors.orange.withOpacity(0.9); // Yellow tint for second
        break;
      default:
        containerColor = Colors.red.withOpacity(0.9);
        break;
    }

    IconData iconData = Icons.wine_bar_sharp; // Default icon

    switch (position) {
      case 1:
        iconData = Icons.star; // Use star icon for winner
        break;
      case 2:
        iconData = Icons.wine_bar_sharp;
        // Use trophy icon for second
        break;
      default:
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min, // Set minimum size
      children: [
        Container(
          decoration: BoxDecoration(
            // Remove unnecessary decoration for the icon container
          ),
          child: Icon(
            iconData,
            size: 24.0,
            color: containerColor,// Adjust icon size as needed
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 80.0,
            height: (isWinner) ? 100.0 : isSecond ? 80.0 : 40, // Use ternary operator for cleaner conditional height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10.0),
              color: isWinner ? Colors.green.withOpacity(0.2) : null, // Green tint for winner
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(name,
                style: TextStyle( // Customize text style (optional)
                  fontSize: 12.0,
                  color: Colors.black,
                ),),
            ),
          ),
        ),
      ],
    );
  }
}