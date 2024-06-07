
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:watch_list/models/color_theme_data.dart';
//
// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text('Choose Theme'),
//       ),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: const SwitchCard(),
//     );
//   }
// }
//
// class SwitchCard extends StatefulWidget {
//   const SwitchCard({super.key});
//
//   @override
//   State<SwitchCard> createState() => _SwitchCardState();
// }
//
// class _SwitchCardState extends State<SwitchCard> {
//   final Text greenText = const Text('DarkGrey', style: TextStyle(color: Color(0xff121212)));
//   final Text redText = const Text('DeepBlue', style: TextStyle(color: Color(0xff00BFFF)));
//
//   @override
//   Widget build(BuildContext context) {
//     bool _value = Provider.of<ColorThemeData>(context).isGreen;
//     return Card(
//       color: Colors.white,
//       child: SwitchListTile(
//         subtitle: _value ? greenText : redText,
//         title: const Text('Change Theme Color', style: TextStyle(color: Colors.black)),
//         value: _value,
//         onChanged: (value) {
//           setState(() {
//             _value = value;
//           });
//           Provider.of<ColorThemeData>(context, listen: false).switchTheme(value);
//         },
//       ),
//     );
//   }
// }
