import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Components/fisheri_icon_button.dart';
import 'package:fisheri/Screens/book_tickets_screen.dart';
import 'package:fisheri/Screens/detail_screen/contact_section.dart';
import 'package:fisheri/Screens/detail_screen/contents_section.dart';
import 'package:fisheri/Screens/detail_screen/fishing_rules_section.dart';
import 'package:fisheri/Screens/detail_screen/opening_hours_section.dart';
import 'package:fisheri/Screens/detail_screen/social_media_section.dart';
import 'package:fisheri/Screens/detail_screen/stats_section.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:fisheri/search_result_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fisheri/Screens/detail_screen/title_section.dart';
import 'package:fisheri/Screens/detail_screen/description_section.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:fisheri/Screens/detail_screen/amenities_section.dart';
import 'package:fisheri/Screens/detail_screen/fishing_types_section.dart';
import 'package:fisheri/Screens/detail_screen/fish_stocked_section.dart';
import 'package:flutter/rendering.dart';
import 'package:panorama/panorama.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({
    @required this.venue,
    this.imageURL,
    this.index,
    this.id,
  });

  List<String> sectionContents = [];
  final VenueDetailed venue;
  final String imageURL;
  final int index;
  final String id;

  bool isLake() {
    return venue.categories.contains('lake');
  }

  bool isShop() {
    return venue.categories.contains('shop');
  }

  bool hasSocialLinks() {
    return venue.social.facebook != null && venue.social.facebook.isNotEmpty ||
        venue.social.twitter != null && venue.social.twitter.isNotEmpty ||
        venue.social.instagram != null && venue.social.instagram.isNotEmpty ||
        venue.social.youtube != null && venue.social.youtube.isNotEmpty;
  }
  
  List<Widget> buildSections(BuildContext context, VenueDetailed venue) {
    List<Widget> sections = [];

    String _buildLocationString(List<String> items) {
      items.removeWhere((item) => item == null || item.isEmpty);
      return items.join(', ');
    }

    sections.add(TitleSection(
      title: venue.name,
      subtitle: _buildLocationString(
          [venue.address.street, venue.address.town, venue.address.postcode]),
    ));

    sections.add(DSComponents.doubleSpacer());

    sections.add(Row(
      children: [
        Icon(Icons.location_on, color: Colors.green, size: 20),
        DSComponents.halfSpacer(),
        DSComponents.body(text: '5.6 miles')
      ],
    ));

    sections.add(DSComponents.doubleSpacer());

    if (venue.categories != null) {
      sections.add(VenueCategoriesSection(
        categories: venue.categories,
        alwaysOpen: venue.alwaysOpen != null ? venue.alwaysOpen : false,
      ));
    }

    sections.add(DSComponents.paragraphSpacer());

    sections.add(DSComponents.subheaderSmall(text: 'ID: $id', alignment: Alignment.centerLeft));

    sections.add(DSComponents.doubleSpacer());

    sections.add(DescriptionSection(
      text: venue.description,
    ));

    sections.add(DSComponents.paragraphSpacer());

    sections.add(ContentsSection(
      contents: [
        'Location',
        'Amenities',
        'Fishing Types',
        'Fish',
        'Rules',
        'Opening Hours',
        'Social Media',
      ],
    ));

    sections.add(DSComponents.paragraphSpacer());

    sections.add(StatsSection(
      stats: [
        Stat(name: 'Catch Reports', value: 1247),
        Stat(name: 'Upcoming Events', value: 2),
        Stat(name: 'Check-Ins Today', value: 16),
      ],
    ));

    sections.add(DSComponents.divider());

    sections.add(
        MapViewSection(
          address: venue.address,
          coordinates: venue.coordinates,
        )
    );

    sections.add(DSComponents.paragraphSpacer());

    sections.add(ContactSection(
      contactItems: [
        'Call',
        'Website',
        'Email',
      ],
    ));

    sections.add(DSComponents.divider());

    if (isLake()) {
      sections.add(AmenitiesSection(venue.amenities));
      sections.add(DSComponents.divider());
    }

    if (isLake()) {
      if (venue.fishStock != null) {
        sections.add(FishStockSectionFactory.standard(venue.fishStock));
      } else {
        sections.add(FishStockSectionFactory.fromStringArray(venue.fishStocked));
      }
      sections.add(DSComponents.divider());
    }

    if(venue.fishingTackles != null || venue.fishingTypes != null) {
      sections.add(FishingTypesSection(
        title: 'Fishing Types & Tackle',
        fishTypes: venue.fishingTypes,
        fishTackles: venue.fishingTackles,
      ));
      sections.add(DSComponents.divider());
    }
    
    if (isLake() && venue.fishingRules != null && venue.fishingRules.isNotEmpty) {
      final fishingRulesList = venue.fishingRules.split('*');
      fishingRulesList.removeAt(0);
      sections.add(FishingRulesSection(fishingRules: fishingRulesList));
      sections.add(DSComponents.divider());
    }

    sections.add(OpeningHoursSection(openingHours: venue.operationalHours));

    sections.add(DSComponents.divider());

    sections.add(SocialMediaSection(social: venue.social));

    sections.add(DSComponents.sectionSpacer());
    sections.add(DSComponents.sectionSpacer());

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Stack(
                    children: [
                      ImageCarousel(
                        imageURLs: venue.images,
                      ),
                      Positioned(
                        left: 24,
                        bottom: 16,
                        child: ThreeSixtyImageButton(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                    child: Column(children: buildSections(context, venue)),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 58,
                  padding: EdgeInsets.fromLTRB(52, 0, 52, 8),
                  alignment: Alignment.bottomCenter,
                  child: DSComponents.primaryButton(
                    text: 'Book Tickets from £39',
                    onPressed: () {
                      Coordinator.present(context, screenTitle: 'Tickets', screen: BookTicketsScreen());
                    }
                  )
              ),
            ),
            Positioned(
                top: 16,
                left: 16,
                child: FisheriIconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.white, size: 32),
                  onTap:  Navigator.of(context).pop,
                )
            ),
          ],
        ),
      ),
    );
  }
}

