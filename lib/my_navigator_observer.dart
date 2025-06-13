import 'package:flutter/material.dart';

class MyNavigatorObserver extends NavigatorObserver {
  static final List<Route<dynamic>> _routeStack = [];

  static List<Route<dynamic>> get currentStack => List.unmodifiable(_routeStack);

  @override
  void didPush(Route route, Route? previousRoute) {
    _routeStack.add(route);
    _printStack("PUSH");
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _routeStack.remove(route);
    _printStack("POP");
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _routeStack.remove(route);
    _printStack("REMOVE");
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    int index = _routeStack.indexOf(oldRoute!);
    if (index >= 0) {
      _routeStack[index] = newRoute!;
    }
    _printStack("REPLACE");
  }

  void _printStack(String action) {
    debugPrint("=== Navigation Stack after $action ===");
    for (var route in _routeStack) {
      debugPrint(route.settings.name ?? route.toString());
    }
    debugPrint("===========================");
  }
}
