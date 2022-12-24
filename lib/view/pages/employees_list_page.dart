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

  // EmployeeRepository employeeRepository = EmployeeRepository.instance;
  List<Employee> employees = [];
  // Future<List<Employee>> employees = EmployeeRepository.employees();
  // List<Employee> employees = EmployeesData.getEmployees();

  // FutureOr<int?> isReload(dynamic isReload) {
  FutureOr<void> isReload(dynamic isReload) {
    print('isReload');
    print(isReload);
    if (isReload != null && isReload) {
      _refillEmployeesList();
    }

    // // [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception:
    // // type 'bool' is not a subtype of type 'FutureOr<int?>'
    // return isReload;
  }
  // FutureOr<int?> isAddedEmployeeId(dynamic addedEmployeeId) {
  //   print('addedEmployeeId');
  //   print(addedEmployeeId);
  //   if (addedEmployeeId != null && addedEmployeeId != Employee.newEmployeeId) {
  //     refillEmployeesList();
  //   }
  //
  //   return addedEmployeeId;
  // }
  //
  // int? addedEmployeeId;

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
                  // final res = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ActionYesNoIndexAlertDialog(
                          content: "Are you sure you want to delete ${employees[index].name} (${employees[index].specialty.name})?",
                            trueText: 'Delete',
                            callback: (isApprove, employeeIndex) => _removeEmployee(isApprove, index)
                        );
                        /*
                        return AlertDialog(
                          content: Text(
                              "Are you sure you want to delete ${employees[index].name} (${employees[index].specialty?.name})?"),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                employeeRepository.deleteEmployee(employees[index].id);
                                setState(() {
                                  employees.removeAt(index);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                         */
                      });
                  // print('res');
                  // print(res);
                  // return res;
                } else {
                  // addedEmployeeId = await Navigator.push(context,
                  await Navigator.push(context,
                  // Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => EmployeeAddPage(employee: employees[index])
                        // builder: (context) => EmployeePage(employeeId: employees[index].id)
                      // builder: (BuildContext context) => EmployeePage(employeeId: employees[index].id)
                    ),
                  ).then(isReload);
                  print('addedEmployeeId onEdit');
                  // print(addedEmployeeId);
                }
              },
              child: InkWell(
                // ToDo for test only
                onTap: () {
                  print("${employees[index]} clicked");
                },
                child: Card(
                  child: ListTile(
                    leading: Text(employees[index].id.toString()),
                    title: /*Center(
                      child:*/ Text(
                      employees[index].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // ),
                    subtitle: Text(employees[index].specialty.name),
                    onTap: () {
                      // Navigator.of(context).push(
                      Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => EmployeePage(employeeId: employees[index].id)
                          // builder: (BuildContext context) => EmployeePage(employeeId: employees[index].id)
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
      // Row(
      //   children: [
      //     Column(
      //         children: [
      //           ColoredBox(
      //             color: Theme.of(context).colorScheme.background,
      //             child: const Text('background'),
      //           ),
      //           ColoredBox(
      //             color: Theme.of(context).colorScheme.secondary,
      //             child: const Text('secondary'),
      //           ),
      //           ColoredBox(
      //             color: Theme.of(context).colorScheme.error,
      //             child: const Text('error'),
      //           ),
      //           ColoredBox(
      //             color: Theme.of(context).colorScheme.inversePrimary,
      //             child: const Text('inversePrimary'),
      //           ),
      //           ColoredBox(
      //             color: Theme.of(context).colorScheme.surface,
      //             child: const Text('surface'),
      //           ),
      //           ColoredBox(
      //             color: Theme.of(context).colorScheme.inverseSurface,
      //             child: const Text('inverseSurface'),
      //           ),
      //         ]
      //     ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context,
          // addedEmployeeId = await Navigator.push(context,
          // addedEmployeeId = await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const EmployeeAddPage(employee: null,)
                // builder: (BuildContext context) => const EmployeeAddPage()
              )
          ).then(isReload);
          // ).then(isAddedEmployeeId);
          // );
          print('addedEmployeeId onTap');
          // print(addedEmployeeId);
        },
      ),
    );
  }

  Future<void> _refillEmployeesList() async {
    // print('addedEmployeeId b');
    // print(addedEmployeeId);
    // ToDo Is Need empty employees? If true ?  refillEmployeesList() : fillEmployeesList()
    employees = [];
    // print('employees b');
    // print(employees);
    await Future.delayed(const Duration(seconds: 5));
    employees = await employeeRepository.fetchEmployeesWithSpecialties();
    print('employees a');
    print(employees);
    setState(() {
      // employees = await employeeRepository.employees();
      // print('employees aa');
      // print(employees);
      // print('addedEmployeeId a');
      // print(addedEmployeeId);
    });
  }

  void _removeEmployee(bool isApprove, int employeeIndex) {
    print('isApprove');
    print(isApprove);
    print('employeeIndex');
    print(employeeIndex);
    if (isApprove) {
      employeeRepository.softDeleteEmployee(employees[employeeIndex].id);
      // employeeRepository.deleteEmployee(employees[employeeIndex].id);
      setState(() {
        employees.removeAt(employeeIndex);
      });
    }
  }
}
