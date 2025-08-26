import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

void main() async {
  String? userId = await login();

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
     await showAllExpenses(userId);
   } else if (choice == '2') {
     await showTodayExpenses(userId);
   } else if (choice == '3') {
     await searchExpense(userId);
   } else if (choice == '4') {
     await addNewExpense(userId);
   } else if (choice == '5') {
     await deleteExpense(userId);
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


Future<void> searchExpense(String userId) async {
 print("\n======== Search expense ========");
 stdout.write("Item to search: ");
 String? keyword = stdin.readLineSync()?.trim();
 if (keyword == null || keyword.isEmpty) {
   print("No keyword entered.");
   return;
 }
  final url = Uri.parse('http://localhost:3000/expenses?userId=$userId&keyword=$keyword');
 http.Response response = await http.get(url);


 if (response.statusCode == 200) {
   final result = jsonDecode(response.body) as List;
   if (result.isEmpty) {
     print("No item: $keyword");
   } else {
     print("\n--------- Search results ---------");
     for (Map exp in result) {
       print('id: ${exp["id"]}, item: ${exp["item"]} , paid: ${exp["paid"]} , date: ${exp["date"]}');
     }
   }
 } else {
   print('Connection error! Status code: ${response.statusCode}');
 }
}
   
Future<String?> login() async {
  print("===== Login =====");
  stdout.write("Username: ");
  String? username = stdin.readLineSync()?.trim();
  stdout.write("Password: ");
  String? password = stdin.readLineSync()?.trim();
  if (username == null || password == null) {
    print("Incomplete input");
    return null;
  }

  final body = {"username": username, "password": password};
  final url = Uri.parse('http://localhost:3000/login');
  final response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    print("Login successful.");
    return result['id']?.toString();
  } else if (response.statusCode == 401 || response.statusCode == 500) {
    final result = jsonDecode(response.body);
    print(result);
    return null;
  } else {
    print("Unknown error");
    return null;
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
    final body = {"userId": userId, "item": item, "paid": paid};
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      print("Inserted!");
    } else {
      print('Connection error! Status code: ${response.statusCode}');
    }
  } catch (e) {
    print("Invalid paid amount. Please enter a number.");
  }
}

Future<void> deleteExpense(String userId) async {
 print("\n======== Delete an item ========");
 stdout.write("Item id: ");
 String? idStr = stdin.readLineSync()?.trim();
 if (idStr == null) {
   print("Incomplete input");
   return;
 }
  try {
   int id = int.parse(idStr);
   final url = Uri.parse('http://localhost:3000/expenses/$id?userId=$userId');
   final response = await http.delete(url);


   if (response.statusCode == 200) {
     print("Deleted!");
   } else if (response.statusCode == 404) {
     print("Expense not found or does not belong to this user.");
   } else {
     print('Connection error! Status code: ${response.statusCode}');
   }
 } catch (e) {
   print("Invalid item ID. Please enter a number.");
 }
}
