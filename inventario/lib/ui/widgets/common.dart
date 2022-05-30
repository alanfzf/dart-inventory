import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchWidget extends StatelessWidget{

  final String hint;
  final ValueChanged<String> onChanged;

  const SearchWidget(this.hint, this.onChanged, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.black54);
    return  Container(
        height: 45,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: style.color),
              hintText: hint,
              hintStyle: style,
              border: InputBorder.none,
            ),
            style: style,
            onChanged: onChanged
        ),
      );
  }
}

class LoadingScreen extends StatelessWidget{

  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(color: Colors.blue)
                  ),
                ],
            ),
          );
  }

}


class InputDropdown extends StatelessWidget{

  final List<DropdownMenuItem<dynamic>> items;
  final dynamic selected;
  final ValueChanged<dynamic> onChange;
  final bool enabled;

  const InputDropdown(this.selected,this.enabled, this.onChange,
      this.items, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 350,
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey)
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                value: selected,
                isExpanded: true,
                enableFeedback: true,
                items: items,
                onChanged: enabled ? onChange : null,
            )),
        ));
  }
}


class CustomButton extends StatelessWidget{

  final String text;
  final Color color;
  final double width, height;
  final VoidCallback action;

  const CustomButton(
        this.text, this.color, this.width,
        this.height, this.action, {Key? key}
      ) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          child: Text(text, style: const TextStyle(fontSize: 14)),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(color),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: color)
                  )
              )
          ),
          onPressed: action
      ),
    );
  }
}


class InputData extends StatelessWidget{

  final TextEditingController? controller;
  final String hint;
  final bool enabled;

  const InputData(this.hint, this.controller,
        this.enabled, {Key? key}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 350,
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey)
        ),
        child:  Center(
          child: TextFormField(
            enabled: enabled,
            controller: controller,
            decoration: InputDecoration(
                labelText: hint,
                border: InputBorder.none,
                filled: false,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                fillColor: Colors.white
            ),
          ),
        )
    );
  }
}





class InputNumeric extends StatelessWidget{

  final TextEditingController controller;
  final String hint;
  final bool integers;


  const InputNumeric(this.hint, this.controller,
        this.integers, {Key? key}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 350,
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
        ),

        child:  TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [integers ?
              FilteringTextInputFormatter.digitsOnly :
              FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.)?(\d+)?$'))
          ],

          decoration: InputDecoration(
              border: InputBorder.none,
              filled: false,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              labelText: hint,
              fillColor: Colors.white
          ),
        )
    );
  }
}


class LineInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool pass;

  const LineInput(this.hint, this.controller, this.pass, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 70,
        width: 350,
        child: TextField(
            obscureText: pass,
            controller: controller,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey.shade400),
              hintText: hint,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300)),
            )
        ));
  }
}


class CustomTable extends StatelessWidget{

  final List<String> columns;
  final List<DataRow> rows;
  final double spacing;

  const CustomTable(this.columns, this.spacing, this.rows, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      border: TableBorder.all(style: BorderStyle.solid, color: Colors.transparent),
      headingRowColor: MaterialStateProperty.resolveWith((s) => 
      const Color.fromARGB(255, 245, 245, 245)),
      columnSpacing: spacing,
      columns: columns.map((e) {
        return DataColumn(
          label: Text(e, style: const TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.bold,
          ))
        );
      }).toList(), 
      rows: rows
    );
  }
}


DataRow createRow(List<String> cellList){
    return DataRow(color: MaterialStateColor.resolveWith(
      (s) => const Color.fromARGB(255, 240, 240, 240))
      ,cells: cellList.map((e){
        return DataCell(Center(child: Text(e)));
    }).toList()
  );
}

Text createTitle(String text){
   return Text(text, 
      style: const TextStyle(
      color: Colors.blueAccent,
      fontSize: 20, fontWeight: FontWeight.bold, 
      // fontStyle: FontStyle.italic,
     ));
}