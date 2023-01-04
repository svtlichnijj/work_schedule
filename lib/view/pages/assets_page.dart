import 'package:flutter/material.dart';

import 'package:work_schedule/view/pages/employees_list_tab.dart';
import 'package:work_schedule/view/pages/services_list_tab.dart';
import 'package:work_schedule/view/pages/specialties_list_tab.dart';

class AssetsPage extends StatelessWidget {
  const AssetsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: const SafeArea(
            child: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: 'Employees',
                  ),
                  Tab(
                    text: 'Specialties',
                  ),
                  Tab(
                    text: 'Services',
                  ),
                ]
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            EmployeesListTab(),
            SpecialtiesListTab(),
            ServicesListTab(),
          ],
        ),
      ),
    );
  }
}
