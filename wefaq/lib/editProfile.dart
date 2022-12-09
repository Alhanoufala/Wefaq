import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:line_icons/line_icons.dart';
import 'package:multiselect/multiselect.dart';
import 'package:wefaq/profile.dart';
import 'package:wefaq/profileuser.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/background.dart';
import 'package:wefaq/editProfile.dart';
import 'package:wefaq/select_photo_options_screen.dart';
import 'bottom_bar_custom.dart';
import 'package:wefaq/myProjects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/eventsTabs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wefaq/userProjects.dart';
import 'select_photo_options_screen.dart';

class editprofile extends StatefulWidget {
  const editprofile({super.key});
  static const id = 'set_photo_screen';

  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _aboutEditingController = TextEditingController();
  final TextEditingController _gitHubEditingController =
      TextEditingController();
  final TextEditingController _experienceEditingController =
      TextEditingController();
  final TextEditingController _certificationsEditingController =
      TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();

  List<String> options = [];
  List<String> selectedOptionList = [];
  var selectedOption;
  /*late File image;
  final imagepicker = ImagePicker();
  uploadImage() async {
    var pickedimage = await imagepicker.getImage(source: ImageSource.gallery);
    if(pickedimage != null){ image =File(pickedimage.path);}
    else
   ;
  }*/

  File? _image;
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  String userEmail = "";
  String fname = "";
  String lname = "";
  String about = "";
  String experince = "";
  String cerifi = "";
  String skills = "";
  String role = "";
  String gitHub = "";

  @override
  void initState() {
    getCurrentUser();
    getCategoryList();
    getUser();
    super.initState();
  }

  // Future _pickImage(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: source);
  //     if (image == null) return;
  //     File? img = File(image.path);
  //     img = await _cropImage(imageFile: img);
  //     setState(() {
  //       _image = img;
  //       Navigator.of(context).pop();
  //     });
  //   } on PlatformException catch (e) {
  //     print(e);
  //     Navigator.of(context).pop();
  //   }
  // }

  File? imageFile;
  ImagePicker _picker = ImagePicker();

  Future uploadImageToFirebase() async {
    print("Getting Image from Gallery.");
    XFile? result = await _picker.pickImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
    if (result != null) {
      print(result);
      setState(() {
        imageFile = File(result!.path);
      });
      String fileName = imageFile!.path;
      final reference =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(imageFile!);
      await uploadTask.whenComplete(() => null);
      print('File Uploaded');
      reference.getDownloadURL().then((fileURL) {
        setState(() {
          _firestore.collection('users').doc(signedInUser.email).update({
            "Profile": fileURL,
          });
        });
        print(
            "--------------------------------------- Url $fileURL -------------------------------------");
      });
    }
  }

