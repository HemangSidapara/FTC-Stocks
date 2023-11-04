import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_color.dart';
import 'package:permission_handler/permission_handler.dart';

class FilePickerService {
  FilePickerResult? result;

  Future<File?> singleFilePicker({List<String>? allowedExtensions}) async {
    if (await Permission.storage.isGranted || await Permission.photos.request().isGranted) {
      if (kDebugMode) {
        print("Storage Permission ::::: Granted");
      }
    } else if (await Permission.storage.isPermanentlyDenied || await Permission.photos.request().isPermanentlyDenied) {
      if (kDebugMode) {
        print("Storage Permission ::::: PermanentlyDenied");
      }
      await openAppSettings();
    } else if (await Permission.storage.isDenied || await Permission.photos.request().isDenied) {
      if (kDebugMode) {
        print("Storage Permission ::::: Denied");
      }
      await Permission.storage.request();
    }

    if (await Permission.storage.isGranted || await Permission.photos.isGranted) {
      result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: allowedExtensions,
        type: allowedExtensions != null ? FileType.custom : FileType.any,
      );

      if (result != null) {
        File file = File(result!.files.single.path!);
        if (kDebugMode) {
          // print('\x1B[32m<--------------------[---^--_--^---]-------------------->\x1B[0m');
          // print('\x1B[33mFilePicked Type\x1B[0m :::: \x1B[31m${lookupMimeType(file.path)}\x1B[0m');
          print('\x1B[32m<--------------------[---^--_--^---]-------------------->\x1B[0m');
          print('\x1B[33mFilePicked Absolute-Path\x1B[0m :::: \x1B[31m${file.absolute}\x1B[0m');
          print('\x1B[32m<--------------------[---^--_--^---]-------------------->\x1B[0m');
          print('\x1B[33mFilePicked Path\x1B[0m :::: \x1B[31m${file.path}\x1B[0m');
          print('\x1B[32m<--------------------[---^--_--^---]-------------------->\x1B[0m');
          print('\x1B[33mFilePicked Uri-Path\x1B[0m :::: \x1B[31m${file.uri}\x1B[0m');
          print('\x1B[32m<--------------------[---^--_--^---]-------------------->\x1B[0m');
        }
        return file;
      } else {
        if (kDebugMode) {
          print('\x1B[32m<-------\x1B[0m \x1B[31m): File not picked :(\x1B[0m \x1B[32m------->\x1B[0m');
        }
        return null;
      }
    }
    return null;
  }

  Future<List<File>?> multiFilePicker({List<String>? allowedExtensions}) async {
    if (await Permission.storage.isGranted || await Permission.photos.request().isGranted) {
      if (kDebugMode) {
        print("Storage Permission ::::: Granted");
      }
    } else if (await Permission.storage.isPermanentlyDenied || await Permission.photos.request().isPermanentlyDenied) {
      if (kDebugMode) {
        print("Storage Permission ::::: PermanentlyDenied");
      }
      await openAppSettings();
    } else if (await Permission.storage.isDenied || await Permission.photos.request().isDenied) {
      if (kDebugMode) {
        print("Storage Permission ::::: Denied");
      }
      await Permission.storage.request();
    }

    if (await Permission.storage.isGranted || await Permission.photos.isGranted) {
      result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: allowedExtensions,
        onFileLoading: (p0) {
          return p0 == FilePickerStatus.picking
              ? CircularProgressIndicator(
                  color: AppColors.PRIMARY_COLOR,
                )
              : null;
        },
      );

      if (result != null) {
        List<File> files = result!.paths.map((path) => File(path!)).toList();

        for (int i = 0; i < files.length; i++) {
          if (kDebugMode) {
            print('\x1B[32m<--------------------[---^--_--^---]-------------------->\x1B[0m');
            // print('\x1B[33m[${i + 1}] FilePicked Type\x1B[0m :::: \x1B[31m${lookupMimeType(files[i].path)}\x1B[0m');
            print('\x1B[32m<--------------------[---^--_--^---]-------------------->\x1B[0m');
            print('\x1B[33m[${i + 1}] FilePicked Absolute-Path\x1B[0m :::: \x1B[31m${files[i].absolute}\x1B[0m');
            print('\x1B[32m<--------------------[---^--_--^---]-------------------->\x1B[0m');
            print('\x1B[33m[${i + 1}] FilePicked Path\x1B[0m :::: \x1B[31m${files[i].path}\x1B[0m');
            print('\x1B[32m<--------------------[---^--_--^---]-------------------->\x1B[0m');
            print('\x1B[33m[${i + 1}] FilePicked Uri-Path\x1B[0m :::: \x1B[31m${files[i].uri}\x1B[0m');
          }
          if (i == files.length - 1) {
            if (kDebugMode) {
              print('\x1B[32m<--------------------[---^--_--^---]-------------------->\x1B[0m');
            }
          }
        }

        return files;
      } else {
        // User canceled the picker
        if (kDebugMode) {
          print('\x1B[32m<-------\x1B[0m \x1B[31m): File not picked :(\x1B[0m \x1B[32m------->\x1B[0m');
        }
        return null;
      }
    }
    return null;
  }
}
