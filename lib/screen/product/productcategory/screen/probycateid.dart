import 'package:flutter/material.dart';
import 'package:mycourse_flutter/model/category.dart';
import 'package:mycourse_flutter/model/response/productbycategorymodel.dart';
import 'package:mycourse_flutter/screen/product/productcategory/logic/procategorypresentor.dart';
import 'package:mycourse_flutter/screen/product/productcategory/logic/procategoryview.dart';

class Probycateidpage extends StatefulWidget {
  final Categories categories;
  const Probycateidpage({super.key, required this.categories});

  @override
  State<Probycateidpage> createState() => _ProbycateidState();
}

class _ProbycateidState extends State<Probycateidpage>
    implements ProCategoryview {
  late String title = widget.categories.title;
  late String id = widget.categories.id.toString();
  late ProductBycategorymodel productBycategorymodels;
  late Procategorypresentor procategorypresentor;
  late List<ProductBycategorymodel> productByCategory;
  late bool isloading;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    procategorypresentor = Procategorypresentor(this);
    procategorypresentor.proBycategoryid(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //"Product By $title" for adding text with index
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: isloading
            ? const CircularProgressIndicator()
            : productByCategory.isEmpty
                ? const Text("No product found")
                : GridView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.68,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemCount: productByCategory.length,
                    itemBuilder: (context, index) {
                      ProductBycategorymodel product = productByCategory[index];
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/detailproduct',
                                arguments: product.id);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.network(
                                  product.imageurl,
                                  height: 142,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                        child: Icon(Icons.error,
                                            color: Colors.red));
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "\$${product.price}",
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  @override
  void onLoading(bool loading) {
    // TODO: implement onLoading
    setState(() {
      isloading = loading;
    });
  }

  @override
  void onStringResponse(String str) {
    // TODO: implement onStringResponse
    // Handle string response
  }

  @override
  void onResponse(List<ProductBycategorymodel> response) {
    // TODO: implement onResponse
    setState(() {
      // print(response);
      productByCategory = response;
    });
  }
}
