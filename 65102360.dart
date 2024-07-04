import 'dart:io';

class Room {
  final String roomNumber;
  final String roomType;
  final double price;
  bool _isBooked;

  Room(this.roomNumber, this.roomType, this.price) : _isBooked = false;

  bool get isBooked => _isBooked;

  void bookRoom() => !_isBooked ? _isBooked = true : print('Room $roomNumber is already booked.');

  void cancelBooking() => _isBooked ? _isBooked = false : print('Room $roomNumber is not booked.');

  String toString() => 'Room{roomNumber: $roomNumber, roomType: $roomType, price: $price, isBooked: $_isBooked}';
}

class Guest {
  final String name;
  final String guestId;
  List<Room> _bookedRooms;

  Guest(this.name, this.guestId) : _bookedRooms = [];

  List<Room> get bookedRooms => List.unmodifiable(_bookedRooms);

  void bookRoom(Room room) {
    if (!room.isBooked) {
      room.bookRoom();
      _bookedRooms.add(room);
      print('$name has booked room ${room.roomNumber}.');
    } else {
      print('Room ${room.roomNumber} is already booked.');
    }
  }

  void cancelRoom(Room room) {
    if (room.isBooked) {
      room.cancelBooking();
      _bookedRooms.remove(room);
      print('$name has canceled booking for room ${room.roomNumber}.');
    } else {
      print('Room ${room.roomNumber} is not booked.');
    }
  }

  String toString() {
    return 'Guest{name: $name, guestId: $guestId, bookedRooms: ${_bookedRooms.isNotEmpty ? _bookedRooms.map((room) => room.roomNumber).toList() : 'canceled all bookings'}}';
  }
}

class Hotel {
  List<Room> _rooms;
  List<Guest> _guests;

  Hotel() : _rooms = [], _guests = [];

  void addRoom(Room room) {
    _rooms.add(room);
    print('Room ${room.roomNumber} added to the hotel.');
  }

  void removeRoom(Room room) {
    _rooms.remove(room);
    print('Room ${room.roomNumber} removed from the hotel.');
  }

  void registerGuest(Guest guest) {
    _guests.add(guest);
    print('Guest ${guest.name} registered with ID ${guest.guestId}.');
  }

  void bookRoom(String guestId, String roomNumber) {
    Guest? guest = getGuest(guestId);
    Room? room = getRoom(roomNumber);

    if (guest != null && room != null) {
      guest.bookRoom(room);
    } else {
      print('Guest or Room not found.');
    }
  }

  void cancelRoom(String guestId, String roomNumber) {
    Guest? guest = getGuest(guestId);
    Room? room = getRoom(roomNumber);

    if (guest != null && room != null) {
      guest.cancelRoom(room);
    } else {
      print('Guest or Room not found.');
    }
  }

  Room? getRoom(String roomNumber) {
    try {
      return _rooms.firstWhere((room) => room.roomNumber == roomNumber);
    } catch (e) {
      print('Room $roomNumber not found.');
      return null;
    }
  }

  Guest? getGuest(String guestId) {
    try {
      return _guests.firstWhere((guest) => guest.guestId == guestId);
    } catch (e) {
      print('Guest $guestId not found.');
      return null;
    }
  }

  void showMenu() {
    while (true) {
      print('--- Resort Management System ---');
      print('1. Add New Room');
      print('2. Delete Room');
      print('3. Register New Guest');
      print('4. Book Room');
      print('5. Cancel Room');
      print('6. Display  All Rooms');
      print('7. Display  All Guests');
      print('8. Quit');
      print('----------------------------------');
      stdout.write('Enter your choice: ');

      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          _addRoom();
          break;
        case '2':
          _removeRoom();
          break;
        case '3':
          _registerGuest();
          break;
        case '4':
          _bookRoom();
          break;
        case '5':
          _cancelRoom();
          break;
        case '6':
          _showAllRooms();
          break;
        case '7':
          _showAllGuests();
          break;
        case '8':
          return;
        default:
          print('Invalid choice. Please try again.');
      }
    }
  }

  void _addRoom() {
    stdout.write('Enter room number: ');
    String roomNumber = stdin.readLineSync()!;
    stdout.write('Enter room type (Single/Double/Suite): ');
    String roomType = stdin.readLineSync()!;
    stdout.write('Enter room price: ');
    double price = double.parse(stdin.readLineSync()!);

    Room room = Room(roomNumber, roomType, price);
    addRoom(room);
  }

  void _removeRoom() {
    stdout.write('Enter room number: ');
    String roomNumber = stdin.readLineSync()!;
    Room? room = getRoom(roomNumber);

    if (room != null) {
      removeRoom(room);
    } else {
      print('Room not found.');
    }
  }

  void _registerGuest() {
    stdout.write('Enter guest name: ');
    String name = stdin.readLineSync()!;
    stdout.write('Enter guest ID: ');
    String guestId = stdin.readLineSync()!;

    Guest guest = Guest(name, guestId);
    registerGuest(guest);
  }

  void _bookRoom() {
    stdout.write('Enter guest ID: ');
    String guestId = stdin.readLineSync()!;
    stdout.write('Enter room number: ');
    String roomNumber = stdin.readLineSync()!;

    bookRoom(guestId, roomNumber);
  }

  void _cancelRoom() {
    stdout.write('Enter guest ID: ');
    String guestId = stdin.readLineSync()!;
    stdout.write('Enter room number: ');
    String roomNumber = stdin.readLineSync()!;

    cancelRoom(guestId, roomNumber);
  }

  void _showAllRooms() {
    if (_rooms.isEmpty) {
      print('No rooms available.');
    } else {
      for (Room room in _rooms) {
        print(room);
      }
    }
  }

  void _showAllGuests() {
    if (_guests.isEmpty) {
      print('No guests registered.');
    } else {
      for (Guest guest in _guests) {
        print(guest);
      }
    }
  }
}

void main() {
  Hotel hotel = Hotel();
  hotel.showMenu();
}