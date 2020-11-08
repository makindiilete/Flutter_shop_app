import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      // we call d parent constructor (MaterialPageRoute) passing in the args defined in ds class ( : base() c# syntax)
      : super(builder: builder, settings: settings);

  // here we override the animations of MaterialPageRoute
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // if the route bin loaded is the first route bin pushed to the screen, we add no animation
    if (settings.isInitialRoute) {
      return child;
    }
    // else we use FadeTransition to animate the route switch
    else {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
  }
}

//U need this class to set all route navigation to the custom defined route with custom animation
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  // here we override the animations of MaterialPageRoute
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // if the route bin loaded is the first route bin pushed to the screen, we add no animation
    if (route.settings.isInitialRoute) {
      return child;
    }
    // else we use FadeTransition to animate the route switch
    else {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
  }
}
