class OrderModel {
  final int? id;
  final String customerName;
  final String customerEmail;
  final String deliveryAddress;
  final String phoneNumber;
  final String orderItems;
  final double totalAmount;
  final String orderStatus;
  final String? orderDate;

  OrderModel({
    this.id,
    required this.customerName,
    required this.customerEmail,
    required this.deliveryAddress,
    required this.phoneNumber,
    required this.orderItems,
    required this.totalAmount,
    required this.orderStatus,
    this.orderDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      customerName: json['customerName'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      orderItems: json['orderItems'] ?? '',
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderStatus: json['orderStatus'] ?? 'PENDING',
      orderDate: json['orderDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'deliveryAddress': deliveryAddress,
      'phoneNumber': phoneNumber,
      'orderItems': orderItems,
      'totalAmount': totalAmount,
      'orderStatus': orderStatus,
      if (orderDate != null) 'orderDate': orderDate,
    };
  }
}
