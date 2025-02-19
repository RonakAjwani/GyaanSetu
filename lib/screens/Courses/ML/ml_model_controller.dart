import 'package:flutter/material.dart';
import 'ml_model_service.dart';

class MLModelController extends ChangeNotifier {
  final MLModelService _service = MLModelService();
  String _prediction = '';
  bool _isLoading = false;

  String get prediction => _prediction;
  bool get isLoading => _isLoading;

  Future<void> fetchPrediction(String imagePath) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _prediction = await _service.getPrediction(imagePath);
    } catch (e) {
      _prediction = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
