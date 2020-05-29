import 'package:fisheri/house_colors.dart';
import 'package:fisheri/models/hours_of_operation.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:fisheri/models/venue_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/opening_hours_list.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:fisheri/house_texts.dart';
import 'package:recase/recase.dart';
import 'package:fisheri/Components/image_picker_container.dart';

class VenueDetailedConstants {
  static const String name = "name";
  static const String categories = "categories";
  static const String description = "description";
  static const String coordinates = "coordinates";
  static const String address = "address";
  // TODO: Add Number of Lakes
  static const String amenities = "amenities_array";
  static const String contactDetails = "contact_details";
  static const String social = "social";
  static const String fishStocked = "fish_stock_array";
  static const String fishingTypes = "fishing_types_array";
  static const String tickets = "tickets_array";
  static const String hoursOfOperation = "hours_of_operation";
  static const String assetsPath = "assets_path";
}

class VenueFormEditScreen extends StatefulWidget {
  VenueFormEditScreen({
    @required this.venue,
    @required this.venueID,
  });

  final VenueDetailed venue;
  final String venueID;

  @override
  _VenueFormEditScreenState createState() => _VenueFormEditScreenState();
}

class _VenueFormEditScreenState extends State<VenueFormEditScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 100),
          children: <Widget>[
            Column(
              children: <Widget>[
                FormBuilder(
                  key: _fbKey,
                  initialValue: {
                    VenueDetailedConstants.name: widget.venue.name,
                    VenueDetailedConstants.categories: widget.venue.categories,
                    VenueDetailedConstants.description:
                        widget.venue.description,
                    'coordinates_latitude':
                        widget.venue.coordinates.latitude.toString(),
                    'coordinates_longitude':
                        widget.venue.coordinates.longitude.toString(),
                    'address_street': widget.venue.address.street,
                    'address_town': widget.venue.address.town,
                    'address_county': widget.venue.address.county,
                    'address_postcode': widget.venue.address.postcode,
                    // TODO: Number of Lakes,
                    'amenities_list': widget.venue.amenities,
                    'contact_email': widget.venue.contactDetails.email,
                    'contact_phone': widget.venue.contactDetails.phone,
                    'contact_url': widget.venue.websiteURL,
                    'social_facebook': widget.venue.social.facebook,
                    'social_instagram': widget.venue.social.instagram,
                    'social_twitter': widget.venue.social.twitter,
                    'social_youtube': widget.venue.social.youtube,
                    'fish_stocked': widget.venue.fishStocked,
                    'fishing_types': widget.venue.fishingTypes,
                    'tickets': widget.venue.tickets,
                    'fishing_rules': widget.venue.fishingRules,
                    'monday_open': widget.venue.operationalHours.monday.open,
                    'monday_close': widget.venue.operationalHours.monday.close,
                    'tuesday_open': widget.venue.operationalHours.tuesday.open,
                    'tuesday_close':
                        widget.venue.operationalHours.tuesday.close,
                    'wednesday_open':
                        widget.venue.operationalHours.wednesday.open,
                    'wednesday_close':
                        widget.venue.operationalHours.wednesday.close,
                    'thursday_open':
                        widget.venue.operationalHours.thursday.open,
                    'thursday_close':
                        widget.venue.operationalHours.thursday.close,
                    'friday_open': widget.venue.operationalHours.friday.open,
                    'friday_close': widget.venue.operationalHours.friday.close,
                    'saturday_open':
                        widget.venue.operationalHours.saturday.open,
                    'saturday_close':
                        widget.venue.operationalHours.saturday.close,
                    'sunday_open': widget.venue.operationalHours.sunday.open,
                    'sunday_close': widget.venue.operationalHours.sunday.close,
                    VenueDetailedConstants.assetsPath: widget.venue.assetsPath,
                  },
                  autovalidate: true,
                  child: Column(
                    children: <Widget>[
                      _OverviewSection(),
                      SizedBox(height: 16),
                      _CoordinatesSection(),
                      SizedBox(height: 16),
                      _AddressSection(),
                      SizedBox(height: 16),
                      _AmenitiesSection(),
                      SizedBox(height: 16),
                      _ContactDetailsSection(),
                      SizedBox(height: 16),
                      _SocialLinksSection(),
                      SizedBox(height: 16),
                      _FishStockedSection(),
                      SizedBox(height: 16),
                      _FishingTypesSection(),
                      SizedBox(height: 16),
                      _TicketsSection(),
                      SizedBox(height: 16),
                      _FishingRulesSection(),
                      SizedBox(height: 16),
                      _OperationalHoursSection(),
                      SizedBox(height: 16),
                      _PhotosSection(),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    MaterialButton(
                        child: Text("Submit"),
                        onPressed: () {
                          Function _valueFor = ({String attribute}) {
                            return _fbKey.currentState.fields[attribute]
                                .currentState.value;
                          };

                          HoursOfOperation operationalHours = HoursOfOperation(
                            monday: OpeningHoursDay(
                              open: _valueFor(attribute: 'monday_open'),
                              close: _valueFor(attribute: 'monday_close'),
                            ),
                            tuesday: OpeningHoursDay(
                              open: _valueFor(attribute: 'tuesday_open'),
                              close: _valueFor(attribute: 'tuesday_close'),
                            ),
                            wednesday: OpeningHoursDay(
                              open: _valueFor(attribute: 'wednesday_open'),
                              close: _valueFor(attribute: 'wednesday_close'),
                            ),
                            thursday: OpeningHoursDay(
                              open: _valueFor(attribute: 'thursday_open'),
                              close: _valueFor(attribute: 'thursday_close'),
                            ),
                            friday: OpeningHoursDay(
                              open: _valueFor(attribute: 'friday_open'),
                              close: _valueFor(attribute: 'friday_close'),
                            ),
                            saturday: OpeningHoursDay(
                              open: _valueFor(attribute: 'saturday_open'),
                              close: _valueFor(attribute: 'saturday_close'),
                            ),
                            sunday: OpeningHoursDay(
                              open: _valueFor(attribute: 'sunday_open'),
                              close: _valueFor(attribute: 'sunday_close'),
                            ),
                          );
                          final _venue = VenueDetailed(
                            name: _valueFor(
                                attribute: VenueDetailedConstants.name),
                            categories: _valueFor(attribute: 'categories'),
                            description: _valueFor(
                                attribute: VenueDetailedConstants.description),
                            address: VenueAddress(
                              street: _valueFor(attribute: 'address_street'),
                              town: _valueFor(attribute: 'address_town'),
                              county: _valueFor(attribute: 'address_county'),
                              postcode:
                                  _valueFor(attribute: 'address_postcode'),
                            ),
                            amenities: _valueFor(attribute: 'amenities_list'),
                            contactDetails: ContactDetails(
                              email: _valueFor(attribute: 'contact_email'),
                              phone: _valueFor(attribute: 'contact_phone'),
                            ),
                            social: Social(
                              facebook: _valueFor(attribute: 'social_facebook'),
                              instagram:
                                  _valueFor(attribute: 'social_instagram'),
                              twitter: _valueFor(attribute: 'social_twitter'),
                              youtube: _valueFor(attribute: 'social_youtube'),
                            ),
                            fishStocked: _valueFor(attribute: 'fish_stocked'),
                            fishingTypes: _valueFor(attribute: 'fishing_types'),
                            tickets: _valueFor(attribute: 'tickets'),
                            operationalHours: operationalHours,
                            fishingRules: _valueFor(attribute: 'fishing_rules'),
                          );
                          if (_fbKey.currentState.saveAndValidate()) {
                            final result =
                                VenueDetailedJSONSerializer().toMap(_venue);
                            print(result);
                            final _latitude =
                                _valueFor(attribute: 'coordinates_latitude');
                            final _longitude =
                                _valueFor(attribute: 'coordinates_longitude');

                            if (_latitude != null && _longitude != null) {
                              final double _latitude = double.parse(
                                  _valueFor(attribute: 'coordinates_latitude'));
                              assert(_latitude is double);
                              final double _longitude = double.parse(_valueFor(
                                  attribute: 'coordinates_longitude'));
                              assert(_longitude is double);
                              result["coordinates"] = GeoPoint(
                                _latitude,
                                _longitude,
                              );
                            }

                            void _addPoint(
                                {VenueDetailed venue,
                                String name,
                                String id,
                                double lat,
                                double long}) {
                              print('adding point');
                              final _geo = Geoflutterfire();

                              VenueSearch venueSearch = VenueSearch(
                                name: venue.name,
                                categories: venue.categories,
                                id: id,
                                imageURL: null,
                                address: venue.address,
                                amenities: venue.amenities,
                                fishStocked: venue.fishStocked,
                                fishingTypes: venue.fishingTypes,
                              );

                              GeoFirePoint geoFirePoint =
                                  _geo.point(latitude: lat, longitude: long);

                              final result = VenueSearchJSONSerializer()
                                  .toMap(venueSearch);
                              result['position'] = geoFirePoint.data;

                              Firestore.instance
                                  .collection('venues_locations')
                                  .document(id)
                                  .setData(result, merge: false)
                                  .whenComplete(() {
                                print(
                                    'added ${geoFirePoint.hash} successfully');
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            Text('Form successfully submitted'),
                                        content: SingleChildScrollView(
                                          child: Text(
                                              'Tap Return to dismiss this page.'),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Return'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _fbKey.currentState.reset();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              });
                            }

                            Future postNewVenue() async {
                              await Firestore.instance
                                  .collection('venues_detail')
                                  .document(widget.venueID)
                                  .setData(result, merge: false)
                                  .then((doc) {
                                final double _latitude = double.parse(_valueFor(
                                    attribute: 'coordinates_latitude'));
                                assert(_latitude is double);
                                final double _longitude = double.parse(
                                    _valueFor(
                                        attribute: 'coordinates_longitude'));
                                assert(_longitude is double);
                                _addPoint(
                                  venue: _venue,
                                  name: result['name'],
                                  id: widget.venueID,
                                  lat: _latitude,
                                  long: _longitude,
                                );
                              });

//                              await Firestore.instance
//                                  .collection('venues_detail')
//                                  .add(result).then((doc) {
//                                final double _latitude = double.parse(
//                                    _valueFor(attribute: 'coordinates_latitude'));
//                                assert(_latitude is double);
//                                final double _longitude = double.parse(
//                                    _valueFor(attribute: 'coordinates_longitude'));
//                                assert(_longitude is double);
//                                _addPoint(
//                                  venue: _venue,
//                                  name: result['name'],
//                                  id: doc.documentID,
//                                  lat: _latitude,
//                                  long: _longitude,
//                                );
//                              });
                            }

                            postNewVenue();
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        'There was an issue trying to submit your form'),
                                    content: SingleChildScrollView(
                                      child: Text(
                                          'Please correct any incorrect entries and try again.'),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }),
                    MaterialButton(
                      child: Text("Reset"),
                      onPressed: () {
                        _fbKey.currentState.reset();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Add a Venue'),
        FormBuilderTextField(
          attribute: "name",
          decoration: InputDecoration(labelText: "Name of Venue *"),
          maxLines: 1,
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(50),
          ],
        ),
        FormBuilderCheckboxList(
          decoration: InputDecoration(labelText: "Categories *"),
          activeColor: HouseColors.accentGreen,
          checkColor: HouseColors.primaryGreen,
          attribute: "categories",
          options: [
            FormBuilderFieldOption(value: "lake", child: Text('Lake')),
            FormBuilderFieldOption(value: "shop", child: Text('Shop')),
          ],
        ),
        FormBuilderTextField(
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: null,
          attribute: "description",
          autocorrect: false,
          decoration: InputDecoration(
              labelText: "Description",
              helperText:
                  "Include pricing information or details on how to get to your venue here",
              border: OutlineInputBorder()),
          validators: [
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(1000),
          ],
        ),
      ],
    );
  }
}

class _FishingRulesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Fishing Rules'),
        SizedBox(height: 16),
        FormBuilderTextField(
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: null,
          attribute: "fishing_rules",
          decoration: InputDecoration(
              labelText: "Fishing Rules",
              helperText:
                  "Information on fishing rules and regulations for this venue",
              border: OutlineInputBorder()),
        ),
      ],
    );
  }
}

class _AddressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Address'),
        FormBuilderTextField(
          attribute: "address_street",
          decoration: InputDecoration(labelText: "Street *"),
          maxLines: 1,
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(100),
          ],
        ),
        FormBuilderTextField(
          attribute: "address_town",
          decoration: InputDecoration(labelText: "Town *"),
          maxLines: 1,
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(100),
          ],
        ),
        FormBuilderTextField(
          attribute: "address_county",
          decoration: InputDecoration(labelText: "County *"),
          maxLines: 1,
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(100),
          ],
        ),
        FormBuilderTextField(
          attribute: "address_postcode",
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: "Postcode *"),
          maxLines: 1,
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(6),
            FormBuilderValidators.maxLength(8),
          ],
        ),
      ],
    );
  }
}

