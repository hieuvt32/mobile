import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class DateTimePicker extends StatefulWidget {
  Function(String) changeSelection;
  DateTimePicker(this.changeSelection);
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  // late double _height;
  // late double _width;

  late String _setTime, _setDate;

  late String _hour, _minute, _time;

  late String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);

        widget.changeSelection(_dateController.text);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();

        widget.changeSelection(_timeController.text);
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _height = MediaQuery.of(context).size.height;
    // _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Container(
      // width: _width,
      // height: _height,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                _selectTime(context);
              },
              child: Container(
                height: 32,
                // margin: EdgeInsets.only(top: 30),
                // width: _width / 1.7,
                // height: _height / 9,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                alignment: Alignment.center,
                // decoration: BoxDecoration(color: Colors.grey[200]),
                child: TextFormField(
                  style: TextStyle(fontSize: 12, height: 2.0),
                  textAlign: TextAlign.center,
                  onSaved: (val) {
                    _setTime = "$val";
                  },
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: _timeController,
                  decoration: InputDecoration(
                    disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    // labelText: 'Time',
                    // contentPadding: EdgeInsets.all(5),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Ngày',
              // style: TextStyle(
              //     fontStyle: FontStyle.italic,
              //     fontWeight: FontWeight.w600,
              //     letterSpacing: 0.5),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                // width: _width / 1.7,
                height: 32,
                // margin: EdgeInsets.only(top: 30),
                // alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: TextFormField(
                  style: TextStyle(fontSize: 12, height: 2.0),
                  textAlign: TextAlign.center,
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: _dateController,
                  onSaved: (val) {
                    _setDate = "$val";
                  },
                  decoration: InputDecoration(
                    disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(''),
            flex: 3,
          )
        ],
      ),
    );
  }
}
