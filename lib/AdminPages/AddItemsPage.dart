import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddItemsPage extends StatefulWidget {
  @override
  _AddItemsPageState createState() => _AddItemsPageState();
}

class _AddItemsPageState extends State<AddItemsPage> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

  File _firstImageFile;
  File _secondImageFile;
  File _thirdImageFile;
  String _uploadedFirstFileURL;
  String _uploadedSecondFileURL;
  String _uploadedThirdFileURL;

  String _onlineUserId = '';
  String itemTitle = '';
  String itemDescription = '';
  String _onlineUserEmail = '';
  String _formattedDate;
  String pressAboutCompany = '';
  String author = '';
  String phone = '';
  String price = '';
  bool checkedValue = false;
  String _selectedCategory = '-';

  final List<String> _itemCategories = [
    '-',
    'Nyumba',
    'Kiwanja',
    'Gari',
  ];

  final ImagePicker _picker = ImagePicker();

  Future getFirstImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
        maxHeight: 1080,
        maxWidth: 1920,
        compressQuality: 70,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Decupează-ți fotografia',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _firstImageFile = croppedFile;
    });
  }

  Future getSecondImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
        maxHeight: 1080,
        maxWidth: 1920,
        compressQuality: 70,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Decupează-ți fotografia',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _secondImageFile = croppedFile;
    });
  }

  Future getThirdImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
        maxHeight: 1080,
        maxWidth: 1920,
        compressQuality: 70,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Decupează-ți fotografia',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _thirdImageFile = croppedFile;
    });
  }

  //create press
  _createData() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Market').doc();
    Map<String, dynamic> _tasks = {
      'item_title': itemTitle,
      'item_description': itemDescription,
      'item_image_one': _uploadedFirstFileURL,
      'item_image_two': _uploadedSecondFileURL,
      'item_image_three': _uploadedThirdFileURL,
      'item_added_time': DateTime.now().millisecondsSinceEpoch,
      'item_poster': _onlineUserId,
      'item_poster_email': _onlineUserEmail,
      'item_formatted_date': _formattedDate,
      'item_category': _selectedCategory,
      'item_phone_number': phone,
      'item_price': price,
      'item_read_count': 0,
      'item_status': 'null',
      'item_comments_count': 0,
      'item_share_count': 0,
      'item_extra': '',
      'item_id': 'extra',
    };
    ds.set(_tasks).whenComplete(() {
      DocumentReference documentReferences =
          FirebaseFirestore.instance.collection('Market').doc(ds.id);
      Map<String, dynamic> _updateTasks = {
        'item_id': ds.id,
      };
      documentReferences.update(_updateTasks).whenComplete(() {
        print('Item created');
        setState(() {
          loading = false;
        });
        _showDialog();
      });
    });
  }

  _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Wrap(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Imepakiwa!',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'Bidhaa yako imeorodheshwa vyema, sasa itaonekana kwa kila atakae tembelea Mjengoni App.',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: 320.0,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Sawa",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weka bidhaa'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            color: Colors.white,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 200,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 1.5 / 1,
                              child: Container(
                                height: 200.0,
                                child: InkWell(
                                  child: _firstImageFile == null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image(
                                            image: AssetImage(
                                              'assets/images/place_holder.png',
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image(
                                            image: FileImage(_firstImageFile),
                                            fit: BoxFit.fill,
                                            //child: Text('Select Image'),
                                          ),
                                        ),
                                  onTap: () {
                                    getFirstImage();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            AspectRatio(
                              aspectRatio: 1.5 / 1,
                              child: Container(
                                height: 200.0,
                                child: InkWell(
                                  child: _secondImageFile == null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image(
                                            image: AssetImage(
                                              'assets/images/place_holder.png',
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image(
                                            image: FileImage(_secondImageFile),
                                            fit: BoxFit.fill,
                                            //child: Text('Select Image'),
                                          ),
                                        ),
                                  onTap: () {
                                    getSecondImage();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            AspectRatio(
                              aspectRatio: 1.5 / 1,
                              child: Container(
                                height: 200.0,
                                child: InkWell(
                                  child: _thirdImageFile == null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image(
                                            image: AssetImage(
                                              'assets/images/place_holder.png',
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image(
                                            image: FileImage(_thirdImageFile),
                                            fit: BoxFit.fill,
                                            //child: Text('Select Image'),
                                          ),
                                        ),
                                  onTap: () {
                                    getThirdImage();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 30,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Jina la bidhaa',
                          contentPadding: const EdgeInsets.all(15.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(4.0),
                            ),
                          ),
                          errorStyle: TextStyle(color: Colors.brown),
                        ),
                        onChanged: (val) {
                          setState(() => itemTitle = val);
                        },
                        validator: (val) => val.length < 5 ? 'Fupi sana' : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField(
                        value: _selectedCategory ?? '-',
                        items: _itemCategories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedCategory = val);
                        },
                        validator: (val) => val == '-' ? 'Chagua bidhaa' : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Aina',
                          helperText: 'Aina ya bidhaa',
                          contentPadding: const EdgeInsets.all(15.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(4.0),
                            ),
                          ),
                          errorStyle: TextStyle(color: Colors.brown),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 300,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Maelezo',
                          helperText: 'Maelezo zaidi kuhusu budhaa',
                          contentPadding: const EdgeInsets.all(15.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal,
                            ),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(4.0),
                            ),
                          ),
                          errorStyle: TextStyle(
                            color: Colors.brown,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => itemDescription = val);
                        },
                        validator: (val) =>
                            val.length < 100 ? 'Fupi sana' : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        maxLength: 13,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Simu',
                          helperText: 'Namba ya simu',
                          contentPadding: const EdgeInsets.all(15.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal,
                            ),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(4.0),
                            ),
                          ),
                          errorStyle: TextStyle(
                            color: Colors.brown,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => phone = val);
                        },
                        validator: (val) =>
                            val.length < 10 ? 'Weka namba halisi' : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [ThousandsSeparatorInputFormatter()],
                        maxLines: 1,
                        maxLength: 10,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Bei (Tsh)',
                          helperText: 'Bei ya bidhaa',
                          contentPadding: const EdgeInsets.all(15.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal,
                            ),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(4.0),
                            ),
                          ),
                          errorStyle: TextStyle(
                            color: Colors.brown,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => price = val);
                        },
                        validator: (val) =>
                            val.length < 3 ? 'Weka kiasi halisi' : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      loading
                          ? Container(
                              decoration: new BoxDecoration(
                                color: Color(0xff1f4061),
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                                border: Border.all(
                                  color: Colors.white38,
                                  width: 2,
                                ),
                              ),
                              width: double.infinity,
                              height: 48.0,
                              child: Center(
                                child: SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ),
                            )
                          : ButtonTheme(
                              height: 48,
                              minWidth: double.infinity,
                              child: FlatButton(
                                color: Color(0xff1f4061),
                                child: Text(
                                  'Wasilisha',
                                  style: GoogleFonts.ptSans(
                                    textStyle: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white38,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                padding: const EdgeInsets.all(8),
                                textColor: Colors.white,
                                onPressed: () async {
                                  if (_firstImageFile == null ||
                                      _secondImageFile == null ||
                                      _thirdImageFile == null) {
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Weka picha 3!',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  } else {
                                    if (_formKey.currentState.validate()) {
                                      setState(() => loading = true);
                                      FocusScope.of(context).unfocus();
                                      _startUploadingFirstImage();
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'Jaza kila kitu!',
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  }
                                },
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _startUploadingFirstImage() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage
          .ref('Market_images/${timestamp + '_1'}.jpg')
          .putFile(_firstImageFile);
      print('File Uploaded');

      String downloadURL = await storage
          .ref('Market_images/${timestamp + '_1'}.jpg')
          .getDownloadURL();

      setState(() {
        _uploadedFirstFileURL = downloadURL;
      });
      _startUploadingSecondImage();
    } on FirebaseException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
          textAlign: TextAlign.center,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(
        () {
          loading = false;
        },
      );
    }
  }

  Future<void> _startUploadingSecondImage() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage
          .ref('Market_images/${timestamp + '_2'}.jpg')
          .putFile(_secondImageFile);
      print('File Uploaded');

      String downloadURL = await storage
          .ref('Market_images/${timestamp + '_2'}.jpg')
          .getDownloadURL();

      setState(() {
        _uploadedSecondFileURL = downloadURL;
      });
      _startUploadingThirdImage();
    } on FirebaseException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
          textAlign: TextAlign.center,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _startUploadingThirdImage() async {
    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage
          .ref('Market_images/${timestamp + '_3'}.jpg')
          .putFile(_thirdImageFile);
      print('File Uploaded');

      String downloadURL = await storage
          .ref('Market_images/${timestamp + '_3'}.jpg')
          .getDownloadURL();

      setState(() {
        _uploadedThirdFileURL = downloadURL;
        _onlineUserId = uid;
        _onlineUserEmail = user.email;
      });
      _createData();
    } on FirebaseException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
          textAlign: TextAlign.center,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        //_loading = false;
      });
    }
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1)
          newString = separator + newString;
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
