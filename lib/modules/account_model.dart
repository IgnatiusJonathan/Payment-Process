import 'package:flutter/material.dart';

class UserAccount {
  final String name;
  final String phoneNumber;
  final String email;
  final String profileImage;
  final double balance;
  final String memberSince;

  UserAccount({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.profileImage,
    required this.balance,
    required this.memberSince,
  });
}

class AccountMenu {
  final String title;
  final IconData icon;
  final String route;

  AccountMenu({
    required this.title,
    required this.icon,
    required this.route,
  });
}