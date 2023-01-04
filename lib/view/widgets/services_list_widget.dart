// import 'dart:mirrors';
import 'package:flutter/material.dart';
// import 'package:reflectable/mirrors.dart';
// import 'package:reflectable/reflectable_builder.dart';

import 'package:work_schedule/bloc/service_bloc.dart';
import 'package:work_schedule/data/models/service.dart';
import 'package:work_schedule/enums/crud_menu_items.dart';
import 'package:work_schedule/view/widgets/action_yes_no_index_alert_dialog.dart';

class ServicesListWidget extends StatefulWidget {
  final ServiceBloc _serviceBloc;

  const ServicesListWidget(this._serviceBloc, {Key? key}) : super(key: key);

  @override
  State<ServicesListWidget> createState() => _ServicesListWidgetState();
}

class _ServicesListWidgetState extends State<ServicesListWidget> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget._serviceBloc.services,
        builder: (BuildContext context, AsyncSnapshot<List<Service>> snapshot) {
          return _getServiceCardWidget(snapshot);
        }
    );
  }

  Widget _getServiceCardWidget(AsyncSnapshot<List<Service>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.isEmpty ?
      Center(
        child: noServiceMessageWidget(),
      ) :
      ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, itemPosition) {
            Service service = snapshot.data![itemPosition];
            return Card(
              child: ListTile(
                title: Text(
                  service.name,
                ),
                trailing: PopupMenuButton<CrudMenuItems>(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<CrudMenuItems>>[
                      PopupMenuItem(
                        value: CrudMenuItems.edit,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                          value: CrudMenuItems.delete,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              Text('Delete'),
                            ],
                          )
                      ),
                    ];
                  },
                  onSelected: (CrudMenuItems value) => actionPopUpItemSelected(context, value, service),
                ),
              ),
            );
          }
      );
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Future<void> actionPopUpItemSelected(BuildContext contextIn, CrudMenuItems crudMenuItem, Service service) async {
    String message = '';

    if (crudMenuItem == CrudMenuItems.edit) {
      message = 'You selected edit for $service';
    } else if (crudMenuItem == CrudMenuItems.delete) {
      dynamic isDeleted = await showDialog(
      // bool isDeleted = await showDialog(
        context: contextIn,
        builder: (BuildContext context) {
          return ActionYesNoIndexAlertDialog(
            title: 'Are you sure you want to delete service ${service.toString()} ?',
            trueText: 'Delete',
            callback: (bool isApprove) async {
              if (isApprove) {
                await widget._serviceBloc.runMethod(crudMenuItem, [service.id]);
              }
            },
          );
        },
      );

      print('isDeleted');
      print(isDeleted);
      print('isDeleted.runtimeType');
      print(isDeleted.runtimeType);
      if (isDeleted) {
        message = 'You deleted service ${service.toString()}';
      }
    } else {
      message = 'Not implemented';
    }

    if (!mounted || message == '') return;

    ScaffoldMessenger.of(contextIn)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget noServiceMessageWidget() {
    return const Text(
      'Start adding Service...',
      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
    );
  }

  Widget loadingData() {
    widget._serviceBloc.getServices();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          Text(
              'Loading...',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }
}
