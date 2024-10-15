import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mycourse_flutter/model/productgallary.dart';
import 'package:mycourse_flutter/model/response/productbycategorymodel.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductBycategorymodel productdetail;
  const ProductDetailPage({super.key, required this.productdetail});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late String imgurl = widget.productdetail.imageurl.toString();
  late String productname = widget.productdetail.name.toString();
  late String productprice = widget.productdetail.price.toString();
  late String productdescription = widget.productdetail.description.toString();
  final List<Productgallary> _galleryImageUrls = [];
  int _quantity = 1;

  final PageController _galleryPageController = PageController();
  int _currentGalleryPage = 0;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _galleryPageController.addListener(
      () {
        int nextPage = _galleryPageController.page!.round();
        if (nextPage != _currentGalleryPage) {
          setState(() {
            _currentGalleryPage = nextPage;
          });
        }
      },
    );
    _galleryImageUrls.addAll(widget.productdetail.gallary);
  }

  @override
  void dispose() {
    _galleryPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Product Details'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 6),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  // Main product image
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(imgurl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Product details and action buttons
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Container with highlight behind product name
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              productname,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Container with highlight behind product price
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '\$$productprice',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          HtmlWidget(
                            productdescription,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Custom amount display with different colors
                              Row(
                                children: [
                                  const Text(
                                    'Amount: ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors
                                          .blueGrey, // Color for "Amount:"
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors
                                          .deepOrange, // Color for the quantity number
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  // Customized Decrease Button
                                  _buildQuantityButton(
                                    icon: Icons.remove,
                                    color: Colors.redAccent,
                                    onPressed: _decrementQuantity,
                                  ),
                                  const SizedBox(width: 10),
                                  // Customized Increase Button
                                  _buildQuantityButton(
                                    icon: Icons.add,
                                    color: Colors.teal,
                                    onPressed: _incrementQuantity,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Custom Add to Cart Button with Icon
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.green, Colors.teal],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.add_shopping_cart,
                                  color: Colors.white),
                              label: const Text(
                                'Add to Cart',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // Transparent background for gradient
                                elevation: 0, // Remove default elevation
                                padding: EdgeInsets.zero, // Use custom padding
                              ),
                              onPressed: () {
                                // Add to cart functionality can be implemented here
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Gallery of additional images
                  SizedBox(
                    height: 140,
                    child: PageView.builder(
                      controller: _galleryPageController,
                      itemCount: _galleryImageUrls.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(
                                  _galleryImageUrls[index].imageurl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildGalleryIndicators(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        splashRadius: 30,
      ),
    );
  }

  Widget _buildGalleryIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _galleryImageUrls.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentGalleryPage == index ? 12 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: _currentGalleryPage == index ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
