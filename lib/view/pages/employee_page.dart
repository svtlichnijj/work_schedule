import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:work_schedule/data/models/employee.dart';
import 'package:work_schedule/data/repository/employee_repository.dart';
import 'package:work_schedule/view/widgets/text_container.dart';

class EmployeePage extends StatefulWidget {
  final int employeeId;

  const EmployeePage({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  Employee? employee;
  // Employee? employee = EmployeesData.getEmployeeById(widget.employeeId);
  EmployeeRepository employeeRepository = EmployeeRepository();
  // EmployeeRepository employeeRepository = EmployeeRepository.instance;

  // @override
  // void initState() {
  //   fillEmployee(widget.employeeId);
  //   super.initState();
  //   // employee = EmployeesData.getEmployeeById(widget.employeeId);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Employees list'),
        ),
        body: FutureBuilder(
            future: _getEmployeeCard(widget.employeeId),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: TextContainer.getTextErrorWithIcon(
                        context,
                        'Can\'t found employee by id: "${widget.employeeId}"',
                        Icons.search_off,
                    )
                    // children: <Widget>[
                    //   Padding(
                    //       padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
                    //       child: Text(
                    //         'Can\'t found employee by id: "${widget.employeeId}"',
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           color: Theme.of(context).errorColor,
                    //           fontSize: 18.0,
                    //         ),
                    //       )
                    //   )
                    // ],
                  ),
                );
              }
            },
        )
    );
  }

  Future<void> fillEmployee(employeeId) async {
    employee = await employeeRepository.employeeWithSpecialty(employeeId);
    // employee = await employeeRepository.employee(employeeId);
    // employee = await employeeRepository.employee(widget.employeeId);

    if (kDebugMode) {
      print('employee');
      print(employee);
    }
  }

  Future<Widget> _getEmployeeCard(int employeeId) async {
  // Widget _getEmployeeCard(Employee? employee) {
    print('employee b');
    print(employee);
    employee = await employeeRepository.employeeWithSpecialty(employeeId);
    // employee = await employeeRepository.employee(employeeId);
    // employee = await employeeRepository.employee(widget.employeeId);
    print('employee a');
    print(employee);

    if (employee == null) {
      return const Text('Employee is null');
    }

    return Center(
        child: Text('#${employee.toString()}')
        // child: Text('#${employee.id} ${employee.name}, ${employee.specialty}')
    );
  }
}
