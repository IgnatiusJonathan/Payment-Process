import 'package:flutter/material.dart';
import '../modules/account_model.dart';
import '../widgets/account_widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final UserAccount user = UserAccount(
    name: 'John Doe',
    phoneNumber: '+62 812-3456-7890',
    email: 'johndoe@example.com',
    profileImage: 'https://via.placeholder.com/150',
    balance: 2500000.0,
    memberSince: '2023',
  );

  final List<AccountMenu> menus = [
    AccountMenu(
      title: 'Profil Saya',
      icon: Icons.person,
      route: '/profile',
    ),
    AccountMenu(
      title: 'Dompet Digital',
      icon: Icons.wallet,
      route: '/wallet',
    ),
    AccountMenu(
      title: 'Riwayat Transaksi',
      icon: Icons.history,
      route: '/history',
    ),
    AccountMenu(
      title: 'Transfer',
      icon: Icons.swap_horiz,
      route: '/transfer',
    ),
    AccountMenu(
      title: 'Top Up',
      icon: Icons.add_circle,
      route: '/topup',
    ),
    AccountMenu(
      title: 'Pembayaran',
      icon: Icons.payment,
      route: '/payment',
    ),
    AccountMenu(
      title: 'Promo & Voucher',
      icon: Icons.local_offer,
      route: '/promo',
    ),
    AccountMenu(
      title: 'Keamanan',
      icon: Icons.security,
      route: '/security',
    ),
    AccountMenu(
      title: 'Bantuan',
      icon: Icons.help,
      route: '/help',
    ),
    AccountMenu(
      title: 'Pengaturan',
      icon: Icons.settings,
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Akun Saya'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              name: user.name,
              phoneNumber: user.phoneNumber,
              profileImage: user.profileImage,
              balance: user.balance,
            ),
            const SizedBox(height: 16),
            // Menu Items
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ...menus.map((menu) => Column(
                    children: [
                      MenuItem(
                        title: menu.title,
                        icon: menu.icon,
                        onTap: () {
                          _handleMenuTap(menu.route);
                        },
                      ),
                      if (menus.indexOf(menu) != menus.length - 1)
                        const Divider(height: 1, indent: 70),
                    ],
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Logout Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _showLogoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Keluar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _handleMenuTap(String route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $route'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Keluar Akun'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil keluar'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}