
import 'dart:math';

class RandomNumbersConfiguration {
  RandomNumbersConfiguration({
    this.minimum = 1,
    this.maximum = 100,
    List<int>? generatedNumbers,
    List<int>? leftNumbersToBeGenerated,
  }) {
    this.generatedNumbers = generatedNumbers ?? <int>[];
    _leftNumbersToBeGenerated = leftNumbersToBeGenerated ?? _generateLeftNumbersToBeGenerated(minimum, maximum);
  }

  final int minimum;
  final int maximum;
  late List<int> generatedNumbers;
  late List<int> _leftNumbersToBeGenerated;

  void generateNewNumer() {
    if (_leftNumbersToBeGenerated.isEmpty) {
      _leftNumbersToBeGenerated = _generateLeftNumbersToBeGenerated(minimum, maximum);
    }

    final int index = Random().nextInt(_leftNumbersToBeGenerated.length);
    final int newNumber = _leftNumbersToBeGenerated[index];
    _leftNumbersToBeGenerated.removeAt(index);

    generatedNumbers.add(newNumber);
  }
  
  static List<int> _generateLeftNumbersToBeGenerated(int minimum, int maximum) {
    return List<int>.generate(maximum - minimum, (index) => minimum + index);
  }

  int get count => generatedNumbers.length;

  Map<String, dynamic> toJson() {
    return {
      'minimum': minimum,
      'maximum': maximum,
      'generatedNumbers': generatedNumbers,
      'leftNumbersToBeGenerated': _leftNumbersToBeGenerated,
    };
  }

  factory RandomNumbersConfiguration.fromJson(Map<String, dynamic> json) {
    return RandomNumbersConfiguration(
      minimum: json['minimum'] as int,
      maximum: json['maximum'] as int,
      generatedNumbers: (json['generatedNumbers'] as List).map((e) => e as int).toList(),
      leftNumbersToBeGenerated: (json['leftNumbersToBeGenerated'] as List).map((e) => e as int).toList(),
    );
  }
}