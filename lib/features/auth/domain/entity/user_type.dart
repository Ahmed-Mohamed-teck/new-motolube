enum UserType {
  customer(1),
  technician(2),
  manager(3),
  creditManager(4);

  final int value;
  const UserType(this.value);

  static UserType fromValue(int value) {
    return UserType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => UserType.customer,
    );
  }
}
