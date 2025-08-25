import 'package:mini_project_1/mini_project_1.dart' as mini_project_1;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

void main(List<String> arguments) {
  print('Hello world: ${mini_project_1.calculate()}!');
}

Future<void> addNewExpense(String userId) async {
 print("\n======== Add new item ========");
 stdout.write("Item: ");
 String? item = stdin.readLineSync()?.trim();
 stdout.write("Paid: ");
 String? paidStr = stdin.readLineSync()?.trim();
  if (item == null || paidStr == null) {
   print("Incomplete input");
   return;
 }
  try {
   int paid = int.parse(paidStr);
   final url = Uri.parse('http://localhost:3000/expenses');
   final body = {
     "userId": userId,
     "item": item,
     "paid": paid,
   };
   final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body));


   if (response.statusCode == 201) {
     print("Inserted!");
   } else {
     print('Connection error! Status code: ${response.statusCode}');
   }
 } catch (e) {
   print("Invalid paid amount. Please enter a number.");
 }
}