class ThreeSixtyImageButton extends StatelessWidget {
  const ThreeSixtyImageButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.asset(
        'images/icons/360-degrees.png',
        color: Colors.white,
        height: 32,
        width: 32,
      ),
      onTap: () {
        Coordinator.present(
            context,
            screenTitle: '360° View',
            screen: Panorama(
              child: Image.asset('images/placeholders/panorama2.jpg'),
            )
        );
      },
    );
  }
}

class MapViewSection extends StatelessWidget {
  MapViewSection({
    @required this.address,
    this.coordinates,
  });

  final VenueAddress address;
  final GeoPoint coordinates;

  static void navigateTo(double lat, double lng) async {
    var uri = Uri.parse('comgooglemaps://?q=$lat, $lng');
    if (await canLaunch(uri.toString())) {
      print(uri.toString());
      await launch(uri.toString());
    } else {
      print('could not launch URL: ${uri.toString()}');
      throw 'Could not launch ${uri.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DSComponents.header(text: 'Location'),
        DSComponents.paragraphSpacer(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 200,
          width: double.infinity,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset('images/placeholders/lake_map_view.png',
                fit: BoxFit.cover),
            Image.asset('images/icons/map_marker_new.png'),
          ]),
        ),
        Visibility(
          visible: coordinates != null,
          child: Column(
            children: [
              DSComponents.paragraphSpacer(),
              Container(
                width: 200,
                  child: DSComponents.secondaryButton(
                      text: 'Get Directions',
                      onPressed: () {
                        navigateTo(coordinates.latitude, coordinates.longitude);
                      }),
              ),
            ],
          ),
        ),
        DSComponents.paragraphSpacer(),
        DSComponents.body(
            text: '${address.street}', alignment: Alignment.center),
        DSComponents.singleSpacer(),
        DSComponents.body(text: '${address.town}', alignment: Alignment.center),
        DSComponents.singleSpacer(),
        DSComponents.body(
            text: '${address.county}', alignment: Alignment.center),
        DSComponents.singleSpacer(),
        DSComponents.body(
            text: '${address.postcode}', alignment: Alignment.center),
      ],
    );
  }
}
