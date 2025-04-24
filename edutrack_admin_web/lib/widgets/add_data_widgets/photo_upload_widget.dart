import 'dart:html' as html;
import 'dart:typed_data';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/remove_button_widget.dart';
import 'package:flutter/material.dart';

class ReusablePhotoUpload extends StatefulWidget {
  final String headline;
  final String imagePath;
  final Function(Uint8List fileBytes, String fileName) onImageSelected;
  final VoidCallback onImageRemoved;
  final Uint8List? initialImageBytes;

  const ReusablePhotoUpload({
    super.key,
    required this.headline,
    required this.imagePath,
    required this.onImageSelected,
    required this.onImageRemoved,
    this.initialImageBytes,
  });

  @override
  State<ReusablePhotoUpload> createState() => _ReusablePhotoUploadState();
}

class _ReusablePhotoUploadState extends State<ReusablePhotoUpload> {
  Uint8List? _selectedImageBytes;
  String? _selectedFileName;
  bool _isImageFromAsset = true;

  @override
  void initState() {
    super.initState();
    _selectedImageBytes = widget.initialImageBytes;
    _isImageFromAsset = widget.initialImageBytes == null;
  }

  void _pickImage() {
    final html.FileUploadInputElement input =
        html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        _selectedFileName = file.name;

        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoad.listen((event) {
          setState(() {
            _selectedImageBytes = Uint8List.fromList(
              reader.result as List<int>,
            );
            _isImageFromAsset = false;
          });

          // Call the callback with the selected image bytes and file name
          widget.onImageSelected(_selectedImageBytes!, _selectedFileName!);
        });
      }
    });
  }

  void _removeImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedFileName = null;
      _isImageFromAsset = true;
    });
    widget.onImageRemoved();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.headline, style: Constants.subHeadingStyle),
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: Constants.redColor)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Constants.greyColor,
            border: Border.all(color: Constants.fieldGreyBorder, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child:
                _isImageFromAsset
                    ? Image.asset(widget.imagePath, fit: BoxFit.cover)
                    : _selectedImageBytes != null
                    ? Image.memory(_selectedImageBytes!, fit: BoxFit.cover)
                    : Image.asset(widget.imagePath, fit: BoxFit.cover),
          ),
        ),
        if (_selectedFileName != null) ...[
          const SizedBox(height: 8),
          Text(
            _selectedFileName!,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 10),
        Row(
          children: [
            CustomButton(
              text: "Choose File",
              onTap: _pickImage,
              hasIcon: false,
            ),
            const SizedBox(width: 10),
            RemoveButton(text: "Remove", onTap: _removeImage),
          ],
        ),
      ],
    );
  }
}
