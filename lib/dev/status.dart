/// Immutable fetched status of a plug.
class Status {
  Status(this.active, this.total, this.current)
    : lastUpdate = DateTime.now();

  factory Status.none() => Status(false, 0, 0);

  /// The time when this object was constructed.
  final DateTime lastUpdate;

  /// Whether the plug is transmitting power.
  final bool active;

  /// Total consumption in kWh.
  final double total;

  /// Current consumption in W.
  final double current;

  @override
  String toString() {
    return 'PlugStatus{active: $active, total: $total, current: $current}';
  }

  Status operator +(Status other) {
    return Status(
      active && other.active,
      total + other.total,
      current + other.current,
    );
  }

  Status copyWith({
    bool? active,
    double? total,
    double? current,
  }) => Status(
    active ?? this.active,
    total  ?? this.total,
    current ?? this.current,
  );
}
