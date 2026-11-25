import 'package:flutter/material.dart';
import 'package:aplikasi_tokped/features/cart/data/cart_controller.dart';
import 'package:aplikasi_tokped/features/product/presentation/pages/product_detail_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  // sama seperti _toDetail di home_page
  MockProductItem _toDetail(CartEntry entry) {
    final item = entry.item;
    return MockProductItem(
      title: item.title,
      description: item.description,
      price: item.price,
      discountPercentage: item.discountPercentage,
      rating: item.rating,
      stock: item.stock,
      brand: item.brand,
      category: item.category,
      sku: item.sku,
      thumbnail: item.thumbnail,
      images: item.images.isNotEmpty ? item.images : [item.thumbnail],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;

    // setiap isi keranjang berubah, halaman ini otomatis ikut ter-update
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF165F42),
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: const Text(
              'Keranjang Saya',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: cart.isEmpty
              ? _buildEmpty()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.entries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) =>
                      _buildCartCard(context, cart, cart.entries[i]),
                ),
          bottomNavigationBar: cart.isEmpty
              ? null
              : _buildBottomBar(context, cart),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('Keranjang masih kosong'),
        ],
      ),
    );
  }

  Widget _buildCartCard(
    BuildContext context,
    CartController cart,
    CartEntry entry,
  ) {
    final item = entry.item;
    final hasDiscount = item.discountPercentage > 0;

    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Klik produk bakal nampilin detail produk
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                product: _toDetail(entry),
                shoppingItem: item,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 12, 12),
          child: Row(
            children: [
              // Checkbox di kiri card
              Checkbox(
                value: entry.isSelected,
                activeColor: const Color(0xFF165F42),
                onChanged: (value) =>
                    cart.toggleSelected(entry, value ?? false),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.thumbnail,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 72,
                    height: 72,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatRupiah(entry.unitPrice),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (hasDiscount)
                      Text(
                        formatRupiah(item.price),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _buildQuantityStepper(cart, entry),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityStepper(CartController cart, CartEntry entry) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepperButton(
            // Kalau jumlahnya 1, hapus dari keranjang
            icon: entry.quantity == 1 ? Icons.delete_outline : Icons.remove,
            onPressed: () => cart.decrease(entry),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${entry.quantity}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          _stepperButton(
            icon: Icons.add,
            onPressed: entry.quantity < entry.item.stock
                ? () => cart.increase(entry)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({required IconData icon, VoidCallback? onPressed}) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 18,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      onPressed: onPressed,
    );
  }

  // bar checkbox semua, total harga barang yang dicentang, tombol checkout
  Widget _buildBottomBar(BuildContext context, CartController cart) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Checkbox(
                value: cart.allSelected,
                activeColor: const Color(0xFF165F42),
                onChanged: (value) => cart.toggleAll(value ?? false),
              ),
              const Text('Semua'),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    formatRupiah(cart.selectedTotal),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF165F42),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: cart.selectedCount > 0
                    ? () {
                        // Checkout barang dikeranjang
                      }
                    : null,
                child: Text('Checkout (${cart.selectedCount})'),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
