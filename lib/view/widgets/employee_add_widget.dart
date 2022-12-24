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
  late List<Specialty> specialties = [];
  late final bool _isAddingEmployee;
  late final Employee _employeeEntering;
  late Employee _employeeUpserting;

  @override
  void initState() {
    super.initState();

    fillSpecialties();
    fillEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getEmployeeAddForm(context, widget.employee),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          return Center(
            child: TextContainer(text: "Can't load \"Add employee Form\"\nError: ${snapshot.error}"),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.blueAccent,)
          );
        }
      },
    );
  }

  Future<Widget> _getEmployeeAddForm(BuildContext context, Employee? employee) async {
    if (specialties.isEmpty) {
      await fillSpecialties();
    }

    return WillPopScope(
      onWillPop: () async {
        bool? shouldPop = _employeeUpserting.isEqualsEmployees(_employeeEntering);

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
              );
            },
          );
        }

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
                        decoration: const InputDecoration(
                          label: Text('Name'),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Name';
                          }
                          return null;
                        },
                        onChanged: (String? value) {
                          setState(() {
                            _employeeUpserting.name = value!;
                          });
                        },
                        onSaved: (String? value) {
                          _employeeUpserting.name = value!;
                        },
                      ),
                      DropdownButtonFormField(
                        value: _employeeUpserting.specialty.id != Model.idForCreating ? _employeeUpserting.specialty.id : null,
                        items: specialties.map<DropdownMenuItem<int>>((Specialty specialty) {
                          return DropdownMenuItem<int>(
                            value: specialty.id,
                            child: Text(specialty.name),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          label: Text('Specialty'),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please choice Specialty';
                          }

                          return null;
                        },
                        onChanged: (int? value) {
                          setState(() {
                            _employeeUpserting.setSpecialtyId(value!);
                          });
                        },
                        onSaved: (int? value) {
                          _employeeUpserting.setSpecialtyFull(value!);
                        },
                      ),
                    ])
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  _showSnackBar(context, 'Processing Data');
                  _upsertEmployee(context);
                }
              },
              child: Text(
                _isAddingEmployee ? 'Add employee' : 'Edit employee',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fillSpecialties() async {
    SpecialtyRepository specialtyRepository = SpecialtyRepository();
    specialties = await specialtyRepository.specialties();
  }

  Future<void> fillEmployees() async {
    _isAddingEmployee = !(widget.employee?.id != null && widget.employee!.id > Model.idForCreating);

    if (_isAddingEmployee) {
      _employeeEntering = Employee.empty();
      _employeeUpserting = Employee.empty();
    } else {
      _employeeEntering = Employee.fromMapWithSpecialty(widget.employee!.toMapWithSpecialty());
      _employeeUpserting = Employee.fromMapWithSpecialty(widget.employee!.toMapWithSpecialty());
    }
  }

  void _showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _upsertEmployee(BuildContext context) async {
    int employeeIdOrUpdateCount;
    EmployeeRepository employeeRepository = EmployeeRepository();
    String successSnackMessage = '';

    if (_isAddingEmployee) {
      employeeIdOrUpdateCount = await employeeRepository.insertEmployee(_employeeUpserting);
      successSnackMessage = 'Created Employee #$employeeIdOrUpdateCount';
    } else {
      employeeIdOrUpdateCount = await employeeRepository.updateEmployee(_employeeUpserting);
      successSnackMessage = 'Edited Employee #${_employeeUpserting.id}';
    }

    if (mounted) {
      Navigator.pop(context, _employeeUpserting != _employeeEntering);

      if (employeeIdOrUpdateCount > Model.idForCreating) {
        _showSnackBar(context, successSnackMessage);
      } else {
        _showSnackBar(context, 'Error: $employeeIdOrUpdateCount');
      }
    }
  }
}
