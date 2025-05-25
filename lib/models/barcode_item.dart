class BarcodeItem {
  final String value;
  final String type;
  final DateTime scannedAt;

  BarcodeItem({
    required this.value,
    required this.type,
    required this.scannedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'type': type,
      'scannedAt': scannedAt.toIso8601String(),
    };
  }

  factory BarcodeItem.fromMap(Map<String, dynamic> map) {
    return BarcodeItem(
      value: map['value'] ?? '',
      type: map['type'] ?? '',
      scannedAt: DateTime.parse(map['scannedAt']),
    );
  }

  @override
  String toString() {
    return 'BarcodeItem(value: $value, type: $type, scannedAt: $scannedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BarcodeItem && other.value == value && other.type == type;
  }

  @override
  int get hashCode => value.hashCode ^ type.hashCode;
}