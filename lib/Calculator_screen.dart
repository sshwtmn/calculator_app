import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'buttons_calculator.dart';
import 'converter_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String nmbr1="";
  String action="";
  String nmbr2="";

  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('Calculator'),
          centerTitle: false,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.swap_horiz),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConverterScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(16),
                  child: Text("$nmbr1$action$nmbr2".isEmpty
                      ? "0"
                      : "$nmbr1$action$nmbr2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),

                ),
              ),
            ),

            //buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                    width: value==Btn.n0?screenSize.width/2:(screenSize.width / 4),
                    height: screenSize.height / 10,
                    child: buildButton(value)),
              )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
  Widget buildButton(value){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
              child: Text(value,style: const TextStyle(fontWeight: FontWeight.bold,
                fontSize: 24,),
              )
          ),
        ),
      ),
    );
  }
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  // ##############
  // calculates the result
  void calculate() {
    if (nmbr1.isEmpty) return;
    if (action.isEmpty) return;
    if (nmbr2.isEmpty) return;

    final double num1 = double.parse(nmbr1);
    final double num2 = double.parse(nmbr2);

    var result = 0.0;
    switch (action) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      nmbr1 = result.toStringAsPrecision(3);

      if (nmbr1.endsWith(".0")) {
        nmbr1 = nmbr1.substring(0, nmbr1.length - 2);
      }

      action = "";
      nmbr2 = "";
    });
  }

  // ##############
  // converts output to %
  void convertToPercentage() {
    // ex: 434+324
    if (nmbr1.isNotEmpty && action.isNotEmpty && nmbr2.isNotEmpty) {
      // calculate before conversion
      calculate();
    }

    if (action.isNotEmpty) {
      // cannot be converted
      return;
    }

    final number = double.parse(nmbr1);
    setState(() {
      nmbr1 = "${(number / 100)}";
      action = "";
      nmbr2 = "";
    });
  }

  // ##############
  // clears all output
  void clearAll() {
    setState(() {
      nmbr1 = "";
      action = "";
      nmbr2 = "";
    });
  }

  // ##############
  // delete one from the end
  void delete() {
    if (nmbr2.isNotEmpty) {
      // 12323 => 1232
      nmbr2 = nmbr2.substring(0, nmbr2.length - 1);
    } else if (action.isNotEmpty) {
      action = "";
    } else if (nmbr1.isNotEmpty) {
      nmbr1 = nmbr1.substring(0, nmbr1.length - 1);
    }

    setState(() {});
  }

  // #############
  // appends value to the end
  void appendValue(String value) {
    // nmbr1 opernad nmbr2
    // 234       +      5343

    // if is action and not "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      // action pressed
      if (action.isNotEmpty && nmbr2.isNotEmpty) {
        // TODO calculate the equation before assigning new action
        calculate();
      }
      action = value;
    }
    // assign value to nmbr1 variable
    else if (nmbr1.isEmpty || action.isEmpty) {
      // check if value is "." | ex: nmbr1 = "1.2"
      if (value == Btn.dot && nmbr1.contains(Btn.dot)) return;
      if (value == Btn.dot && (nmbr1.isEmpty || nmbr1 == Btn.n0)) {
        // ex: nmbr1 = "" | "0"
        value = "0.";
      }
      nmbr1 += value;
    }
    // assign value to nmbr2 variable
    else if (nmbr2.isEmpty || action.isNotEmpty) {
      // check if value is "." | ex: nmbr1 = "1.2"
      if (value == Btn.dot && nmbr2.contains(Btn.dot)) return;
      if (value == Btn.dot && (nmbr2.isEmpty || nmbr2 == Btn.n0)) {
        // nmbr1 = "" | "0"
        value = "0.";
      }
      nmbr2 += value;
    }

    setState(() {});
  }
}


Color getBtnColor(value){
  return [Btn.del, Btn.clr].contains(value)?Colors.blueGrey
      : [
    Btn.per,
    Btn.multiply,
    Btn.add,
    Btn.subtract,
    Btn.divide,
    Btn.calculate,
  ].contains(value)?Colors.orange
      : Colors.black87;
}