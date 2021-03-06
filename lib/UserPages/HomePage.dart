import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mjengoni/Services/ProfileServices.dart';
import 'package:mjengoni/AdminPages/AddItemsPage.dart';
import 'package:mjengoni/UserPages/GettingStartedScreen.dart';
import 'package:mjengoni/UserPages/ItemPreviewPage.dart';
import 'package:mjengoni/animations/FadeAnimations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String onlineUserId;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool userFlag = false;
  var details;

  String _selectedCategory = '-';
  final List<String> _itemCategories = [
    '-',
    'Nyumba',
    'Kiwanja',
    'Gari',
  ];

  String _selectedPriceRange = '-';
  final List<String> _priceRanges = [
    '-',
    '1,000 - 9,000',
    '10,000 - 49,000',
    '50,000 - 100,000',
    '100,000 - 199,000',
    '200,000 - 499,000',
    '500,000 - 999,000',
    '1,000,000 - 10,000,000',
  ];

  @override
  void initState() {
    super.initState();
    //showRevealDialog(context);

    getUser().then((user) async {
      if (user != null) {
        ProfileService().getProfileInfo(user.uid).then((QuerySnapshot docs) {
          if (docs.docs.isNotEmpty) {
            setState(
              () {
                userFlag = true;
                details = docs.docs[0].data();
              },
            );
          }
        });
      } else {}
    });
  }

  Future<User> getUser() async {
    return _auth.currentUser;
  }

  Widget normalPopupMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        size: 30.0,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '0',
          child: Text('Log out'),
        ),
      ],
      onSelected: (retVal) {
        if (retVal == '0') {
          _logOut();
        }
      },
    );
  }

  Future _logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.disconnect();
      await googleSignIn.signOut();

      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => GettingStartedScreen(),
          ),
          (r) => false);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton:
          userFlag == true && details['account_type'] != 'Admin'
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => AddItemsPage(),
                      ),
                    );
                  },
                )
              : null,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: <Widget>[
              normalPopupMenuButton(),
            ],
            centerTitle: true,
            expandedHeight: MediaQuery.of(context).size.width * 2 / 3,
            backgroundColor: Theme.of(context).primaryColor,
            pinned: true,
            floating: false,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  title: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: constraints.biggest.height < 120.0 ? 1.0 : 0.0,
                    child: Text('Mjengoni App'),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            NetworkImage('https://picsum.photos/200/300/?blur'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [Colors.black, Colors.black.withOpacity(.3)],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FadeAnimation(
                              1,
                              Text(
                                'Usihangaike kuzunguka, sasa nyumba, magari na viwanja viko kiganjani mwako.',
                                style: GoogleFonts.ptSans(
                                  textStyle: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white60,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FadeAnimation(
                                  1.3,
                                  Text(
                                    "Mjengoni App",
                                    style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                width: double.infinity,
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Filter by type:',
                          style: GoogleFonts.ptSans(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: DropdownButtonFormField(
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
                            decoration: new InputDecoration.collapsed(
                              hintText: null,
                            ),
                            validator: (val) =>
                                val == '-' ? 'Chagua bidhaa' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Filter by price:',
                          style: GoogleFonts.ptSans(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: DropdownButtonFormField(
                            value: _selectedPriceRange ?? '-',
                            items: _priceRanges.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => _selectedPriceRange = val);
                            },
                            decoration: new InputDecoration.collapsed(
                              hintText: null,
                            ),
                            validator: (val) =>
                                val == '-' ? 'Chagua bidhaa' : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Market')
                  .orderBy('item_added_time', descending: true)
                  .where('item_category',
                      isEqualTo:
                          _selectedCategory == '-' ? null : _selectedCategory)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.width),
                    child: Center(
                      child: SpinKitThreeBounce(
                        color: Colors.black54,
                        size: 20.0,
                      ),
                    ),
                  );
                } else {
                  if (snapshot.data.documents.length == 0) {
                    return Container(
                      height: MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).size.width),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Image(
                            image: AssetImage('assets/images/empty.png'),
                            width: double.infinity,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        GridView.count(
                          primary: false,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          padding: EdgeInsets.all(10),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: List.generate(
                              snapshot.data.documents.length, (index) {
                            DocumentSnapshot myCategories =
                                snapshot.data.documents[index];
                            return _item(index, myCategories);
                          }),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          ]))
        ],
      ),
    );
  }

  Widget _item(
    int index,
    DocumentSnapshot myCategories,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => ItemPreviewPage(
              itemSnap: myCategories,
              itemId: myCategories['item_id'],
            ),
          ),
        );

        // Navigator.push(
        //   context,
        //   ScaleRoute(
        //     page: ItemPreviewPage(
        //       memberId: myPussies['user_id'],
        //       memberName: myPussies['user_name'],
        //     ),
        //   ),
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 2,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: CachedNetworkImage(
                  imageUrl: myCategories['item_image_one'],
                  imageBuilder: (context, imageProvider) => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Image(
                    width: double.infinity,
                    image: AssetImage('assets/images/place_holder.png'),
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image(
                    width: double.infinity,
                    image: AssetImage('assets/images/place_holder.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                myCategories['item_title'],
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                myCategories['item_description'],
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10.0,
      ),
      child: Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.error_outline),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This is the title",
                    style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Just some text to attract our users attention to click on some stuff",
                    style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        letterSpacing: .5,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          'BUY TICKETS',
                          style: GoogleFonts.ptSans(
                            textStyle: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff003e7f),
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        child: const Text('LISTEN'),
                        onPressed: () {/* ... */},
                      ),
                      // const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationItem(int index, DocumentSnapshot myNotifications) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10.0,
      ),
      child: Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.error_outline),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    myNotifications['notification_title'],
                    style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    myNotifications['notification_summary'],
                    style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        letterSpacing: .5,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          'BUY TICKETS',
                          style: GoogleFonts.ptSans(
                            textStyle: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff003e7f),
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        child: const Text('READ MORE'),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   ScaleRoute(
                          //     page: NotificationEngagePage(
                          //       postId: myNotifications['notification_id'],
                          //     ),
                          //   ),
                          // );
                        },
                      ),
                      // const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
