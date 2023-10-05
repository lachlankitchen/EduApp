import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../degree/degree.dart';
import '../major/major.dart';
import '../navigation/nav_bar.dart';
import '../navigation/nav_utils.dart';

class RadioButtonState extends ChangeNotifier {
  int? selectedRadioValue; // Example radio button state

  // Update the radio button state
  void updateRadio(int? newValue) {
    selectedRadioValue = newValue;
    notifyListeners();
  }
}

/// Represents a screen where users can select their majors.
class MajorListScreen extends StatelessWidget {
  final Degree degree;
  final List<Major> majors;

  /// Constructs a [MajorListScreen].
  ///
  /// [majors]: The list of available majors to display.
  const MajorListScreen({Key? key, required this.degree, required this.majors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Select Your Majors'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: ChangeNotifierProvider<RadioButtonState>(
        create: (_) => RadioButtonState(),
        child: Consumer<RadioButtonState>(
          builder: (context, state, child) {
            return ListView(
              children: [
                const SizedBox(height: 16.0),
                ListTile(
                  title: Text(
                    degree.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: majors.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        children: [
                          Radio<int>(
                            value: index,
                            groupValue: state.selectedRadioValue,
                            onChanged: (newValue) {
                              state.updateRadio(newValue);
                              Major selectedMajor = majors[index];
                              navigateToPapersListScreen(context, degree, selectedMajor);
                            },
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return const Color(0xFFF9C000);
                                }
                                return Colors.grey[600]!;
                              },
                            ),
                          ),
                          Expanded(
                            child: Text(majors[index].name),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
