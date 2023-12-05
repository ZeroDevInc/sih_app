import 'dart:convert';

import 'package:flutter/foundation.dart';

class Parking {
  final String parkingName;
  final String email;
  final List<dynamic> location;
  final Address address;
  final bool isOnline;
  final Car car;
  final Bike bike;
  final Truck truck;
  Parking({
    required this.parkingName,
    required this.email,
    required this.location,
    required this.address,
    required this.isOnline,
    required this.car,
    required this.bike,
    required this.truck,
  });

  Parking copyWith({
    String? parkingName,
    String? email,
    List<dynamic>? location,
    Address? address,
    bool? isOnline,
    Car? car,
    Bike? bike,
    Truck? truck,
  }) {
    return Parking(
      parkingName: parkingName ?? this.parkingName,
      email: email ?? this.email,
      location: location ?? this.location,
      address: address ?? this.address,
      isOnline: isOnline ?? this.isOnline,
      car: car ?? this.car,
      bike: bike ?? this.bike,
      truck: truck ?? this.truck,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'parkingName': parkingName,
      'email': email,
      'location': location,
      'address': address.toMap(),
      'isOnline': isOnline,
      'car': car.toMap(),
      'bike': bike.toMap(),
      'truck': truck.toMap(),
    };
  }

  factory Parking.fromMap(Map<String, dynamic> map) {
    return Parking(
      parkingName: map['parkingName'] as String,
      email: map['email'] as String,
      location: List<dynamic>.from((map['location'] as List<dynamic>)),
      address: Address.fromMap(map['address'] as Map<String, dynamic>),
      isOnline: map['isOnline'] as bool,
      car: Car.fromMap(map['car'] as Map<String, dynamic>),
      bike: Bike.fromMap(map['bike'] as Map<String, dynamic>),
      truck: Truck.fromMap(map['truck'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Parking.fromJson(String source) =>
      Parking.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Parking(parkingName: $parkingName, email: $email, location: $location, address: $address, isOnline: $isOnline, car: $car, bike: $bike, truck: $truck)';
  }

  @override
  bool operator ==(covariant Parking other) {
    if (identical(this, other)) return true;

    return other.parkingName == parkingName &&
        other.email == email &&
        listEquals(other.location, location) &&
        other.address == address &&
        other.isOnline == isOnline &&
        other.car == car &&
        other.bike == bike &&
        other.truck == truck;
  }

  @override
  int get hashCode {
    return parkingName.hashCode ^
        email.hashCode ^
        location.hashCode ^
        address.hashCode ^
        isOnline.hashCode ^
        car.hashCode ^
        bike.hashCode ^
        truck.hashCode;
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  Address({
    required this.street,
    required this.city,
    required this.state,
  });

  Address copyWith({
    String? street,
    String? city,
    String? state,
  }) {
    return Address(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'street': street,
      'city': city,
      'state': state,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Address: street: $street, city: $city, state: $state';

  @override
  bool operator ==(covariant Address other) {
    if (identical(this, other)) return true;

    return other.street == street && other.city == city && other.state == state;
  }

  @override
  int get hashCode => street.hashCode ^ city.hashCode ^ state.hashCode;
}

class Car {
  final int slots;
  final int price;
  final List<dynamic> available;
  final List<dynamic> booked;
  Car({
    required this.slots,
    required this.price,
    required this.available,
    required this.booked,
  });

  Car copyWith({
    int? slots,
    int? price,
    List<dynamic>? available,
    List<dynamic>? booked,
  }) {
    return Car(
      slots: slots ?? this.slots,
      price: price ?? this.price,
      available: available ?? this.available,
      booked: booked ?? this.booked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'slots': slots,
      'price': price,
      'available': available,
      'booked': booked,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      slots: map['slots'].toInt() as int,
      price: map['price'].toInt() as int,
      available: List<dynamic>.from((map['available'] as List<dynamic>)),
      booked: List<dynamic>.from((map['booked'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Car.fromJson(String source) =>
      Car.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Car(slots: $slots, price: $price, available: $available, booked: $booked)';
  }

  @override
  bool operator ==(covariant Car other) {
    if (identical(this, other)) return true;

    return other.slots == slots &&
        other.price == price &&
        listEquals(other.available, available) &&
        listEquals(other.booked, booked);
  }

  @override
  int get hashCode {
    return slots.hashCode ^
        price.hashCode ^
        available.hashCode ^
        booked.hashCode;
  }
}

class Bike {
  final int price;
  final int slots;
  final List<dynamic> available;
  final List<dynamic> booked;
  Bike({
    required this.price,
    required this.slots,
    required this.available,
    required this.booked,
  });

  Bike copyWith({
    int? price,
    int? slots,
    List<dynamic>? available,
    List<dynamic>? booked,
  }) {
    return Bike(
      price: price ?? this.price,
      slots: slots ?? this.slots,
      available: available ?? this.available,
      booked: booked ?? this.booked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'price': price,
      'slots': slots,
      'available': available,
      'booked': booked,
    };
  }

  factory Bike.fromMap(Map<String, dynamic> map) {
    return Bike(
      price: map['price'].toInt() as int,
      slots: map['slots'].toInt() as int,
      available: List<dynamic>.from((map['available'] as List<dynamic>)),
      booked: List<dynamic>.from((map['booked'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bike.fromJson(String source) =>
      Bike.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Bike(price: $price, slots: $slots, available: $available, booked: $booked)';
  }

  @override
  bool operator ==(covariant Bike other) {
    if (identical(this, other)) return true;

    return other.price == price &&
        other.slots == slots &&
        listEquals(other.available, available) &&
        listEquals(other.booked, booked);
  }

  @override
  int get hashCode {
    return price.hashCode ^
        slots.hashCode ^
        available.hashCode ^
        booked.hashCode;
  }
}

class Truck {
  final int price;
  final int slots;
  final List<dynamic> available;
  final List<dynamic> booked;
  Truck({
    required this.price,
    required this.slots,
    required this.available,
    required this.booked,
  });

  Truck copyWith({
    int? price,
    int? slots,
    List<dynamic>? available,
    List<dynamic>? booked,
  }) {
    return Truck(
      price: price ?? this.price,
      slots: slots ?? this.slots,
      available: available ?? this.available,
      booked: booked ?? this.booked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'price': price,
      'slots': slots,
      'available': available,
      'booked': booked,
    };
  }

  factory Truck.fromMap(Map<String, dynamic> map) {
    return Truck(
      price: map['price'].toInt() as int,
      slots: map['slots'].toInt() as int,
      available: List<dynamic>.from((map['available'] as List<dynamic>)),
      booked: List<dynamic>.from((map['booked'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Truck.fromJson(String source) =>
      Truck.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Truck(price: $price, slots: $slots, available: $available, booked: $booked)';
  }

  @override
  bool operator ==(covariant Truck other) {
    if (identical(this, other)) return true;

    return other.price == price &&
        other.slots == slots &&
        listEquals(other.available, available) &&
        listEquals(other.booked, booked);
  }

  @override
  int get hashCode {
    return price.hashCode ^
        slots.hashCode ^
        available.hashCode ^
        booked.hashCode;
  }
}
