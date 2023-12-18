
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class piechart extends StatefulWidget {
   piechart({super.key ,required this.dataMap});
   Map<String,double> dataMap;
  @override
  State<piechart> createState() => _piechartState();
}

class _piechartState extends State<piechart> {

  List<Color> SmallPieChartcolorList=[
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.dataMap.isNotEmpty
    ?
    PieChart(
      baseChartColor: Colors.transparent,
      dataMap: widget.dataMap,
      colorList: SmallPieChartcolorList,
      chartRadius: size.width/3,
      chartValuesOptions: const ChartValuesOptions(showChartValueBackground: false,showChartValuesInPercentage: true,),
      legendOptions: const LegendOptions(showLegends: false,legendShape: BoxShape.rectangle,),

    )
    :
        const SizedBox()
    ;
  }
}
