import 'package:flutter/material.dart';

@immutable
class TypeScale {
  const TypeScale({
    required this.regular,
    required this.medium,
    required this.semibold,
    required this.bold,
  });

  final TextStyle regular;
  final TextStyle medium;
  final TextStyle semibold;
  final TextStyle bold;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is TypeScale &&
        other.regular == regular &&
        other.medium == medium &&
        other.semibold == semibold &&
        other.bold == bold;
  }

  @override
  int get hashCode => regular.hashCode ^ medium.hashCode ^ semibold.hashCode ^ bold.hashCode;
}
