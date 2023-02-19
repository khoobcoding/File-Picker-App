dependencies:
  file_picker: ^5.2.5
  open_app_file: ^4.0.1 // ADD this package in your Flutter Project 
                       // AAD the required permissions in your Flutter project

import 'package:demo/multiplefilepicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:flutter/material.dart';

class Singlefilepicker extends StatefulWidget {
  const Singlefilepicker({super.key});

  @override
  State<Singlefilepicker> createState() => _SinglefilepickerState();
}

class _SinglefilepickerState extends State<Singlefilepicker> {
  PlatformFile? file;
  List<String> filetype = ['Any', 'Image', 'Audio', 'Video', 'Custom', 'Media'];
  String selectedvalue = 'Any';
  FileType myfiletype = FileType.any;
  TextEditingController textcontroller = TextEditingController(text: 'png');
  List<String> extensiontype = ['png'];
  String? size;
  Future<void> picksinglefile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: myfiletype,
        allowedExtensions:
            myfiletype == FileType.custom ? extensiontype : null);
    if (result != null) {
      file = result.files.first;
      file == null ? false : OpenAppFile.open(file!.path.toString());
      final kb = file!.size / 1024;
      final mb = kb / 1024;
      final size = (mb >= 1)
          ? '${mb.toStringAsFixed(2)} MB'
          : '${kb.toStringAsFixed(2)} KB';
      this.size = size;
      setState(() {});
    }
  }

  Future<void> pickmultiplefile() async {
    final result = await FilePicker.platform.pickFiles(
        type: myfiletype,
        allowedExtensions: myfiletype == FileType.custom ? extensiontype : null,
        allowMultiple: true);
    if (result != null) {
      List<PlatformFile> platformfile = result.files;
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Multiplefilepicker(files: platformfile);
        }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.orange, Colors.red])),
            ),
            title: const Text(
              'File Picker',
              style: TextStyle(
                  color: Color.fromARGB(255, 59, 54, 54),
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            )),
        body: SingleChildScrollView(
          child: Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 170,
            ),
            file == null
                ? Text('No File found yet')
                : Column(
                    children: [
                      Text('Name -  ${file!.name}'),
                      Text('Size -  ${size!}'),
                      Text('Extension -  ${file!.extension}')
                    ],
                  ),
            const SizedBox(
              height: 170,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'File Type  ',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                const SizedBox(
                  width: 20,
                ),
                DropdownButton(
                    value: selectedvalue,
                    items: filetype.map((String type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedvalue = value!;
                        if (value == filetype[0]) {
                          myfiletype = FileType.any;
                        }
                        if (value == filetype[1]) {
                          myfiletype = FileType.image;
                        }
                        if (value == filetype[2]) {
                          myfiletype = FileType.audio;
                        }
                        if (value == filetype[3]) {
                          myfiletype = FileType.video;
                        }
                        if (value == filetype[4]) {
                          myfiletype = FileType.custom;
                        }
                        if (value == filetype[5]) {
                          myfiletype = FileType.media;
                        }
                      });
                    })
              ],
            ),
            myfiletype == FileType.custom
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: TextField(
                      controller: textcontroller,
                      decoration:
                          const InputDecoration(hintText: 'Extension type'),
                      onSubmitted: (value) {
                        extensiontype.clear();
                        extensiontype.addAll(value.split(',').toList());
                      },
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
                onPressed: picksinglefile,
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.indigo)),
                icon: const Icon(Icons.insert_drive_file_sharp),
                label: const Text(
                  'Pick File',
                  style: TextStyle(fontSize: 25),
                )),
            ElevatedButton.icon(
                onPressed: pickmultiplefile,
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.deepOrange)),
                icon: const Icon(Icons.file_copy),
                label: const Text(
                  'Pick Multiple File',
                  style: TextStyle(fontSize: 25),
                ))
          ])),
        ));
  }
}
