import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final num price;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback onBuy;

  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.onTap,
    required this.onBuy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Gagal memuat gambar'));
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                NumberFormat.simpleCurrency(locale: 'id_ID', name: 'Rp ', decimalDigits: 0)
                    .format(price),
                style: const TextStyle(fontSize: 14, color: Colors.green),
              ),
              const SizedBox(height: 4),
              Expanded( 
                child: Text(
                  description.length > 50
                      ? description.substring(0, 50) + '...'
                      : description,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              ElevatedButton(
                onPressed: onBuy,
                child: const Text('Beli'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
