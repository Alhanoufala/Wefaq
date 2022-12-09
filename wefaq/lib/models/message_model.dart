import 'user_model.dart';

class Message {
  final User sender;
  final String avatar;
  final String time;
  final int unreadCount;
  final bool isRead;
  final String text;

  Message({
    required this.sender,
    required this.avatar,
    required this.time,
    required this.unreadCount,
    required this.text,
    required this.isRead,
  });
}

final List<Message> recentChats = [
  Message(
      sender: addison,
      avatar: 'assets/images/Addison.jpg',
      time: '01:25',
      text: "typing...",
      unreadCount: 1,
      isRead: false),
  Message(
      sender: jason,
      avatar: 'assets/images/Jason.jpg',
      time: '12:46',
      text: "Will I be in it?",
      unreadCount: 1,
      isRead: false),
  Message(
      sender: deanna,
      avatar: 'assets/images/Deanna.jpg',
      time: '05:26',
      text: "That's so cute.",
      unreadCount: 3,
      isRead: false),
  Message(
      sender: nathan,
      avatar: 'assets/images/Nathan.jpg',
      time: '12:45',
      text: "Let me see what I can do.",
      unreadCount: 2,
      isRead: false),
];

final List<Message> allChats = [
  Message(
    sender: virgil,
    avatar: 'assets/images/Virgil.jpg',
    time: '12:59',
    text: "No! I just wanted",
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: stanley,
    avatar: 'assets/images/Stanley.jpg',
    time: '10:41',
    text: "You did what?",
    unreadCount: 1,
    isRead: false,
  ),
  Message(
    sender: leslie,
    avatar: 'assets/images/Leslie.jpg',
    time: '05:51',
    unreadCount: 0,
    isRead: true,
    text: "just signed up for a tutor",
  ),
  Message(
    sender: judd,
    avatar: 'assets/images/Judd.jpg',
    time: '10:16',
    text: "May I ask you something?",
    unreadCount: 2,
    isRead: false,
  ),
];

final List<Message> messages = [
  Message(
    sender: currentUser,
    time: '12:05 AM',
    isRead: true,
    text: "I'm very excited to work with all of you",
    avatar: '',
    unreadCount: 0,
  ),
  Message(
    sender: judd,
    time: '1:00 AM',
    avatar: addison.avatar,
    text: "Hello! My name is Nada and I'm very excited to work with all of you",
    isRead: false,
    unreadCount: 0,
  ),
  Message(
    sender: judd,
    time: '12:09 AM',
    avatar: addison.avatar,
    text: "Good Morning I'm Alhanouf",
    isRead: false,
    unreadCount: 0,
  ),
  Message(
    sender: judd,
    time: '12:05 AM',
    isRead: true,
    text: "Hi I'm Layan",
    avatar: '',
    unreadCount: 0,
  ),
  Message(
    sender: judd,
    time: '12:05 AM',
    isRead: true,
    text: "Hi I'm Raseel",
    avatar: '',
    unreadCount: 0,
  ),
  Message(
    sender: currentUser,
    time: '12:05 AM',
    isRead: true,
    text:
        "Hello Team! I'm Sarah congrats on your acceptance, lets intrduce ourselves to get to know each other 🤩.",
    avatar: '',
    unreadCount: 0,
  ),
];
