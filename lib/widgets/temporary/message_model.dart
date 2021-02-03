import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_model.dart';

class Message {
  final User sender; // Would usually be type DateTime or Firebase Timestamp in production apps
  Timestamp time;
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}

// YOU - current user
final User currentUser = User(
  id: '0',
  name: 'Current User',
  imageUrl: 'assets/images/greg.jpg',
);

// USERS
final User greg = User(
  id: '1',
  name: 'Greg',
  imageUrl: 'assets/images/greg.jpg',
);
final User james = User(
  id: '2',
  name: 'James',
  imageUrl: 'assets/images/james.jpg',
);
final User john = User(
  id: '3',
  name: 'John',
  imageUrl: 'assets/images/john.jpg',
);
final User olivia = User(
  id: '4',
  name: 'Olivia',
  imageUrl: 'assets/images/olivia.jpg',
);
final User sam = User(
  id: '5',
  name: 'Sam',
  imageUrl: 'assets/images/sam.jpg',
);
final User sophia = User(
  id: '6',
  name: 'Sophia',
  imageUrl: 'assets/images/sophia.jpg',
);
final User steven = User(
  id: '7',
  name: 'Steven',
  imageUrl: 'assets/images/steven.jpg',
);

// FAVORITE CONTACTS
List<User> favorites = [sam, steven, olivia, john, greg];

//EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: james,
    time: null,
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
  Message(
    sender: olivia,
    time: null,
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
  Message(
    sender: john,
    time: null,
    text: 'Hey, how\'s it going? What did you do today?',
    unread: false,
  ),
  Message(
    sender: sophia,
    time: null,
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
  Message(
    sender: steven,
    time: null,
    text: 'Hey, how\'s it going? What did you do today?',
    unread: false,
  ),
  Message(
    sender: sam,
    time: null,
    text: 'Hey, how\'s it going? What did you do today?',
    unread: false,
  ),
  Message(
    sender: greg,
    time: null,
    text: 'Hey, how\'s it going? What did you do today?',
    unread: false,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: james,
    time: null,
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: null,
    text: 'Just walked my doge. She was super duper cute. The best pupper!!',
    unread: true,
  ),
  Message(
    sender: james,
    time: null,
    text: 'How\'s the doggo?',
    unread: true,
  ),
  Message(
    sender: james,
    time: null,
    text: 'All the food',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: null,
    text: 'Nice! What kind of food did you eat?',
    unread: true,
  ),
  Message(
    sender: james,
    time: null,
    text: 'I ate so much food today.',
    unread: true,
  ),
];