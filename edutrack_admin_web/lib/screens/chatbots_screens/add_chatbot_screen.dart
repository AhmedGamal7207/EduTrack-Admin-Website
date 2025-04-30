import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/chatbots_screens/chatbots_screen.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/services/chatbot_service.dart';
import 'package:edutrack_admin_web/services/cloudinary_service.dart';
import 'package:edutrack_admin_web/services/generative_chatbots.dart';
import 'package:edutrack_admin_web/services/relations/chatbot_subject_service.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/long_text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/photo_upload_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class AddChatbotScreen extends StatefulWidget {
  final String gradeNumber;
  final String subject;
  const AddChatbotScreen({
    super.key,
    required this.gradeNumber,
    required this.subject,
  });

  @override
  State<AddChatbotScreen> createState() => _AddChatbotScreenState();
}

class _AddChatbotScreenState extends State<AddChatbotScreen> {
  final nameController = TextEditingController();
  final pdfListController = TextEditingController();
  Uint8List? imageBytes;
  String? fileName;
  String? imageUrl;
  String? errorMessage;
  bool isSaving = false;
  bool isUploading = false;
  String? chatbotId;

  // Store selected PDF files
  List<Map<String, dynamic>> selectedPdfFiles = [];
  List<String> pdfUrls = [];

  void onPhotoSelected(Uint8List fileBytes, String name) {
    setState(() {
      imageBytes = fileBytes;
      fileName = name;
    });
  }

  void onPhotoRemoved() {
    setState(() {
      imageBytes = null;
      fileName = null;
      imageUrl = null;
    });
  }

  Future<void> pickPdfFiles() async {
    try {
      // Set FileType.any and then filter after selection to avoid initialization issues
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        // Filter out non-PDF files
        final pdfFiles = result.files.where(
          (file) => file.name.toLowerCase().endsWith('.pdf'),
        );

        if (pdfFiles.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select PDF files only")),
          );
          return;
        }

        setState(() {
          // Store files with required information for uploads
          selectedPdfFiles =
              pdfFiles
                  .map((file) => {'name': file.name, 'bytes': file.bytes})
                  .toList();

          // Update the text field with file names
          String fileNames = selectedPdfFiles
              .map((file) => file['name'] as String)
              .join('\n');
          pdfListController.text = fileNames;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${selectedPdfFiles.length} PDF files selected"),
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error picking files: ${e.toString()}";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking files: ${e.toString()}")),
      );
      print("FilePicker error: ${e.toString()}");
    }
  }

  Future<void> uploadPdfFiles() async {
    if (selectedPdfFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select PDF files first")),
      );
      return;
    }

    setState(() {
      isUploading = true;
      errorMessage = null;
    });

    try {
      final cloudinaryService = CloudinaryService();

      // Generate chatbot ID if not already generated
      chatbotId ??= await ChatbotService().generateChatbotId();

      // Clear previous URLs
      pdfUrls = [];

      // Upload each PDF file to Cloudinary
      for (var pdfFile in selectedPdfFiles) {
        final fileName = pdfFile['name'] as String;
        final fileBytes = pdfFile['bytes'] as Uint8List;

        String? pdfUrl = await cloudinaryService.uploadPdf(
          fileBytes,
          "${chatbotId}_${fileName.replaceAll(' ', '_')}",
          folder: "chatbot_pdfs",
        );

        if (pdfUrl != null) {
          pdfUrls.add(pdfUrl);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${pdfUrls.length} PDF files uploaded successfully"),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Error uploading PDFs: ${e.toString()}";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading PDFs: ${e.toString()}")),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> saveChatbot() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a chatbot name")),
      );
      return;
    }

    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    // Generate chatbot ID if not already generated
    chatbotId ??= await ChatbotService().generateChatbotId();

    try {
      final chatbotName = nameController.text;

      if (imageBytes != null && fileName != null) {
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          imageBytes!,
          chatbotId!,
          folder: "chatbots",
        );
      } else {
        final defaultBytes = await rootBundle.load('assets/images/Chatbot.png');
        final defaultData = defaultBytes.buffer.asUint8List();
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          defaultData,
          chatbotId!,
          folder: "chatbots",
        );
      }

      // If PDFs are selected but not uploaded yet, upload them now
      if (selectedPdfFiles.isNotEmpty && pdfUrls.isEmpty) {
        await uploadPdfFiles();
      }

      await ChatbotService().addChatbot(
        chatbotId: chatbotId!,
        chatbotName: chatbotName,
        coverPhoto: imageUrl ?? '',
      );

      String gradeId = widget.gradeNumber;

      final gradeRef = FirebaseFirestore.instance
          .collection('grades')
          .doc(gradeId);

      final chatbotRef = FirebaseFirestore.instance
          .collection('chatbots')
          .doc(chatbotId);

      String subjectId = "${widget.gradeNumber}${widget.subject.toLowerCase()}";
      final subjectRef = FirebaseFirestore.instance
          .collection('subjects')
          .doc(subjectId);

      await ChatbotSubjectService().addRelation(
        documentId: "${chatbotId}_${subjectId}_$gradeId",
        gradeRef: gradeRef,
        chatbotRef: chatbotRef,
        subjectRef: subjectRef,
        pdfs: pdfUrls,
      );

      await GenerativeChatbots().generateChatbot(
        "${chatbotId}_${subjectId}_$gradeId",
        pdfUrls,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Chatbot added successfully.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  HomeScreen(subScreen: ChatbotsScreen(), selectedIndex: 8),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Error: ${e.toString()}";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving chatbot: ${e.toString()}")),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(
              headerTitle:
                  "Add Chatbot - Grade ${widget.gradeNumber} - ${widget.subject}",
            ),
            const SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Chatbot Details", style: Constants.subHeadingStyle),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusablePhotoUpload(
                        headline: "Photo",
                        imagePath: "assets/images/Chatbot.png",
                        onImageSelected: onPhotoSelected,
                        onImageRemoved: onPhotoRemoved,
                        initialImageBytes: imageBytes,
                      ),
                      const SizedBox(width: 40),
                      // Subject Form Fields
                      Expanded(
                        child: Column(
                          children: [
                            ReusableTextField(
                              headline: "Chatbot Name",
                              hintText: "English",
                              controller: nameController,
                            ),
                            const SizedBox(height: 20),
                            ReusableLongTextField(
                              headline: "Resources(PDFs)",
                              hintText:
                                  "Lesson 1: Present Simple.pdf\nLesson 2: Past Simple.pdf\nLesson 3: Past Continuous.pdf\nLesson 4: Future Simple.pdf",
                              controller: pdfListController,
                              readOnly: true,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                CustomButton(
                                  text: "Choose Files",
                                  onTap: pickPdfFiles,
                                  hasIcon: false,
                                ),
                                const SizedBox(width: 20),
                                CustomButton(
                                  text:
                                      isUploading
                                          ? "Uploading..."
                                          : "Upload Files",
                                  onTap: isUploading ? null : uploadPdfFiles,
                                  hasIcon: false,
                                ),
                              ],
                            ),
                            if (errorMessage != null) ...[
                              const SizedBox(height: 20),
                              Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                text: isSaving ? "Saving..." : "Save Chatbot",
                                onTap: isSaving ? null : saveChatbot,
                                hasIcon: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