enum Amenities {
  toilets,
  showers,
  foodAndDrink,
  nightFishing,
  wheelchairAccess,
  guestsAllowed,
  trolleyHire,
  takeawayFriendly,
  animalFriendly,
  tuition,
  electricity,
  equipmentHire,
  wifi,
  camping,
}

class _AmenitiesSection extends StatelessWidget {
  final ReCase toilets = ReCase(describeEnum(Amenities.toilets));
  final ReCase showers = ReCase(describeEnum(Amenities.showers));
  final ReCase foodAndDrink = ReCase(describeEnum(Amenities.foodAndDrink));
  final ReCase nightFishing = ReCase(describeEnum(Amenities.nightFishing));
  final ReCase wheelchairAccess =
      ReCase(describeEnum(Amenities.wheelchairAccess));
  final ReCase guestsAllowed = ReCase(describeEnum(Amenities.guestsAllowed));
  final ReCase trolleyHire = ReCase(describeEnum(Amenities.trolleyHire));
  final ReCase takeawayFriendly =
      ReCase(describeEnum(Amenities.takeawayFriendly));
  final ReCase animalFriendly = ReCase(describeEnum(Amenities.animalFriendly));
  final ReCase tuition = ReCase(describeEnum(Amenities.tuition));
  final ReCase electricity = ReCase(describeEnum(Amenities.electricity));
  final ReCase equipmentHire = ReCase(describeEnum(Amenities.equipmentHire));
  final ReCase wifi = ReCase(describeEnum(Amenities.wifi));
  final ReCase camping = ReCase(describeEnum(Amenities.camping));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Amenities'),
        FormBuilderTouchSpin(
          attribute: "amenities_num_lakes",
          decoration: InputDecoration(labelText: "Number of Lakes"),
          initialValue: 0,
          min: 0,
          max: 100,
          step: 1,
        ),
        FormBuilderCheckboxList(
          attribute: "amenities_list",
          options: [
            FormBuilderFieldOption(
                value: toilets.snakeCase, child: Text(toilets.titleCase)),
            FormBuilderFieldOption(
                value: showers.snakeCase, child: Text(showers.titleCase)),
            FormBuilderFieldOption(
                value: foodAndDrink.snakeCase,
                child: Text(foodAndDrink.titleCase)),
            FormBuilderFieldOption(
                value: nightFishing.snakeCase,
                child: Text(nightFishing.titleCase)),
            FormBuilderFieldOption(
                value: wheelchairAccess.snakeCase,
                child: Text(wheelchairAccess.titleCase)),
            FormBuilderFieldOption(
                value: guestsAllowed.snakeCase,
                child: Text(guestsAllowed.titleCase)),
            FormBuilderFieldOption(
                value: trolleyHire.snakeCase,
                child: Text(trolleyHire.titleCase)),
            FormBuilderFieldOption(
                value: takeawayFriendly.snakeCase,
                child: Text(takeawayFriendly.titleCase)),
            FormBuilderFieldOption(
                value: animalFriendly.snakeCase,
                child: Text(animalFriendly.titleCase)),
            FormBuilderFieldOption(
                value: tuition.snakeCase, child: Text(tuition.titleCase)),
            FormBuilderFieldOption(
                value: electricity.snakeCase,
                child: Text(electricity.titleCase)),
            FormBuilderFieldOption(
                value: equipmentHire.snakeCase,
                child: Text(equipmentHire.titleCase)),
            FormBuilderFieldOption(
                value: wifi.snakeCase, child: Text(wifi.titleCase)),
            FormBuilderFieldOption(
                value: camping.snakeCase, child: Text(camping.titleCase)),
          ],
        ),
      ],
    );
  }
}

