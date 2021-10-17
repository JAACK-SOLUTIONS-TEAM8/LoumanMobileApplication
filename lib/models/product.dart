class Product {
  final int productId;
  final int productTypeId;
  final String productName;
  final int productSizeId;
  final String productSizeDescription;
  final String productTypeName;
  final int productQuantity;
  final int stockId;
  final int price;
  final String productImage;

  Product(
      {required this.productId,
      required this.productName,
      required this.productSizeId,
      required this.productTypeId,
      required this.productSizeDescription,
      required this.productTypeName,
      required this.productImage,
      required this.productQuantity,
      required this.price,
      required this.stockId});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        productId: json['productId'],
        productName: json['productName'],
        productSizeId: json['productSizeId'],
        productTypeId: json['productTypeId'],
        productSizeDescription: json['productSizeDescription'],
        productTypeName: json['productTypeName'],
        productImage: json['productImage'],
        productQuantity: json['productQuantity'],
        price: json['price'],
        stockId: json['stockId']);
  }
}
