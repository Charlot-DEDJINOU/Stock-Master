class StockMovement {
  int movementId;
  int productId;
  String movementType;
  int quantity;
  DateTime movementDate;
  String notes;

  StockMovement({
    required this.movementId,
    required this.productId,
    required this.movementType,
    required this.quantity,
    required this.movementDate,
    required this.notes,
  });

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      movementId: json['movement_id'],
      productId: json['product_id'],
      movementType: json['movement_type'],
      quantity: json['quantity'],
      movementDate: json['movement_date'],
      notes: json['notes']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movement_id': movementId,
      'product_id': productId,
      'movement_type' : movementType,
      'quantity' : quantity,
      'movement_date' : movementDate,
      'notes' : notes
    };
  }
}
