class Singletons {
  static final Singletons _singletons = Singletons._internal();
  String message = "Whatsapp Message";

  factory Singletons() {
    return _singletons;
  }

  Singletons._internal();
}
