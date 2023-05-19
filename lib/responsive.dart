import 'package:flutter/material.dart';

class Responsive extends StatelessWidget{
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({Key? key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context){
    return MediaQuery.of(context).size.width<480;
  }
  static bool isMediumScreen(BuildContext context){
    return MediaQuery.of(context).size.width>=480 && MediaQuery.of(context).size.width<=1100;
  }
  static bool isLargeScreen(BuildContext context){
    return MediaQuery.of(context).size.width>=1100;
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context,constraints){
          if(constraints.maxWidth>=1100){
            return desktop;
          }else if(constraints.maxWidth >= 480){
            return tablet;
          }else{
            return mobile;
          }
        }
    );
  }


}