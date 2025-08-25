import 'dart:io';

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







