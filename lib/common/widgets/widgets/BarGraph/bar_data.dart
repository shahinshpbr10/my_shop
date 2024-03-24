
import 'package:my_shop/common/widgets/widgets/BarGraph/individual_bar.dart';

class BarData {
  final double sunAmmount;
  final double monAmmount;
  final double tueAmmount;
  final double wedAmmount;
  final double thursAmmount;
  final double friAmmount;
  final double satAmmount;

  BarData({
    required this.sunAmmount,
    required this.monAmmount,
    required this.tueAmmount,
    required this.wedAmmount,
    required this.thursAmmount,
    required this.friAmmount,
    required this.satAmmount,
  });
  List<IndividualBar> barData = [];
  //initalize bar data
  void initalizeBarData() {
    barData = [
      IndividualBar(x: 0, y: sunAmmount),
      IndividualBar(x: 1, y: monAmmount),
      IndividualBar(x: 2, y: tueAmmount),
      IndividualBar(x: 3, y: wedAmmount),
      IndividualBar(x: 4, y: thursAmmount),
      IndividualBar(x: 5, y: friAmmount),
      IndividualBar(x: 6, y: satAmmount),
    ];
  }
}
