import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FibbonacciAppPage(),
    );
  }
}

class FibbonacciAppPage extends StatefulWidget{
  const FibbonacciAppPage({super.key});

  @override
  State<FibbonacciAppPage> createState() => _FibbonacciAppPageState();
}

class _FibbonacciAppPageState extends State<FibbonacciAppPage>{
  final TextEditingController controller = TextEditingController();
  String output = "";

  List<BigInt> FibbonacciUpto(BigInt limit){
    List<BigInt> result = [];

    if(limit < BigInt.zero){
      return result;
    }

    BigInt a = BigInt.zero;
    BigInt b = BigInt.one;

    result.add(b);

    while(true)
    {
      BigInt next = a + b;
      if(next > limit) break;
      result.add(next);
      a = b;
      b = next;
    }

    return result;
  }

  void generateFibonacci() {
    if(controller.text.isEmpty){
      return;
    }
    // here the text of forexample 10 is sent to the limit
    BigInt limit = BigInt.parse(controller.text);
    // limit then goes for in the function
    List<BigInt> fibs = FibbonacciUpto(limit);

    setState(() {
      output = fibs.join(", ");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fibonacci App")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter a number",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: generateFibonacci,
              child: const Text("Generate"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(output),
              ),
            ),
          ],
        ),
      ),
    );
  }
}