
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

void main() async {
  String? userId = "test_user";

  if (userId != null) {
    await showExpensesMenu(userId);
  }

  print("Bye");
}

Future<void> showExpensesMenu(String userId) async {
  while (true) {
    print("\n======== Expense Tracking App ========");
    print("1. Show all");
    print("2. Today's expense");
    print("3. Search expense");
    print("4. Add new expense");
    print("5. Delete an expense");
    print("6. Exit");
    stdout.write("Choose... ");
    String? choice = stdin.readLineSync()?.trim();

    if (choice == '1') {
      // Placeholder for showAllExpenses(userId);
      print("Show all expenses (to be implemented)");
    } else if (choice == '2') {
      print("Show today's expenses (to be implemented)");
    } else if (choice == '3') {
      print("Search expense (to be implemented)");
    } else if (choice == '4') {
      print("Add new expense (to be implemented)");
    } else if (choice == '5') {
      print("Delete expense (to be implemented)");
    } else if (choice == '6') {
      return;
    } else {
      print("Invalid choice. Please try again.");
    }
  }
}

Future<void> showAllExpenses(String userId) async {
  final url = Uri.parse('http://localhost:3000/expenses?userId=$userId');
  http.Response response = await http.get(url);

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body) as List;
    int total = 0;
    print("\n--------- All expenses ---------");
    for (Map exp in result) {
      print(
        'id: ${exp["id"]}, item: ${exp["item"]} , paid: ${exp["paid"]} , date: ${exp["date"]}',
      );
      total += exp["paid"] as int;
    }
    print('Total expenses = $total');
  } else {
    print('Connection error! Status code: ${response.statusCode}');
  }
}

Future<void> showTodayExpenses(String userId) async {
  final today = DateTime.now();
  final todayStr =
      "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

  final url = Uri.parse(
    'http://localhost:3000/expenses?userId=$userId&date=$todayStr',
  );
  http.Response response = await http.get(url);

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body) as List;
    int total = 0;
    print("\n--------- Today's expenses ---------");
    for (Map exp in result) {
      print(
        'id: ${exp["id"]}, item: ${exp["item"]} , paid: ${exp["paid"]} , date: ${exp["date"]}',
      );
      total += exp["paid"] as int;
    }
    print('Total expenses = $total');
  } else {
    print('Connection error! Status code: ${response.statusCode}');
  }
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
