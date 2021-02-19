import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class UpdateDialog extends StatefulWidget {
  final String dialogText;
  final String fileURL;

  const UpdateDialog({Key key, this.dialogText, this.fileURL})
      : super(key: key);

  @override
  UpdateDialogState createState() => UpdateDialogState();
}

class UpdateDialogState extends State<UpdateDialog> {
  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  var dio = Dio();

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('New Version Available'),
      content: Text(widget.dialogText),
      actions: [
        RaisedButton(
          onPressed: () async {
            var tempDir = await getTemporaryDirectory();
            String fullPath = tempDir.path + "/boo2.pdf'";
            print('full path $fullPath');

            download2(dio, widget.fileURL, fullPath);
          },
          child: Text('Download APK Now!'),
        )
      ],
    );
  }
}