class _ContactDetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Venue Contact Details'),
        FormBuilderTextField(
          attribute: "contact_email",
          decoration: InputDecoration(
            labelText: "Email",
            icon: Icon(Icons.email),
          ),
          maxLines: 1,
          validators: [
            FormBuilderValidators.email(),
          ],
        ),
        FormBuilderTextField(
          attribute: "contact_phone",
          decoration: InputDecoration(
            labelText: "Phone",
            icon: Icon(Icons.phone),
          ),
          maxLines: 1,
          validators: [
            // TODO: Add validation for phone number
          ],
        ),
        FormBuilderTextField(
          attribute: "contact_url",
          decoration: InputDecoration(
            labelText: "Website URL",
            icon: Icon(Icons.language),
            hintText: "https://www.add_this_part_here",
          ),
          maxLines: 1,
          validators: [
            FormBuilderValidators.url(),
          ],
        ),
      ],
    );
  }
}

class _SocialLinksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Social Links'),
        FormBuilderTextField(
          attribute: "social_facebook",
          decoration: InputDecoration(
            labelText: "Facebook",
            helperText: "www.facebook.com/your_page_here",
          ),
          maxLines: 1,
          validators: [],
        ),
        FormBuilderTextField(
          attribute: "social_instagram",
          decoration: InputDecoration(
            labelText: "Instagram",
            helperText: "@your_handle_here",
          ),
          maxLines: 1,
          validators: [],
        ),
        FormBuilderTextField(
          attribute: "social_twitter",
          decoration: InputDecoration(labelText: "Twitter"),
          maxLines: 1,
          validators: [],
        ),
        FormBuilderTextField(
          attribute: "social_youtube",
          decoration: InputDecoration(labelText: "Youtube"),
          maxLines: 1,
          validators: [],
        ),
      ],
    );
  }
}

