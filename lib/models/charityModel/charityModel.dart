import 'package:image_picker/image_picker.dart';

class CharityModel {
  final String title;
  final String description;
  final int donation;
  final XFile? file;
  final String? path;

  CharityModel(
      {required this.title,
      required this.description,
      required this.donation,
      this.file,
      this.path});
}
