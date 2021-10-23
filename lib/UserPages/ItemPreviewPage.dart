import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemPreviewPage extends StatefulWidget {
  final DocumentSnapshot itemSnap;
  final String itemId;
  ItemPreviewPage({this.itemSnap, this.itemId});

  @override
  _ItemPreviewPageState createState() =>
      _ItemPreviewPageState(itemSnap: itemSnap, itemId: itemId);
}

class _ItemPreviewPageState extends State<ItemPreviewPage> {
  DocumentSnapshot itemSnap;
  String itemId;
  _ItemPreviewPageState({this.itemSnap, this.itemId});

  Future<void> _launched;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          itemSnap['item_title'],
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
              color: Colors.white,
              //fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: (9 * MediaQuery.of(context).size.width) / 16,
                //aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
              ),
              items: [
                itemSnap['item_image_one'],
                itemSnap['item_image_two'],
                itemSnap['item_image_three'],
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: double.infinity,
                      height:
                          ((9 * MediaQuery.of(context).size.width) / 16) - 32,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            decoration: BoxDecoration(
                              //color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 3,
                                  blurRadius: 8,
                                  offset: Offset(
                                      2, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Image(
                                  image: AssetImage(
                                      'assets/images/place_holder.png'),
                                  fit: BoxFit.cover,
                                ),
                                imageUrl: i,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Text(
                            //   'text $i',
                            //   style: TextStyle(fontSize: 16.0),
                            // ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    itemSnap['item_description'],
                    textAlign: TextAlign.start,
                    style: GoogleFonts.ptSans(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Tsh. ${itemSnap['item_price']}/=',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ButtonTheme(
                    height: 48,
                    minWidth: double.infinity,
                    child: FlatButton(
                      color: Color(0xff1f4061),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.phoneAlt,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Text(
                            'Mpigie dalali',
                            style: GoogleFonts.ptSans(
                              textStyle: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ],
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
                        _launched = _makePhoneCall(
                          'tel:${itemSnap['item_phone_number']}',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