enum FishStock {
  crucianCarp,
  chub,
  roach,
  grassCarp,
  perch,
  rudd,
  rainbowTrout,
  brownTrout,
  salmon,
  koiCarp,
  grayling,
  zander,
  eel,
  orfe,
  dace,
  gudgeon,
  ruffe,
}

class _FishStockedSection extends StatelessWidget {
  final ReCase crucianCarp = ReCase(describeEnum(FishStock.crucianCarp));
  final ReCase chub = ReCase(describeEnum(FishStock.chub));
  final ReCase roach = ReCase(describeEnum(FishStock.roach));
  final ReCase grassCarp = ReCase(describeEnum(FishStock.grassCarp));
  final ReCase perch = ReCase(describeEnum(FishStock.perch));
  final ReCase rudd = ReCase(describeEnum(FishStock.rudd));
  final ReCase rainbowTrout = ReCase(describeEnum(FishStock.rainbowTrout));
  final ReCase brownTrout = ReCase(describeEnum(FishStock.brownTrout));
  final ReCase salmon = ReCase(describeEnum(FishStock.salmon));
  final ReCase koiCarp = ReCase(describeEnum(FishStock.koiCarp));
  final ReCase grayling = ReCase(describeEnum(FishStock.grayling));
  final ReCase zander = ReCase(describeEnum(FishStock.zander));
  final ReCase eel = ReCase(describeEnum(FishStock.eel));
  final ReCase orfe = ReCase(describeEnum(FishStock.orfe));
  final ReCase dace = ReCase(describeEnum(FishStock.dace));
  final ReCase gudgeon = ReCase(describeEnum(FishStock.gudgeon));
  final ReCase ruffe = ReCase(describeEnum(FishStock.ruffe));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Fish Stocked'),
        FormBuilderCheckboxList(
          attribute: "fish_stocked",
          options: [
            FormBuilderFieldOption(
                value: crucianCarp.snakeCase,
                child: Text(crucianCarp.titleCase)),
            FormBuilderFieldOption(
                value: chub.snakeCase, child: Text(chub.titleCase)),
            FormBuilderFieldOption(
                value: roach.snakeCase, child: Text(roach.titleCase)),
            FormBuilderFieldOption(
                value: grassCarp.snakeCase, child: Text(grassCarp.titleCase)),
            FormBuilderFieldOption(
                value: perch.snakeCase, child: Text(perch.titleCase)),
            FormBuilderFieldOption(
                value: rudd.snakeCase, child: Text(rudd.titleCase)),
            FormBuilderFieldOption(
                value: rainbowTrout.snakeCase,
                child: Text(rainbowTrout.titleCase)),
            FormBuilderFieldOption(
                value: brownTrout.snakeCase, child: Text(brownTrout.titleCase)),
            FormBuilderFieldOption(
                value: salmon.snakeCase, child: Text(salmon.titleCase)),
            FormBuilderFieldOption(
                value: koiCarp.snakeCase, child: Text(koiCarp.titleCase)),
            FormBuilderFieldOption(
                value: grayling.snakeCase, child: Text(grayling.titleCase)),
            FormBuilderFieldOption(
                value: zander.snakeCase, child: Text(zander.titleCase)),
            FormBuilderFieldOption(
                value: eel.snakeCase, child: Text(eel.titleCase)),
            FormBuilderFieldOption(
                value: orfe.snakeCase, child: Text(orfe.titleCase)),
            FormBuilderFieldOption(
                value: dace.snakeCase, child: Text(dace.titleCase)),
            FormBuilderFieldOption(
                value: gudgeon.snakeCase, child: Text(gudgeon.titleCase)),
            FormBuilderFieldOption(
                value: ruffe.snakeCase, child: Text(ruffe.titleCase)),
          ],
        ),
      ],
    );
  }
}

