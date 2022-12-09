class user {
  String? FirstName;
  String? LastName;
  String? Email;

  user();
  Map<String, dynamic> toJson() => {
        'FirstName': FirstName,
        'LastName': LastName,
        'Email': Email,
      };
  user.fromsanpshot(sanpshot)
      : FirstName = sanpshot.data()['FirstName'],
        LastName = sanpshot.data()['LastName'],
        Email = sanpshot.data()['Email'];
}
