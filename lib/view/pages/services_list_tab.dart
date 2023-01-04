import 'package:flutter/material.dart';

import 'package:work_schedule/bloc/service_bloc.dart';
import 'package:work_schedule/view/widgets/services_list_widget.dart';


class ServicesListTab extends StatefulWidget {
  const ServicesListTab({Key? key}) : super(key: key);

  @override
  State<ServicesListTab> createState() => _ServicesListTabState();
}

class _ServicesListTabState extends State<ServicesListTab> {
  final ServiceBloc _serviceBloc = ServiceBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ServicesListWidget(_serviceBloc),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          _showServiceSearchSheet(context);
        },
      ),
    );
  }

  void _showServiceSearchSheet(BuildContext context) {
    final serviceSearchNameFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: Container(
              color: Colors.transparent,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)
                    ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: serviceSearchNameFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search for service...',
                                labelText: 'Search *',
                                labelStyle: TextStyle(
                                    color: Colors.indigoAccent,
                                    fontWeight: FontWeight.w500,
                                ),
                              ),
                              validator: (String? value) {
                                return value!.contains('@')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.indigoAccent,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _serviceBloc.getServices(nameLike: serviceSearchNameFormController.value.text);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  dispose() {
    _serviceBloc.dispose();
    super.dispose();
  }
}
