class events {
  String? name;
  String? description;
  String? location;
  String? regstretionUrl;
  List<String>? category;

  events();
  Map<String, dynamic> toJson() => {
        'category': category,
        'description': description,
        'location': location,
        'regstretion url': regstretionUrl,
        'name': name
      };
  events.fromsanpshot(sanpshot)
      : category = sanpshot.data()['categoryE'],
        name = sanpshot.data()['name'],
        location = sanpshot.data()['location'],
        regstretionUrl = sanpshot.data()['regstretion url'],
        description = sanpshot.data()['description'];
}