enum FishingTypes {
  coarse,
  match,
  fly,
  carp,
  catfish,
}

class _FishingTypesSection extends StatelessWidget {
  final ReCase coarse = ReCase(describeEnum(FishingTypes.coarse));
  final ReCase match = ReCase(describeEnum(FishingTypes.match));
  final ReCase fly = ReCase(describeEnum(FishingTypes.fly));
  final ReCase carp = ReCase(describeEnum(FishingTypes.carp));
  final ReCase catfish = ReCase(describeEnum(FishingTypes.catfish));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Fishing Types'),
        FormBuilderCheckboxList(
          attribute: "fishing_types",
          options: [
            FormBuilderFieldOption(
                value: coarse.snakeCase, child: Text(coarse.titleCase)),
            FormBuilderFieldOption(
                value: match.snakeCase, child: Text(match.titleCase)),
            FormBuilderFieldOption(
                value: fly.snakeCase, child: Text(fly.titleCase)),
            FormBuilderFieldOption(
                value: carp.snakeCase, child: Text(carp.titleCase)),
            FormBuilderFieldOption(
                value: catfish.snakeCase, child: Text(catfish.titleCase)),
          ],
        ),
      ],
    );
  }
}

enum Tickets {
  day,
  night,
  season,
  syndicate,
  clubWater,
}

