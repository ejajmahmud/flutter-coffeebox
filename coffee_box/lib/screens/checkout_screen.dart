import 'package:flutter/material.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:coffee_box/providers/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:coffee_box/providers/choice_provider.dart';

class CheckoutPage extends StatelessWidget {
  Future<void> startSquarePayment(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final choiceProvider = Provider.of<ChoiceProvider>(context, listen: false);
    authProvider.fetchUserData();
    String planVariationId = "";

    try {
      await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: (CardDetails result) async {
          try {
            String nonce = result.nonce;
            String? customerId = authProvider.customerId;

            if (customerId == '') {
              throw Exception('Customer ID is null');
            }

            if (choiceProvider.selectedCoffeeBox?.name == "CoffeeBox 3") {
              planVariationId = "WBSVKEZX6JIQKTYCH445IKAY";
            } else if (choiceProvider.selectedCoffeeBox?.name ==
                "CoffeeBox 6") {
              planVariationId = "ALEROJZLYYZW3INBVUIHIYRR";
            } else if (choiceProvider.selectedCoffeeBox?.name ==
                "CoffeeBox 9") {
              planVariationId = "CCV74L7NTJGAD3YZL7VUQAZK";
            } else {
              throw Exception('Invalid CoffeeBox selection');
            }

            final response = await http.post(
              Uri.parse(
                  'http://192.168.0.14:8080/api/subscriptions?customerId=$customerId&planVariationId=$planVariationId&cardNonce=$nonce'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
            );
            print(response.statusCode);
            if (response.statusCode == 200) {
              var responseBody = jsonDecode(response.body);
              print(responseBody);
              if (responseBody['subscription']['status'] == 'ACTIVE') {
                print('Payment Successful');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sucessfully subscribed')),
                );
                InAppPayments.completeCardEntry(
                  onCardEntryComplete: () {
                    Navigator.pop(context);
                  },
                );
              } else {
                print('Subscription Failed: ${responseBody['errors']}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Subscription Failed: ${responseBody['errors']}')),
                );
              }
            } else {
              print('Server error: ${response.statusCode}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Server error: ${response.statusCode}')),
              );
            }
          } catch (ex) {
            print('Error sending nonce to server: $ex');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error sending nonce to server: $ex')),
            );
          }
        },
        onCardEntryCancel: () {
          print('Card entry flow was cancelled');
        },
      );
    } catch (ex) {
      print('Error starting card entry flow: $ex');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting card entry flow: $ex')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final choiceProvider = Provider.of<ChoiceProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Delivery Address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              authProvider.userAddress ?? '',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit, color: Colors.black),
                  label: Text('Edit Address',
                      style: TextStyle(color: Colors.black)),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.note, color: Colors.grey),
                  label: Text('Add Note', style: TextStyle(color: Colors.grey)),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Divider(height: 1.0, color: Colors.grey),
            SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    choiceProvider.selectedCoffeeBox?.imagePath ?? '',
                    width: 180.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    choiceProvider.selectedCoffeeBox?.name ?? '',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Divider(height: 1.0, color: Colors.grey),
            SizedBox(height: 16.0),
            Text(
              'Payment Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Price',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '\$${choiceProvider.selectedCoffeeBox?.price ?? ''}',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            startSquarePayment(context);
          },
          child: Text(
            'Subscribe',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFC67C4E),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            textStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
