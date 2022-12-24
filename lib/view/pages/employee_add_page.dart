import 'package:flutter/material.dart';
import 'package:work_schedule/data/models/employee.dart';
import 'package:work_schedule/data/models/model.dart';
import 'package:work_schedule/view/widgets/employee_add_widget.dart';

class EmployeeAddPage extends StatefulWidget {
  final Employee? employee;

  const EmployeeAddPage({Key? key, required this.employee}) : super(key: key);

  @override
  State<EmployeeAddPage> createState() => _EmployeeAddPageState();
}

class _EmployeeAddPageState extends State<EmployeeAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(!(widget.employee?.id != null && widget.employee!.id > Model.idForCreating) ?
          'Add employee Form' :
          'Edit employee form of ${widget.employee?.name}'
          ),
        ),
        body: EmployeeAddWidget(employee: widget.employee,),
    );
  }
}
