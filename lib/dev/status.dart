class Status {
  Status(this.active, this.total, this.current);

  factory Status.none() => Status(false, 0, 0);

  final bool active;

  /// Total consumption in Wh.
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
}
