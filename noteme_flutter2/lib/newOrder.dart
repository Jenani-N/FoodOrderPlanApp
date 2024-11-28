import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class newOrderPage extends StatefulWidget {
  @override
  _newOrderPageState createState() => _newOrderPageState();
}

class _newOrderPageState extends State<newOrderPage>{
  final TextEditingController dateController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController foodController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Order Plan'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                // Ensuring the right format
                if (pickedDate != null) {
                  dateController.text = pickedDate.toIso8601String().split('T').first;
                }
              },
              validator: (value){
                return value!.isEmpty ? 'Please fill in the Date!' : null;
              },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: costController,
            decoration: InputDecoration(labelText: 'Target Cost'),
            validator: (value){
              return value!.isEmpty ? 'Please fill in the Target Cost!' : null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: foodController,
            decoration: InputDecoration(labelText: 'Food Item'),
            validator: (value){
              return value!.isEmpty ? 'Please select the Food Item!' : null;
             },
          ),
          SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(color: Colors.black),
                    ),
                ),
                ElevatedButton(
                  onPressed: (){
                    if (_formKey.currentState!.validate()){
                      final newOrder = {
                        'date': dateController.text,
                        'cost': costController.text,
                        'food': foodController.text,
                      };
                      Navigator.pop(context, newOrder);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade100,
                  ),
                  child: Text('Save', style: TextStyle(color: Colors.black),),),
              ],
            )

    ],
    ),
    ),
      ),
    );
  }

}