  Future uploadCameraImageToFirebase() async {
    print("Getting Image from Gallery.");
    XFile? result = await _picker.pickImage(source: ImageSource.camera);
    Navigator.of(context).pop();

    if (result != null) {
      print(result);
      setState(() {
        imageFile = File(result!.path);
      });
      String fileName = imageFile!.path;
      final reference =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(imageFile!);
      await uploadTask.whenComplete(() => null);
      print('File Uploaded');
      reference.getDownloadURL().then((fileURL) {
        setState(() {
          _firestore.collection('users').doc(signedInUser.email).update({
            "Profile": fileURL,
          });
        });
        print(
            "--------------------------------------- Url $fileURL -------------------------------------");
      });
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  // void _showSelectPhotoOptions(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(25.0),
  //       ),
  //     ),
  //     builder: (context) => DraggableScrollableSheet(
  //         initialChildSize: 0.28,
  //         maxChildSize: 0.4,
  //         minChildSize: 0.28,
  //         expand: false,
  //         builder: (context, scrollController) {
  //           return SingleChildScrollView(
  //             controller: scrollController,
  //             child: SelectPhotoOptionsScreen(
  //               onTap: _pickImage,
  //             ),
  //           );
  //         }),
  //   );
  // }

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        signedInUser = user;
        userEmail = signedInUser.email.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  void getCategoryList() async {
    final categoriesE = await _firestore.collection('skills').get();
    for (var category in categoriesE.docs) {
      for (var element in category['skills']) {
        setState(() {
          options.add(element);
        });
      }
    }
  }

  imageOptions(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Text("Change Profile Picture",
                          style: TextStyle(
                              color: Color.fromARGB(255, 127, 127, 127),
                              fontWeight: FontWeight.bold)),
                      Container(
                        margin: EdgeInsets.only(
                          left: 36,
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close),
                          color: Color.fromARGB(255, 141, 168, 170),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.photo_library_sharp,
                          color: Color.fromARGB(255, 141, 168, 170),
                        ),
                        title: Text("Browse Gallery",
                            style: TextStyle(
                                color: Color.fromARGB(255, 141, 114, 151))),
                        onTap: () => uploadImageToFirebase(),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.camera_alt,
                          color: Color.fromARGB(255, 141, 168, 170),
                        ),
                        title: Text("Take a photo",
                            style: TextStyle(
                                color: Color.fromARGB(255, 141, 114, 151))),
                        onTap: () => uploadCameraImageToFirebase(),
                      ),
                    ],
                  ),
                ],
              )),
            ));
  }

  String profilepic = "";
  Future getUser() async {
    var fillterd = _firestore
        .collection('users')
        .where("Email", isEqualTo: userEmail)
        .snapshots();
    await for (var snapshot in fillterd)
      for (var user in snapshot.docs) {
        setState(() {
          profilepic = user["Profile"].toString();
          fname = user["FirstName"].toString();
          lname = user["LastName"].toString();
          about = user["about"].toString();
          experince = user["experince"].toString();
          cerifi = user["cerifi"].toString();
          gitHub = user["gitHub"].toString();
          _aboutEditingController.text = user["about"].toString();
          _gitHubEditingController.text = user["gitHub"].toString();
          _certificationsEditingController.text = user["cerifi"].toString();
          _nameEditingController.text =
              user["FirstName"].toString() + " " + user["LastName"].toString();
          _experienceEditingController.text = user["experince"].toString();
          for (var skill in user["skills"])
            selectedOptionList.add(skill.toString());
        });
      }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 237, 240),
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 162, 148, 183),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 0,
        updatePage: () {},
      ),
      body: SingleChildScrollView(
        child: Stack(
          //key: _formKey,
          children: <Widget>[
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Image(
                image: AssetImage(
                  "assets/images/header_profile.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(top: 120),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: ListTile(
                          title: Text("Name"),
                          subtitle: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              //  labelText: 'About',
                            ),
                            controller: _nameEditingController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "required";
                              }
                              if (!RegExp(r'^[a-z A-Z . ,]+$')
                                      .hasMatch(value!) &&
                                  !RegExp(r'^[, . أ-ي]+$').hasMatch(value!)) {
                                return "Only English or Arabic letters";
                              }
                            },
                          ),
                          leading: Icon(Icons.format_align_center),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        margin: EdgeInsets.only(left: 15, top: 10),
                        decoration: BoxDecoration(
                          // boxShadow: [
                          //   BoxShadow(
                          //     offset: Offset(0, 0),
                          //     blurRadius: 10,
                          //     color: Colors.black.withOpacity(0.15),
                          //   ),
                          // ],
                          borderRadius: BorderRadius.circular(10),
                          // image: DecorationImage(
                          //   image:
                          //   CircleAvatar(
                          //     child: Image.network(profilepic),
                          //     radius: 100.0,
                          //   ),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            // onTap: () {
                            //   imageOptions(context);
                            // },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 15, top: 128),
                                        height: 60,
                                        width: 60,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.shade200,
                                            image: new DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  profilepic,
                                                ))),
                                        child: IconButton(
                                          onPressed: () =>
                                              imageOptions(context),
                                          icon: Icon(Icons.camera_enhance),
                                          color: Color.fromARGB(
                                              255, 141, 168, 170),
                                        )
                                        // child: Center(
                                        //     child: CircleAvatar(
                                        //   child: Image.network(
                                        //     profilepic,
                                        //     width: 70,
                                        //     height: 70,
                                        //   ),
                                        //   radius: 100.0,
                                        // ))
                                        ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text("General Information"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("About"),
                          subtitle: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                //  labelText: 'About',
                              ),
                              controller: _aboutEditingController,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!RegExp(r'^[a-z A-Z . , -]+$')
                                          .hasMatch(value!) &&
                                      !RegExp(r'^[, . - أ-ي]+$')
                                          .hasMatch(value!)) {
                                    return "Only English or Arabic letters";
                                  }
                                }
                                return null;
                              }),
                          leading: Icon(Icons.format_align_center),
                        ),
                        Divider(
                          color: Color.fromARGB(115, 176, 176, 176),
                        ),
                        Divider(
                          color: Color.fromARGB(115, 176, 176, 176),
                        ),
                        ListTile(
                          title: Text("GitHub"),
                          subtitle: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                //  labelText: 'About',
                              ),
                              controller: _gitHubEditingController,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!value.startsWith("https://github.com"))
                                    return 'The url must start with " https://github.com"';
                                }
                              }),
                          leading: Icon(
                            LineIcons.github,
                            size: 35,
                            color: Color.fromARGB(255, 93, 18, 107),
                          ),
                        ),
                        Divider(
                          color: Color.fromARGB(115, 176, 176, 176),
                        ),
                        ListTile(
                          title: Text("Experience"),
                          subtitle: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                //  labelText: 'About',
                              ),
                              controller: _experienceEditingController,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!RegExp(r'^[a-z A-Z . , -]+$')
                                          .hasMatch(value!) &&
                                      !RegExp(r'^[, . - أ-ي]+$')
                                          .hasMatch(value!)) {
                                    return "Only English or Arabic letters";
                                  }
                                }
                              }),
                          leading: Icon(Icons.calendar_view_day),
                        ),
                        Divider(
                          color: Color.fromARGB(115, 176, 176, 176),
                        ),
                        ListTile(
                          title: Text("Skills"),
                          subtitle: Column(
                            children: [
                              DropDownMultiSelect(
                                  options: options,
                                  whenEmpty: 'Select your skills',
                                  onChanged: (value) {
                                    selectedOptionList = value;
                                    selectedOption = "";
                                    selectedOptionList.forEach((element) {
                                      selectedOption =
                                          selectedOption + " " + element;
                                    });
                                  },
                                  selectedValues: selectedOptionList),
                            ],
                          ),
                          leading: Icon(Icons.schema_rounded),
                        ),
                        Divider(
                          color: Color.fromARGB(115, 176, 176, 176),
                        ),
                        ListTile(
                          title: Text("Licenses & certifications"),
                          subtitle: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                //  labelText: 'About',
                              ),
                              controller: _certificationsEditingController,
                              validator: (value) {
                                if (value != null) {
                                  if (value!.isNotEmpty) {
                                    if (!RegExp(r'^[a-z A-Z . , -]+$')
                                            .hasMatch(value!) &&
                                        !RegExp(r'^[, . - أ-ي]+$')
                                            .hasMatch(value!)) {
                                      return "Only English or Arabic letters";
                                    }
                                  }
                                }
                              }),
                          leading: Icon(
                            Icons.workspace_premium,
                            size: 33,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    width: 80,
                  ),
                  Row(children: <Widget>[
                    Expanded(
                        child: Column(children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color.fromARGB(255, 173, 156, 184),
                                      Color.fromARGB(255, 173, 156, 184),
                                      Color.fromARGB(255, 173, 156, 184),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.only(
                                    top: 15.0, left: 40, right: 40, bottom: 15),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  // for sorting purpose

                                  _firestore
                                      .collection('users')
                                      .doc(signedInUser.email)
                                      .set({
                                    "FirstName": _nameEditingController.text
                                        .substring(
                                            0,
                                            _nameEditingController.text
                                                .indexOf(" ")),
                                    "LastName": _nameEditingController.text
                                        .substring(_nameEditingController.text
                                                .indexOf(" ") +
                                            1),
                                    "about": _aboutEditingController.text,
                                    "experince":
                                        _experienceEditingController.text,
                                    "cerifi":
                                        _certificationsEditingController.text,
                                    "skills": selectedOptionList,
                                    "gitHub": _gitHubEditingController.text,
                                  }, SetOptions(merge: true));

                                  //sucess message
                                  CoolAlert.show(
                                    context: context,
                                    title: "Success!",
                                    confirmBtnColor:
                                        Color.fromARGB(144, 64, 7, 87),
                                    onConfirmBtnTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => viewprofile(
                                                    userEmail: userEmail,
                                                  )));
                                    },
                                    type: CoolAlertType.success,
                                    backgroundColor:
                                        Color.fromARGB(221, 212, 189, 227),
                                    text: "Profile edited successfuly",
                                  );
                                }
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      ),
                    ])),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Color.fromARGB(255, 182, 179, 179),
                                          Color.fromARGB(255, 182, 179, 179),
                                          Color.fromARGB(255, 182, 179, 179),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.only(
                                        top: 15.0,
                                        left: 40,
                                        right: 40,
                                        bottom: 15),
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => viewprofile(
                                                userEmail: userEmail,
                                              )),
                                    );
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
