import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PricePredictionForm extends StatefulWidget {
  @override
  _PricePredictionFormState createState() => _PricePredictionFormState();
}

class _PricePredictionFormState extends State<PricePredictionForm> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController demandController = TextEditingController();
  TextEditingController previousYearSalesController = TextEditingController();
  TextEditingController previousYearPriceController = TextEditingController();
  TextEditingController priceChangeController = TextEditingController();

  Future<Map<String, dynamic>> predictPrice() async {
    final url = Uri.parse('http://192.168.209.141:5000/predict_price');
    final headers = {'Content-Type': 'application/json'};
    final data = {
      'category': categoryController.text,
      'demand': int.parse(demandController.text),
      'previous_year_sales': int.parse(previousYearSalesController.text),
      'previous_year_price': double.parse(previousYearPriceController.text),
      'price_change': double.parse(priceChangeController.text),
    };

    print('Sending request to: $url');
    print('Request data: $data');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('Error predicting price: $e');
      throw e; // Rethrow the error to handle it in the caller code
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: demandController,
              decoration: InputDecoration(labelText: 'Demand'),
            ),
            TextField(
              controller: previousYearSalesController,
              decoration: InputDecoration(labelText: 'Previous Year Sales'),
            ),
            TextField(
              controller: previousYearPriceController,
              decoration: InputDecoration(labelText: 'Previous Year Price'),
            ),
            TextField(
              controller: priceChangeController,
              decoration: InputDecoration(labelText: 'Price Change'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                predictPrice().then((value) {
                  final predictedPrice = value['predicted_price'];
                  // Do something with the predicted price, like display it in a dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Predicted Price'),
                      content: Text('The predicted price is: $predictedPrice'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }).catchError((error) {
                  // Handle error
                  print('Error predicting price: $error');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Failed to predict price: $error'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                });
              },
              child: Text('Predict Price'),
            ),
          ],
        ),
      ),
    );
  }
}
