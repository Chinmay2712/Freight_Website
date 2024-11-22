import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class FreightPage extends StatefulWidget {
  @override
  State<FreightPage> createState() => _FreightPageState();
}

class _FreightPageState extends State<FreightPage> {
  bool includeNearbyPorts = false;
  bool includeNearbyDestinations = false;
  bool isFCLSelected = false;
  bool isLCLSelected = false;
  String? selectedCommodity;
  String? selectedContainerSize;
  String length = '';
  String width = '';
  String height = '';
  final List<String> commodities = ['Wastepaper', 'Metal'];
  final List<String> containerSizes = [
    '40\' Dry',
    '40\' Dry High',
    '45\' Dry High'
  ];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<String> names = [];
  List<String> countries = [];

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) return;
    final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?name=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        names = data.map((item) => item['name'] as String).toList();
        countries = data.map((item) => item['country'] as String).toList();
      });
    } else {
      setState(() {
        names = [];
        countries = [];
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffF6F9FC),
          title: const Text(
            'Search the best Freight Rates',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: OutlinedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xffE6EBFF)),
                  side: WidgetStateProperty.all(
                    const BorderSide(color: Color(0xFF0139FF)),
                  ),
                ),
                child: const Text(
                  'History',
                  style: TextStyle(
                    color: Color(0xFF0139FF),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xffE5E7F6),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, right: 20.0, left: 20.0, bottom: 100.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffF6F9FC),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, bottom: 16.0, right: 16.0, top: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Autocomplete<String>(
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              return names.where((String option) {
                                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (String selection) {
                              _controller.text = selection;
                            },
                            fieldViewBuilder: (BuildContext context, TextEditingController controller, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  labelText: 'Origin',
                                  prefixIcon: const Icon(Icons.location_on),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onChanged: (value) => fetchSuggestions(value),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Autocomplete<String>(
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              return countries.where((String option) {
                                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (String selection) {
                              _controller.text = selection;
                            },
                            fieldViewBuilder: (BuildContext context, TextEditingController controller, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  labelText: 'Destination',
                                  prefixIcon: const Icon(Icons.location_on),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onChanged: (value) => fetchSuggestions(value),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Flexible(
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: includeNearbyPorts,
                            title: const Text('Include nearby origin ports'),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                includeNearbyPorts = value ?? false;
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: includeNearbyDestinations,
                            title:
                                const Text('Include nearby destination ports'),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                includeNearbyDestinations = value ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Commodity',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            items: commodities
                                .map((commodity) => DropdownMenuItem(
                                      value: commodity,
                                      child: Text(commodity),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCommodity = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Cut Off Date',
                              suffixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onTap: () => _selectDate(context), // Open calendar
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 16.0, left: 16.0, bottom: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Shipment Type:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isFCLSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isFCLSelected = value ?? false;
                            });
                          },
                        ),
                        const Text('FCL'),
                        const SizedBox(
                          width: 50,
                        ),
                        Checkbox(
                          value: isLCLSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isLCLSelected = value ?? false;
                            });
                          },
                        ),
                        const Text('LCL'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Container Size',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            items: containerSizes
                                .map((String value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedContainerSize = newValue!;
                                if (newValue == "40' Dry") {
                                  length = "39.46 ft";
                                  width = "7.70 ft";
                                  height = "7.84 ft";
                                } else if (newValue == "40' Dry High") {
                                  length = "39.46 ft";
                                  width = "7.70 ft";
                                  height = "8.84 ft";
                                } else if (newValue == "45' Dry High") {
                                  length = "45.93 ft";
                                  width = "8.30 ft";
                                  height = "8.84 ft";
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'No of Boxes',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Weight (Kg)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 13.0, left: 16.0, bottom: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Container Internal Dimensions:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Length: $length',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 38,
                              ),
                              Text(
                                'Width: $width',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 38,
                              ),
                              Text(
                                'Height: $height',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 200,
                        ),
                        SizedBox(
                          height: 150, // Adjust the height as needed
                          width: 400, // Adjust the width as needed
                          child: Image.asset(
                            'container_image.png',
                            fit: BoxFit.cover, // Ensures cropping and fitting
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(const Color(0xffE6EBFF)),
                          side: WidgetStateProperty.all(
                            const BorderSide(color: Color(0xFF0139FF)),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min, // Ensures the button adjusts to content
                          children: [
                            Icon(
                              Icons.search, // Search icon
                              color: Color(0xFF0139FF),
                              size: 20, // Adjust size as needed
                            ),
                            SizedBox(width: 3), // Space between icon and text
                            Text(
                              'Search',
                              style: TextStyle(
                                color: Color(0xFF0139FF),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
