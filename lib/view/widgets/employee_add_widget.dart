import 'package:flutter/material.dart';
import 'package:work_schedule/data/models/employee.dart';
import 'package:work_schedule/data/models/model.dart';
import 'package:work_schedule/data/models/specialty.dart';
import 'package:work_schedule/data/repository/employee_repository.dart';
import 'package:work_schedule/data/repository/specialty_repository.dart';
import 'package:work_schedule/view/widgets/action_yes_no_index_alert_dialog.dart';
import 'package:work_schedule/view/widgets/text_container.dart';

class EmployeeAddWidget extends StatefulWidget {
  final Employee? employee;

  const EmployeeAddWidget({ Key? key, required this.employee }) : super(key: key);

  @override
  State<EmployeeAddWidget> createState() => _EmployeeAddWidgetState();
}

class _EmployeeAddWidgetState extends State<EmployeeAddWidget> {
  final _formKey = GlobalKey<FormState>();
  EmployeeRepository employeeRepository = EmployeeRepository();
  SpecialtyRepository specialtyRepository = SpecialtyRepository();
  late List<Specialty> specialties = [];
  // late int dropdownValue = specialties.first.id;
  // // late String dropdownValue = 'specialties.first';
  // ToDo rewrite
  TextEditingController textEditingController = TextEditingController();
  late final bool _isAddingEmployee;
  late final Employee _employeeEntering;
  late Employee _employeeUpserting;
  // late String employeeName;
  // late int employeeSpecialtyId;

