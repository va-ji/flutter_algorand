import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_onboarding/screens/screens.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../models/temp/tempCharModel.dart';

class CompleteService extends StatelessWidget {
  static const route = '/service';
  const CompleteService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      body:
          // Provider.of<CharityDataProvider>(context, listen: false)
          //         .charities
          //         .isEmpty
          //     ? const Center(
          //         child: Text(
          //         'No Open Charities',
          //         style: TextStyle(color: Colors.black, fontSize: 45),
          //       ))
          //     :
          Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey, Colors.black54]),
            ),
          ),
          Positioned(
            top: 100,
            height: MediaQuery.of(context).size.height - 150,
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8),
                crossAxisCount: 2,
                children:
                    // Provider.of<CharityDataProvider>(context)
                    //     .charities
                    //     .map(
                    models
                        .map(
                          (charity) => GridTile(
                            child: InkWell(
                              child: SizedBox(
                                width: 180,
                                height: 220,
                                child: Column(
                                  children: [
                                    Card(
                                      elevation: 25,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            child: Image.asset(charity.path!),
                                            // Image.file(
                                            //   File(charity.file.path),
                                            //   fit: BoxFit.cover,
                                            // ),
                                          ),
                                          Text(
                                            'Title: ${charity.title}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Description: ${charity.description}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Donation: ${charity.donation.toString()}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/charity', arguments: charity);
                              },
                            ),
                          ),
                        )
                        .toList()),
          ),
        ],
      ),
    );
  }
}
