import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

import '../services/client/region_handler.dart';

class TabRegionAdding extends StatefulWidget {
  const TabRegionAdding({Key? key}) : super(key: key);

  @override
  State<TabRegionAdding> createState() => _TabRegionAddingState();
}

class _TabRegionAddingState extends State<TabRegionAdding> with ChangeNotifier {
  final _regionIdentifier = TextEditingController(text: '');
  final _uuidController = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

  static final _regexUUID = RegExp(
      r'[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(right: 5, left: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Add a region',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: uuidField),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 30, right: 15, left: 15, bottom: 30),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(
                    'Registered regions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: RegionHandler().regions.length != 0
                        ? ListView.builder(
                            addAutomaticKeepAlives: true,
                            shrinkWrap: true,
                            itemCount: RegionHandler().regions.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(children: [
                                            Row(children: [
                                              Expanded(child: Text('Region:')),
                                              Expanded(
                                                  child: Text(RegionHandler()
                                                      .regions[index]
                                                      .identifier)),
                                            ]),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            Row(children: [
                                              Expanded(
                                                  child: Text(
                                                'proxID:',
                                              )),
                                              Expanded(
                                                child: Text(RegionHandler()
                                                    .regions[index]
                                                    .proximityUUID
                                                    .toString()),
                                              ),
                                            ]),
                                          ]),
                                        ),
                                        SizedBox(
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                RegionHandler().removeRegion(
                                                    RegionHandler()
                                                        .regions[index]);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.black,
                                      thickness: 1,
                                    )
                                  ]));
                            },
                          )
                        : Container(
                            child: Text('No regions are registered yet.')),
                  ),
                ),
              ]),
            )
          ]),
        ),
      ),
    );
  }

  Widget get uuidField {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Expanded(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: TextFormField(
              controller: _regionIdentifier,
              decoration: InputDecoration(
                labelText: 'Region name',
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Region name required';
                }
                if (RegionHandler()
                    .regions
                    .any((element) => element.identifier == val)) {
                  return 'This region is already registered!';
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: TextFormField(
              controller: _uuidController,
              decoration: InputDecoration(
                labelText: 'Proximity UUID',
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Proximity UUID required';
                }

                if (!_regexUUID.hasMatch(val)) {
                  return 'Invalid Proxmity UUID format';
                }

                return null;
              },
            ),
          ),
        ]),
      ),
      IconButton(
          iconSize: 40,
          icon: Icon(
            Icons.add,
            color: Colors.green,
          ),
          onPressed: () {
            (_formKey.currentState!.validate())
                ? setState(() {
                    RegionHandler().addRegion(Region(
                        identifier: _regionIdentifier.text,
                        proximityUUID: _uuidController.text));
                  })
                : print('ku je ti');
          })
    ]);
  }
}
