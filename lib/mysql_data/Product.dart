class Product{

  String code;
  String name;
  String price;
  String cost;
  String units;
  Product({this.code, this.name, this.price,this.cost,this.units});

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      code: json['code'] as String,
      name: json['name'] as String,
      price: json['price'] as String,
      cost: json['cost'] as String,
      units: json['units'] as String,
    );
  }
}