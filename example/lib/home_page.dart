import 'package:flutter/material.dart';
import 'package:scaled_list/scaled_list.dart';
import 'data.dart';
import 'sizeConfig.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: ScaledList(
            itemCount: Data.categories.length,
            itemColor: (index) {
              return kMixedColors[index % kMixedColors.length];
            },
            itemBuilder: (index, selectedIndex) {
              final category = Data.categories[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: selectedIndex == index
                        ? getRelativeHeight(0.14)
                        : getRelativeHeight(0.11),
                    child: Image.asset(category.image),
                  ),
                  SizedBox(height: getRelativeHeight(0.015)),
                  Text(
                    category.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: selectedIndex == index
                            ? getRelativeWidth(0.06)
                            : getRelativeWidth(0.05)),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
