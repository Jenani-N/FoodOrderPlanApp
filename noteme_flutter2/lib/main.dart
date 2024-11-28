import 'package:flutter/material.dart';
import 'newOrder.dart';
import 'databaseHelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FoodOrderApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'All Order Plans'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  //Function to get all db entries to display all order plans on the homepage
  Future<void> _loadOrders() async {
    final data = await databaseHelper.instance.fetchorderPlan();
    setState(() {
      // Make a modifiable copy of the fetched data
      orders = List<Map<String, dynamic>>.from(data);
    });
  }

  //Function to insert a order plan entry to db
  Future<void> _addOrder(Map<String, String> newOrder) async {
    await databaseHelper.instance.insertOrder(newOrder);
    _loadOrders();
  }

  //Function to delete order plan entry from db
  Future<void> _deleteOrderPlan(int index) async {
  final int orderId = orders[index]['id'];
  //deletion query
  await databaseHelper.instance.deleteOrderPlan(orderId);

  setState(() {
    orders.removeAt(index);
  });

  //display confirmation msg of deletion
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Order Plan has been deleted.')),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: orders.isEmpty // if there are no orders, display the message "No Orders here"
        ? Center(
            child: Text(
              'No Order Plans here',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
      )
        : ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Container(
              //Adding a border around each order plan entry for easy readability
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Spacing around each ListTile
                decoration: BoxDecoration(
                  //border styling
                  border: Border.all(color: Colors.green, width: 2.0),
                  color: Colors.white70, // Optional: Background color
                ),
              child: ListTile(
                title: Text(orders[index]['date'] ?? ''),
                subtitle: Text('Cost: ${orders[index]['cost'] ?? ''}\nFood: ${orders[index]['food'] ?? ''}'),
                isThreeLine: true,
                trailing: IconButton(onPressed: () => _deleteOrderPlan(index), icon: Icon(Icons.delete,color: Colors.red,)),
                ),
              );},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newOrder = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => newOrderPage()),
          );
          if (newOrder != null){
            setState(() {
              _addOrder(newOrder);
            });
          }
        },
        tooltip: 'New Order',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
