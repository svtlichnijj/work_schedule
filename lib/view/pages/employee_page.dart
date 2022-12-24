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
                  ),
                ),
              );
            }
          },
        )
    );
  }

  Future<Widget> _getEmployeeCard(int employeeId) async {
    EmployeeRepository employeeRepository = EmployeeRepository();
    employee = await employeeRepository.employeeWithSpecialty(employeeId);

    if (employee == null) {
      return const Text('Employee is null');
    }

    return Center(
        child: Text('#$employee')
    );
  }
}