  @override
  void initState() {
    super.initState();

    // _isAddingEmployee = widget.employee == null || widget.employee?.id == Employee.newEmployeeId;
    fillSpecialties();
    fillEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getEmployeeAddForm(context, widget.employee),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        // print('snapshot.hasData');
        // print(snapshot.hasData);
        // print('snapshot.data');
        // print(snapshot.data);
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
        // } else {
          return Center(
            child: TextContainer(text: "Can't load \"Add employee Form\"\nError: ${snapshot.error}"),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.blueAccent,)
          );
          //   return snapshot.requireData;
        }
      },
    );
  }

  Future<Widget> _getEmployeeAddForm(BuildContext context, Employee? employee) async {
    // print('specialties');
    // print(specialties);
    // print('specialties.isEmpty');
    // print(specialties.isEmpty);
    if (specialties.isEmpty) {
      await fillSpecialties();
    }

    print('_employeeUpserting.name');
    print(_employeeUpserting.name);
    print('specialties before');
    print(specialties);
    return WillPopScope(
      onWillPop: () async {
        bool? shouldPop = _employeeUpserting.isEqualsEmployees(_employeeEntering);
        // bool? shouldPop = _employeeUpserting == _employeeEntering;
        print('shouldPop b');
        print(shouldPop);
        print('_employees');
        print(_employeeUpserting);
        print(_employeeEntering);

        if (!shouldPop) {
          shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              String dialogContext = 'the continuation of the creation of the Employee';

              if (!_isAddingEmployee) {
                dialogContext = 'continuing to edit ${_employeeUpserting.name} (${_employeeUpserting.specialty.name})';
              }

              return ActionYesNoIndexAlertDialog(
                  content: "Are you sure you want to cancel $dialogContext ?",
                  falseText: 'Back',
                  callback: (isApprove, employeeId) => {}
                // callback: (isApprove, employeeId) => _changedEmployee(isApprove, employee?.id)
              );
              return AlertDialog(
                title: const Text('Do you want to go back?'),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },
          );
        }
        print('shouldPop a');
        print(shouldPop);
        return shouldPop!;
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _employeeUpserting.name,
                        // initialValue: employeeName,
                        // initialValue: employee?.name,
                        // initialValue: employee?.name ?? '',
                        decoration: const InputDecoration(
                          label: Text('Name'),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (String? value) {
                          setState(() {
                            _employeeUpserting.name = value!;
                          });
                        },
                        // onSaved: (String? value) { employeeName = value!; },
                        onSaved: (String? value) {
                          _employeeUpserting.name = value!;
                        },
                        // controller: textEditingController,
                      ),
                      DropdownButtonFormField(
                        value: _employeeUpserting.specialty.id != Model.idForCreating ? _employeeUpserting.specialty.id : null,
                        // value: employee?.specialty?.id,
                        items: specialties.map<DropdownMenuItem<int>>((Specialty specialty) {
                          // print('specialty');
                          // print(specialty);
                          return DropdownMenuItem<int>(
                            value: specialty.id,
                            child: Text(specialty.name),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          label: Text('Specialty'),
                        ),
                        onChanged: (int? value) {
                          // This is called when the user selects an item.
                          // setState(() {
                          //   dropdownValue = value!;
                          // });
                          setState(() {
                            print('_employeeEntering b');
                            print(_employeeEntering);
                            print('_employeeUpserting b');
                            print(_employeeUpserting);
                            _employeeUpserting.setSpecialtyFull(value!);
                            // _employeeUpserting = Employee.setSpecialty(_employeeUpserting, value!);
                            // _employeeUpserting.setSpecialtyId(value!);
                            print('_employeeEntering a');
                            print(_employeeEntering);
                            print('_employeeUpserting a');
                            print(_employeeUpserting);
                          });
                        },
                        onSaved: (int? value) {
                          _employeeUpserting.setSpecialtyId(value!);
                        },
                        // onSaved: (int? value) { employeeSpecialtyId = value!; },
                      ),
                      // DropdownButton(
                      //   items: specialties.map<DropdownMenuItem<String>>((Specialty specialty) {
                      //     return DropdownMenuItem<String>(
                      //       value: specialty.id.toString(),
                      //       child: Text(specialty.name),
                      //     );
                      //   }).toList(),
                      //   onChanged: (String? value) {
                      //     // This is called when the user selects an item.
                      //     setState(() {
                      //       dropdownValue = value!;
                      //     });
                      //   },
                      // ),
                      // Row(
                      //   children: [
                      //     ColoredBox(color: Theme.of(context).colorScheme.background),
                      //     ColoredBox(color: Theme.of(context).colorScheme.secondary),
                      //     ColoredBox(color: Theme.of(context).colorScheme.error),
                      //     ColoredBox(color: Theme.of(context).colorScheme.inversePrimary),
                      //     ColoredBox(color: Theme.of(context).colorScheme.inverseSurface),
                      //     ColoredBox(color: Theme.of(context).colorScheme.surface),
                      //   ],
                      // )
                    ])
            ),
            ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  _formKey.currentState?.save();
                  _showSnackBar(context, 'Processing Data');
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Processing Data')),
                  // );
                  _upsertEmployee(context);
                }
              },
              // style: ButtonStyle(
              //   // textStyle: MaterialStatePropertyAll<TextStyle>(
              //   //     TextStyle(color: Colors.white60),
              //   // ),
              //   backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor),
              // ),
              child: Text(
                _isAddingEmployee ? 'Add employee' : 'Edit employee',
                // style: TextStyle(
                //   color: Colors.white
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fillSpecialties() async {
    // print('specialties b');
    // print(specialties);
    specialties = await specialtyRepository.specialties();
    // print('specialties a');
    // print(specialties);
  }
// void fillSpecialties() {
//   specialties = specialtyRepository.getSpecialties();
// }

  Future<void> fillEmployees() async {
    // print('widget.employee b');
    // print(widget.employee);
    // print('widget.employee?.id');
    // print(widget.employee?.id);
    // print('!(widget.employee?.id != null && widget.employee!.id > Model.idForCreating)');
    // print(!(widget.employee?.id != null && widget.employee!.id > Model.idForCreating));
    // // print(!(widget.employee?.id != null && widget.employee!.id > Employee.newEmployeeId));
    // print('!(widget.employee != null && widget.employee!.id > Model.idForCreating)');
    // print(!(widget.employee != null && widget.employee!.id > Model.idForCreating));
    // // print(!(widget.employee != null && widget.employee!.id > Employee.newEmployeeId));
    if (widget.employee != null) {
      print('widget.employee!.id');
      print(widget.employee!.id);
    }
    // _isAddingEmployee = widget.employee?.id != Employee.newEmployeeId;
    _isAddingEmployee = !(widget.employee?.id != null && widget.employee!.id > Model.idForCreating);
    // _isAddingEmployee = !(widget.employee?.id != null && widget.employee!.id > Employee.newEmployeeId);
    print('widget.employee a');
    print(widget.employee);
    print('_isAddingEmployee');
    print(_isAddingEmployee);

    if (_isAddingEmployee) {
      // _employeeEntering = Employee(name: '', specialty: null);
      _employeeEntering = Employee.empty();
      // _employeeEntering = Employee(name: '', specialty: Specialty(name: ''));
      // _employeeUpserting = Employee.copy(_employeeEntering);
      _employeeUpserting = Employee.empty();
      // _employeeUpserting = _employeeEntering;
    } else {
      _employeeEntering = Employee.fromMapWithSpecialty(widget.employee!.toMapWithSpecialty());
      // _employeeEntering = widget.employee!;
      _employeeUpserting = Employee.fromMapWithSpecialty(widget.employee!.toMapWithSpecialty());
      // _employeeUpserting = widget.employee!;
    }
    print('_employeeEntering');
    print(_employeeEntering);
    print('_employeeUpserting');
    print(_employeeUpserting);
  }

  void _showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _upsertEmployee(BuildContext context) async {
    int employeeIdOrUpdateCount = -5;
    // int employeeId = -5;
    // int employeeId = Model.idForCreating;
    // int employeeId = Employee.newEmployeeId;
    String successSnackMessage = '';
    print('_isAddingEmployee');
    print(_isAddingEmployee);
    print('_employeeUpserting');
    print(_employeeUpserting);

    // if (widget.employee?.id != Employee.newEmployeeId) {
    // if (widget.employee != null && widget.employee.id > Employee.newEmployeeId) {
    if (_isAddingEmployee) {
      // int employeeId = await employeeRepository.insertEmployee(
      //     Employee(id: Employee.newEmployeeId, name: employeeName, specialtyId: employeeSpecialtyId)
      // );
      employeeIdOrUpdateCount = await employeeRepository.insertEmployee(_employeeUpserting);
      // employeeId = await employeeRepository.insertEmployee(_employeeUpserting);
      successSnackMessage = 'Created Employee #$employeeIdOrUpdateCount';
      // successSnackMessage = 'Created Employee #$employeeId';
    } else {
      employeeIdOrUpdateCount = await employeeRepository.updateEmployee(_employeeUpserting);
      // employeeId = await employeeRepository.updateEmployee(_employeeUpserting);
      successSnackMessage = 'Edited Employee #${_employeeUpserting.id}';
    }

    if (mounted) {
      print('_employeeEntering');
      print(_employeeEntering);
      print('_employeeUpserting != _employeeEntering');
      print(_employeeUpserting != _employeeEntering);
      // Navigator.of(context).pop(_employeeUpserting != _employeeEntering);
      Navigator.pop(context, _employeeUpserting != _employeeEntering);
      print('employeeIdOrUpdateCount');
      print(employeeIdOrUpdateCount);
      print('employeeIdOrUpdateCount > Model.idForCreating');
      print(employeeIdOrUpdateCount > Model.idForCreating);

      if (employeeIdOrUpdateCount > Model.idForCreating) {
      // if (employeeId > Model.idForCreating) {
      // if (employeeId > Employee.newEmployeeId) {
        _showSnackBar(context, successSnackMessage);
      } else {
        _showSnackBar(context, 'Error: $employeeIdOrUpdateCount');
        // _showSnackBar(context, 'Error: $employeeId');
      }
    }
  }

  void _changedEmployee(isApprove, employeeId) {
    print('isApprove');
    print(isApprove);
    print('employeeId');
    print(employeeId);

  }
}
