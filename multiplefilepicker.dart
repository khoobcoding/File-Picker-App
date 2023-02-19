import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:flutter/material.dart';

class Multiplefilepicker extends StatefulWidget {
  List<PlatformFile>? files;
  Multiplefilepicker({required this.files, super.key});

  @override
  State<Multiplefilepicker> createState() => _MultiplefilepickerState();
}

class _MultiplefilepickerState extends State<Multiplefilepicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Files'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
          itemCount: widget.files!.length,
          itemBuilder: (context, index) {
            return buildfile(widget.files!, index);
          }),
    );
  }

  Widget buildfile(List<PlatformFile> file, index) {
    final kb = file[index].size / 1024;
    final mb = kb / 1024;
    final size = (mb >= 1)
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
    return InkWell(
      child: ListTile(
        title: Text(file[index].name),
        subtitle: Text('${file[index].extension}'),
        leading:
            (file[index].extension == 'jpg' || file[index].extension == 'png')
                ? Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.antiAlias,
                    child: Image.file(File(file[index].path.toString())),
                  )
                : CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.red,
                    child: Center(
                      child: Text(
                        '.${file[index].extension}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
        trailing: Text(
          size,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        onTap: () => OpenAppFile.open(file[index].path.toString()),
      ),
    );
  }
}
