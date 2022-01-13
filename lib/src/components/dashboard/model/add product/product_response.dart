class ProductModel {

  ProductModel({this.productId, this.productName, this.isTaxEnable,
    this.variantId,
    this.weight,
    this.mrpPrice,
    this.price,
    this.discount,
    this.unitType,
    this.quantity,
    this.productType,
  });

  String productId;
  String productName;
  String isTaxEnable;
  String variantId;
  String weight;
  String mrpPrice;
  String price;
  String discount;
  String unitType;
  int quantity;
  int productType;
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    productId: json["product_id"] == null ? null : json["product_id"],
    productName: json["product_name"] == null ? null : json["product_name"],
    isTaxEnable: json["isTaxEnable"] == null ? null : json["isTaxEnable"],
    variantId: json["variant_id"] == null ? null : json["variant_id"],
    weight: json["weight"] == null ? null : json["weight"],
    mrpPrice: json["mrp_price"] == null ? null : json["mrp_price"],
    price: json["price"] == null ? null : json["price"],
    discount: json["discount"] == null ? null : json["discount"],
    unitType: json["unit_type"] == null ? null : json["unit_type"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    productType: json["product_type"] == null ? null : json["product_type"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId == null ? null : productId,
    "product_name": productName == null ? null : productName,
    "isTaxEnable": isTaxEnable == null ? null : isTaxEnable,
    "variant_id": variantId == null ? null : variantId,
    "weight": weight == null ? null : weight,
    "mrp_price": mrpPrice == null ? null : mrpPrice,
    "price": price == null ? null : price,
    "discount": discount == null ? null : discount,
    "unit_type": unitType == null ? null : unitType,
    "quantity": quantity == null ? null : quantity,
    "product_type": productType == null ? null : productType,
  };
}
