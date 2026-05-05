import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class WebCameraService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> captureImage() async {
    if (kIsWeb) {
      return await _captureFromWeb();
    } else {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        return await image.readAsBytes();
      }
      return null;
    }
  }

  Future<Uint8List?> pickFromGallery() async {
    if (kIsWeb) {
      return await _pickFromWeb();
    } else {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return await image.readAsBytes();
      }
      return null;
    }
  }

  Future<Uint8List?> _captureFromWeb() async {
    final completer = Completer<Uint8List?>();

    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.setAttribute('capture', 'environment');
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files!.isNotEmpty) {
        final reader = html.FileReader();
        reader.onLoadEnd.listen((e) {
          final resultData = reader.result;
          if (resultData is ByteBuffer) {
            completer.complete(Uint8List.view(resultData));
          } else if (resultData is List<int>) {
            completer.complete(Uint8List.fromList(resultData));
          } else {
            completer.complete(null);
          }
        });
        reader.readAsArrayBuffer(files[0]);
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }

  Future<Uint8List?> _pickFromWeb() async {
    final completer = Completer<Uint8List?>();

    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files!.isNotEmpty) {
        final reader = html.FileReader();
        reader.onLoadEnd.listen((e) {
          final resultData = reader.result;
          if (resultData is ByteBuffer) {
            completer.complete(Uint8List.view(resultData));
          } else if (resultData is List<int>) {
            completer.complete(Uint8List.fromList(resultData));
          } else {
            completer.complete(null);
          }
        });
        reader.readAsArrayBuffer(files[0]);
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }
}
