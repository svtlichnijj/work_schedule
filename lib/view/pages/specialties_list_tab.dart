import 'package:flutter/material.dart';
import 'package:work_schedule/data/models/specialty.dart';
import 'package:work_schedule/data/repository/specialty_repository.dart';
import 'package:work_schedule/view/widgets/action_yes_no_index_alert_dialog.dart';
import 'package:work_schedule/view/widgets/dismissible_background_builder.dart';
import 'package:work_schedule/view/widgets/edit_text_alert_dialog.dart';

class SpecialtiesListTab extends StatefulWidget {
  const SpecialtiesListTab({Key? key}) : super(key: key);

  @override
  State<SpecialtiesListTab> createState() => _SpecialtiesListTabState();
}

class _SpecialtiesListTabState extends State<SpecialtiesListTab> {
  SpecialtyRepository specialtyRepository = SpecialtyRepository();

  List<Specialty> specialties = [];
  double detailsProgress = 0.0;

  @override
  void initState() {
    super.initState();

    _refillSpecialtiesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: specialties.isEmpty
          ? const Center(child: CircularProgressIndicator(),)
          : RefreshIndicator(
        onRefresh: _refillSpecialtiesList,
        strokeWidth: 3.0,
        child: ListView.builder(
            itemCount: specialties.length,
            itemBuilder: (BuildContext context, int index) {
              Specialty specialty = specialties[index];
              return Dismissible(
                key: ValueKey<Specialty>(specialty),
                onUpdate: (DismissUpdateDetails details) {
                  setState(() {
                    detailsProgress = details.progress;
                  });
                },
                background: DismissibleBackgroundBuilder(
                  detailsProgress: detailsProgress,
                  children: const <Widget>[
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                secondaryBackground: DismissibleBackgroundBuilder(
                  detailsProgress: detailsProgress,
                  direction: DismissDirection.endToStart,
                  children: const <Widget>[
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ActionYesNoIndexAlertDialog(
                            content: 'Are you sure you want to delete specialty ${specialty.name}?',
                            trueText: 'Delete',
                            callback: (isApprove) => _removeEmployee(isApprove, index)
                        );
                      }
                  );
                },
                child: InkWell(
                  onTap: () {
                    print("$specialty clicked");
                  },
                  child: Card(
                    child: ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(
                        specialty.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(
                        Icons.drive_file_rename_outline,
                      ),
                      onTap: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return EditTextAlertDialog(
                                  title: 'Rename specialty',
                                  label: 'Specialty',
                                  textIn: specialty.name,
                                  submitText: 'Edit',
                                  callback: (text, specialtyIndex) => _renameSpecialty(text, index)
                              );
                            }
                        );
                      },),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<void> _refillSpecialtiesList() async {
    specialties = [];
    await Future.delayed(const Duration(seconds: 5));
    specialties = await specialtyRepository.specialties();
    setState(() {});
  }

  void _removeEmployee(bool isApprove, int specialtyIndex) {
    if (isApprove) {
      specialtyRepository.softDeleteSpecialty(specialties[specialtyIndex].id);
      setState(() {
        specialties.removeAt(specialtyIndex);
      });
    }
  }

  void _renameSpecialty(String specialtyName, int specialtyIndex) {
    Specialty specialty = specialties[specialtyIndex];

    if (specialtyName != specialty.name) {
      specialty.name = specialtyName;
      specialtyRepository.upsertSpecialty(specialty);
      setState(() {});
    }
  }
}
