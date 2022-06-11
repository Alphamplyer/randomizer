
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:randomizer/src/models/random_number_configuration.dart';
import 'package:randomizer/src/pages/configure_random.dart';
import 'package:randomizer/src/shared/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StreamController<RandomNumbersConfiguration> _generatedNumbersController = StreamController<RandomNumbersConfiguration>();
  late final ValueNotifier<bool> _isPanelOpen;
  RandomNumbersConfiguration? _configuration;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
     _isPanelOpen = ValueNotifier<bool>(false);
    _loadConfiguration();
  }

  Future<SharedPreferences> _getSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> _loadConfiguration() async {
    SharedPreferences prefs = await _getSharedPreferences();
    String? json = prefs.getString(kSavedRandomNumberConfigurationKey);
    
    if (json != null) {
      _configuration = RandomNumbersConfiguration.fromJson(jsonDecode(json));
      _generatedNumbersController.add(_configuration!);
    }
    else {
      _configureRandom();
    }
  }

  Future<void> _saveConfiguration() async {
    SharedPreferences prefs = await _getSharedPreferences();
    prefs.setString(kSavedRandomNumberConfigurationKey, jsonEncode(_configuration!.toJson()));
  }

  void _generateNewRandomNumber() {
    if (_configuration == null) {
      return;
    }

    _configuration!.generateNewNumer();
    _generatedNumbersController.add(_configuration!);
    _saveConfiguration(); 
  }

  void _configureRandom() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfigureRandomPage(),
      ),
    );

    if (result == null) return;
      
    int min = result[0];
    int max = result[1];

    _configuration = RandomNumbersConfiguration(
      minimum: min,
      maximum: max,
    );

    _configuration!.generateNewNumer();

    _generatedNumbersController.add(_configuration!);
    await _saveConfiguration();
  }

  @override
  void dispose() {
    _generatedNumbersController.close();
    super.dispose();
  }

  void _togglePanel() {
    _isPanelOpen.value = !_isPanelOpen.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randomizer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _configureRandom(),
          ),
        ],
      ),
      body: StreamBuilder<RandomNumbersConfiguration>(
        stream: _generatedNumbersController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          '${snapshot.data!.generatedNumbers.last}',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Text("Generate Random Number"),
                          onPressed: () {
                            _generateNewRandomNumber();
                          },
                        ),
                      ),
                    ),
                    Container(
                      color: Theme.of(context).cardColor,
                      height: 30
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _isPanelOpen,
                    child: Builder(
                      builder: (context) {
                        List<int> sortedNumbers = snapshot.data!.generatedNumbers..sort();

                        return ListView(
                          children: List.generate(snapshot.data!.count, (index) => ListTile(
                            title: Text(sortedNumbers[index].toString()),
                          )),
                        );
                      }
                    ),
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        width: double.infinity,
                        height: _isPanelOpen.value ? MediaQuery.of(context).size.height * 0.8 : 30,
                        child: _isPanelOpen.value ? SingleChildScrollView(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: InkWell(
                                    onTap: _togglePanel,
                                    child: const Center(
                                      child: Icon(Icons.arrow_downward)
                                    )
                                  )
                                ),
                                Expanded(child: child!)
                              ],
                            ),
                          ),
                        )
                        : InkWell(
                          onTap: _togglePanel,
                          child: const Center(
                            child: Icon(Icons.arrow_upward)
                          )
                        )
                      );
                    }
                  )
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if(snapshot.connectionState == ConnectionState.active) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text("No data"));
          }
        },
      ),
    );
  }
}