class _TicketsSection extends StatelessWidget {
  final ReCase day = ReCase(describeEnum(Tickets.day));
  final ReCase night = ReCase(describeEnum(Tickets.night));
  final ReCase season = ReCase(describeEnum(Tickets.season));
  final ReCase syndicate = ReCase(describeEnum(Tickets.syndicate));
  final ReCase clubWater = ReCase(describeEnum(Tickets.clubWater));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Tickets Available'),
        FormBuilderCheckboxList(
          attribute: "tickets",
          options: [
            FormBuilderFieldOption(
                value: day.snakeCase, child: Text(day.titleCase)),
            FormBuilderFieldOption(
                value: night.snakeCase, child: Text(night.titleCase)),
            FormBuilderFieldOption(
                value: season.snakeCase, child: Text(season.titleCase)),
            FormBuilderFieldOption(
                value: syndicate.snakeCase, child: Text(syndicate.titleCase)),
            FormBuilderFieldOption(
                value: clubWater.snakeCase, child: Text(clubWater.titleCase)),
          ],
        ),
      ],
    );
  }
}

class _CoordinatesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Coordinates'),
        FormBuilderTextField(
          attribute: "coordinates_latitude",
          maxLines: 1,
          decoration: InputDecoration(
            labelText: "Latitude *",
          ),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
          ],
        ),
        FormBuilderTextField(
          attribute: "coordinates_longitude",
          maxLines: 1,
          decoration: InputDecoration(labelText: "Longitude *"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
          ],
        ),
      ],
    );
  }
}

class _OperationalHoursSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Operational Hours'),
        SizedBox(height: 16),
        _OperationalHoursDay(day: 'Monday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Tuesday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Wednesday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Thursday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Friday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Saturday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Sunday'),
      ],
    );
  }
}

class _OperationalHoursDay extends StatelessWidget {
  _OperationalHoursDay({this.day});

  final String day;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text("$day"),
        ),
        FormBuilderDropdown(
          attribute: "${day.toLowerCase()}_open",
          decoration: InputDecoration(labelText: "Open"),
          hint: Text('Open'),
          items: OpeningHoursList.thirtyIntervalFromMorning
              .map(
                  (time) => DropdownMenuItem(value: time, child: Text("$time")))
              .toList(),
        ),
        FormBuilderDropdown(
          attribute: "${day.toLowerCase()}_close",
          decoration: InputDecoration(labelText: "Close"),
          hint: Text('Close'),
          items: OpeningHoursList.thirtyIntervalFromAfternoon
              .map(
                  (time) => DropdownMenuItem(value: time, child: Text("$time")))
              .toList(),
        ),
      ],
    );
  }
}

class _PhotosSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HouseTexts.subtitle('Photos'),
        SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ImagePickerContainer(),
            ImagePickerContainer(),
            ImagePickerContainer(),
            ImagePickerContainer(),
            ImagePickerContainer(),
            ImagePickerContainer(),
          ],
        )
      ],
    );
  }
}
