// ignore_for_file: prefer_const_literals_to_create_immutables

// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:weather_app/bloc/cubit.dart';
import 'package:weather_app/bloc/states.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/pages/search_page.dart';

class HomePage extends StatelessWidget {
  WeatherModel? weatherData;

  HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchPage();
              }));
            },
            icon: Icon(Icons.search),
          ),
        ],
        title: Text('Weather App'),
      ),
      body: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          if (state is AppSearchLoadingHomeDataState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AppSearchSuccessHomeDataState) {
            weatherData = cubit.model;
            return BodyContent(weatherData: weatherData);
          } else if (state is AppSearchErrorHomeDataState) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          } else {
            return DefaultBody();
          }
        },
      ),
    );
  }
}

class DefaultBody extends StatelessWidget {
  const DefaultBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'there is no weather  start search',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class BodyContent extends StatelessWidget {
  BodyContent({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  final WeatherModel? weatherData;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //city name
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        BlocProvider.of<AppCubit>(context).cityName!,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        '${weatherData!.current!.tempC}ْ',
                        style: TextStyle(
                            fontSize: 75, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 90,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade300),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            '${weatherData!.current!.condition!.text}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Image.asset(
                      "${weatherData!.current!.condition!.icon}",
                      fit: BoxFit.contain,
                      height: 200,
                      width: double.infinity,
                    ),
                    // Image.network(
                    //   "${weatherData!.current!.condition!.icon}",
                    //   fit: BoxFit.contain,
                    //   height: 200,
                    //   width: double.infinity,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //weather conditions
        SizedBox(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.water_drop_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${weatherData!.current!.humidity} %',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(Icons.watch_later_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${weatherData!.current!.pressureMb} mBar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(Icons.wind_power_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${weatherData!.current!.humidity} km/h',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        //The maximum and minimum value
        SizedBox(
          height: 130,
          child: ClipPath(
            clipper: ProsteThirdOrderBezierCurve(
              position: ClipPosition.bottom,
              list: [
                ThirdOrderBezierCurveSection(
                  smooth: 1,
                  p1: Offset(0, 100),
                  p2: Offset(0, 200),
                  p3: Offset(450, 30),
                  p4: Offset(450, 120),
                ),
              ],
            ),
            child: Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.cloud_sun_bolt_fill,
                          color: HexColor("#e60026"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '07:00 AM',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          CupertinoIcons.moon_zzz,
                          color: HexColor("#191970"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '06:00 PM',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        //Today's calibrator
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            '10 AM',
                            style: TextStyle(fontSize: 16),
                          ),
                          Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjghOiY35DoaDr0LZUN_zB2lJq1qiEb95zqPFDda66RnViLrrPAo-ymBGlmXQRvGYPtZI&usqp=CAU',
                            height: 50,
                            width: 50,
                          ),
                          Text(
                            '19ْ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            '10 AM',
                            style: TextStyle(fontSize: 16),
                          ),
                          Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjghOiY35DoaDr0LZUN_zB2lJq1qiEb95zqPFDda66RnViLrrPAo-ymBGlmXQRvGYPtZI&usqp=CAU',
                            height: 50,
                            width: 50,
                          ),
                          Text(
                            '19ْ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            '10 AM',
                            style: TextStyle(fontSize: 16),
                          ),
                          Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjghOiY35DoaDr0LZUN_zB2lJq1qiEb95zqPFDda66RnViLrrPAo-ymBGlmXQRvGYPtZI&usqp=CAU',
                            height: 50,
                            width: 50,
                          ),
                          Text(
                            '19ْ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            '10 AM',
                            style: TextStyle(fontSize: 16),
                          ),
                          Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjghOiY35DoaDr0LZUN_zB2lJq1qiEb95zqPFDda66RnViLrrPAo-ymBGlmXQRvGYPtZI&usqp=CAU',
                            height: 50,
                            width: 50,
                          ),
                          Text(
                            '19ْ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            '10 AM',
                            style: TextStyle(fontSize: 16),
                          ),
                          Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjghOiY35DoaDr0LZUN_zB2lJq1qiEb95zqPFDda66RnViLrrPAo-ymBGlmXQRvGYPtZI&usqp=CAU',
                            height: 50,
                            width: 50,
                          ),
                          Text(
                            '19ْ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        //week days
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Tuesday',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjghOiY35DoaDr0LZUN_zB2lJq1qiEb95zqPFDda66RnViLrrPAo-ymBGlmXQRvGYPtZI&usqp=CAU',
                      height: 50,
                      width: 50,
                    ),
                    Spacer(),
                    Text(
                      '16',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '15',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Tuesday',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjghOiY35DoaDr0LZUN_zB2lJq1qiEb95zqPFDda66RnViLrrPAo-ymBGlmXQRvGYPtZI&usqp=CAU',
                      height: 50,
                      width: 50,
                    ),
                    Spacer(),
                    Text(
                      '16',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '15',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Tuesday',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjghOiY35DoaDr0LZUN_zB2lJq1qiEb95zqPFDda66RnViLrrPAo-ymBGlmXQRvGYPtZI&usqp=CAU',
                      height: 50,
                      width: 50,
                    ),
                    Spacer(),
                    Text(
                      '16',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '15',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
