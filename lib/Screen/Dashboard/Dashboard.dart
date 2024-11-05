import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:tanismart/Screen/Dashboard/ChangePasswordSheet.dart';
import 'package:tanismart/Screen/Dashboard/ProductCard.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String username = '';
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('registeredName') ?? 'Pengguna';
    });
  }

  Future<void> _logout() async {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<void> _saveAccount(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registeredUsername', username);
    await prefs.setString('registeredPassword', password);
  }

  void _showChangePasswordSheet() {
    final TextEditingController passwordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ChangePasswordSheet(
          passwordController: passwordController,
          onChangePassword: () async {
            String newPassword = passwordController.text;
            await _saveAccount(username, newPassword);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password berhasil diganti!')),
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> products = [
    {
      'name': 'Pupuk Organik',
      'price': 100000,
      'description': 'Pupuk yang tersusun dari materi-materi makluk hidup.',
      'image': 'https://api.hkks.shop/uploads/pupuk-1730815482205.jpg'
    },
    {
      'name': 'Bibit Padi',
      'price': 200000,
      'description': 'Gabah yang dipanen untuk input usaha pertanian',
      'image': 'https://api.hkks.shop/uploads/bibt_padi-1730815482217.jpg'
    },
    {
      'name': 'Traktor',
      'price': 35000000,
      'description': 'Traktor yang digunakan untuk mengangkut bibit padi',
      'image': 'https://api.hkks.shop/uploads/traktor-1730815482217.jpg'
    },
    {
      'name': 'Cangkul',
      'price': 40000,
      'description': 'Cangkul yang digunakan untuk mengangkut bibit padi',
      'image': 'https://api.hkks.shop/uploads/cangkul-1730815482217.jpg'
    },
    {
      'name': 'Penyubur Tanaman',
      'price': 250000,
      'description': 'Cangkul yang digunakan untuk mengangkut bibit padi',
      'image': 'https://api.hkks.shop/uploads/penyubur-1730815482205.jpg'
    },
    {
      'name': 'Bibit Kopi',
      'price': 400000,
      'description': 'Cangkul yang digunakan untuk mengangkut bibit padi',
      'image': 'https://api.hkks.shop/uploads/bibit_kopi-1730815482205.jpg'
    },
  ];

  void _showProductDetails(String name, String description) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addToCart(int price) {
    setState(() {
      totalPrice += price;
    });
  }

  void _resetTotal() {
    setState(() {
      totalPrice = 0; 
    });
  }
void _showPaymentModal() {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: isKeyboardVisible ? 200.0 : 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Form Pembayaran',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total yang harus dibayar: ${NumberFormat.simpleCurrency(locale: 'id_ID', name: 'Rp ', decimalDigits: 0).format(totalPrice)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(text: username),
                    decoration: InputDecoration(
                      labelText: 'Nama Pemilik Kartu',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: cardNumberController,
                    decoration: InputDecoration(
                      labelText: 'Nomor Kartu',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: paymentController,
                    decoration: InputDecoration(
                      labelText: 'Jumlah Uang Dibayarkan',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        String cardNumber = cardNumberController.text;
                        String payment = paymentController.text;

                        // Validasi input
                        if (totalPrice == 0) {
                          Fluttertoast.showToast(
                            msg: 'Tidak bisa membayar karena tidak ada tagihan!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }

                        if (cardNumber.isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Nomor kartu tidak boleh kosong!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }

                        if (!RegExp(r'^[0-9]+$').hasMatch(cardNumber)) {
                          Fluttertoast.showToast(
                            msg: 'Nomor kartu hanya boleh berisi angka!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }

                        if (payment.isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Jumlah uang dibayarkan tidak boleh kosong!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }

                        if (!RegExp(r'^[0-9]+$').hasMatch(payment)) {
                          Fluttertoast.showToast(
                            msg: 'Jumlah uang harus berupa angka!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }

                        int paymentAmount = int.parse(payment);
                        if (paymentAmount < totalPrice) {
                          Fluttertoast.showToast(
                            msg: 'Jumlah uang dibayarkan kurang!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }

                        // Hitung kembalian
                        int change = paymentAmount - totalPrice;

                        // Menampilkan dialog loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        );

                        await Future.delayed(const Duration(seconds: 2));

                        Navigator.pop(context); // Tutup dialog loading

                        Fluttertoast.showToast(
                          msg: 'Pembayaran berhasil! Kembalian: ${NumberFormat.simpleCurrency(locale: 'id_ID', name: 'Rp ', decimalDigits: 0).format(change)}',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );

                        Navigator.pop(context); // Tutup modal pembayaran
                      },
                      child: const Text('Bayar'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          "Tanishmart",
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Row(
                children: [
                  Icon(Icons.store, color: Colors.white, size: 40),
                  SizedBox(width: 10),
                  Text(
                    'Tanishmart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call Center'),
              onTap: () async {
                const phoneNumber =
                    '6282257281804'; 
                final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
                if (await canLaunchUrl(launchUri)) {
                  await launchUrl(launchUri);
                } else {
                  throw 'Could not launch $phoneNumber';
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('SMS Center'),
              onTap: () async {
                const smsNumber =
                    '+6282257281804'; 
                const message =
                    'Halo Tanishmart.';
                final Uri launchUri = Uri(
                  scheme: 'sms',
                  path: smsNumber,
                  queryParameters: {
                    'body': message,
                  },
                );

                if (await canLaunchUrl(launchUri)) {
                  await launchUrl(launchUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch SMS')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Lokasi/Maps'),
              onTap: () async {
               
                final String googleMapsUrl =
                    'comgooglemaps://?q=-6.98173427581787,110.409118652344';
                final String fallbackUrl =
                    'https://www.google.com/maps?q=-6.98173427581787,110.409118652344';

               
                final Uri uri = Uri.parse(googleMapsUrl);

                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
              
                  final Uri fallbackUri = Uri.parse(fallbackUrl);
                  if (await canLaunchUrl(fallbackUri)) {
                    await launchUrl(fallbackUri);
                  } else {
                    throw 'Could not launch $fallbackUrl';
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text('Ganti Password'),
              onTap: () {
                Navigator.pop(context);
                _showChangePasswordSheet();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            bottom: 1.0), 
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Halo, $username',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: _logout,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Produk Kami',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    name: product['name'],
                    price: product['price'],
                    description: product['description'],
                    imageUrl: product['image'],
                    onTap: () => _showProductDetails(
                        product['name'], product['description']),
                    onBuy: () {
                      _addToCart(product['price']);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 7.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.payment, color: Colors.white),
                  onPressed: () {
                    _showPaymentModal(); 
                  },
                ),
                Text(
                  'Total: ${NumberFormat.simpleCurrency(locale: 'id_ID', name: 'Rp ', decimalDigits: 0).format(totalPrice)}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _resetTotal,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPaymentModal, 
        tooltip: 'Pembayaran',

        elevation: 10,

        shape: const StadiumBorder(),

        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.payment),
      ),
    );
  }
}
