import 'dart:async';

import 'package:flutter/material.dart';
import 'package:work_schedule/data/models/employee.dart';
import 'package:work_schedule/data/repository/employee_repository.dart';
import 'package:work_schedule/view/pages/employee_add_page.dart';
import 'package:work_schedule/view/pages/employee_page.dart';
import 'package:work_schedule/view/widgets/action_yes_no_index_alert_dialog.dart';
import 'package:work_schedule/view/widgets/slide_left_background.dart';
import 'package:work_schedule/view/widgets/slide_right_background.dart';

class EmployeesListPage extends StatefulWidget {
  const EmployeesListPage({Key? key}) : super(key: key);

  @override
  State<EmployeesListPage> createState() => _EmployeesListPageState();
}

class _EmployeesListPageState extends State<EmployeesListPage> {
  EmployeeRepository employeeRepository = EmployeeRepository();

  List<Employee> employees = [];

  FutureOr<void> isReload(dynamic isReload) {
    if (isReload != null && isReload) {
      _refillEmployeesList();
    }
  }

  @override
  void initState() {
    super.initState();

    _refillEmployeesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees list'),
      ),
      body: employees.isEmpty
          ? const Center(child: CircularProgressIndicator(backgroundColor: Colors.yellow,),)
          : RefreshIndicator(
        onRefresh: _refillEmployeesList,
        strokeWidth: 3.0,
        color: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: ListView.builder(
          itemCount: employees.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: ValueKey<Employee>(employees[index]),
              background: const SlideRightBackground(),
              secondaryBackground: const SlideLeftBackground(),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ActionYesNoIndexAlertDialog(
                            content: "Are you sure you want to delete ${employees[index].name} (${employees[index]
                                .specialty.name})?",
                            trueText: 'Delete',
                            callback: (isApprove, employeeIndex) => _removeEmployee(isApprove, index)
                        );
                      });
                } else {
                  await Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => EmployeeAddPage(employee: employees[index])
                    ),
                  ).then(isReload);
                }

                return null;
              },
              child: InkWell(
                onTap: () {
                  print("${employees[index]} clicked");
                },
                child: Card(
                  child: ListTile(
                    leading: Text(employees[index].id.toString()),
                    title: Text(
                      employees[index].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(employees[index].specialty.name),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => EmployeePage(employeeId: employees[index].id)
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => const EmployeeAddPage(employee: null,)
              )
          ).then(isReload);
        },
      ),
    );
  }

  Future<void> _refillEmployeesList() async {
    employees = [];
    await Future.delayed(const Duration(seconds: 5));
    employees = await employeeRepository.fetchEmployeesWithSpecialties();
    setState(() {});
  }

  void _removeEmployee(bool isApprove, int employeeIndex) {
    if (isApprove) {
      employeeRepository.softDeleteEmployee(employees[employeeIndex].id);
      setState(() {
        employees.removeAt(employeeIndex);
      });
    }
  }
}
