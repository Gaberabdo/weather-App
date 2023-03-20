// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/bloc/cubit.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/services/weather_service.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {

  String? cityName;

  SearchPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search a City'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 20),
        child: TextField(
          onChanged: (data) {
            cityName = data;
          },
          onSubmitted: (data) async {
            BlocProvider.of<AppCubit>(context).weatherChange(cityName: cityName!);
            BlocProvider.of<AppCubit>(context).cityName =cityName;
            Navigator.pop(context);
          },
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            label: Text('search'),
            suffixIcon: GestureDetector(
                onTap: () async {
                  BlocProvider.of<AppCubit>(context).weatherChange(cityName: cityName!);
                  BlocProvider.of<AppCubit>(context).cityName =cityName;
                  Navigator.pop(context);
                },
                child: Icon(Icons.search)),
            border: OutlineInputBorder(),
            hintText: 'Enter a city',
          ),
        ),
      ),
    );
  }
}




