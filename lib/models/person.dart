class Person {
  late String PhoneNumber;
  late String Password;
  late String? Name;

  Person({
    required this.PhoneNumber,
    required this.Password,
    this.Name
  });

}