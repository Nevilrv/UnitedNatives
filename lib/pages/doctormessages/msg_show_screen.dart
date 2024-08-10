import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MessageShowScreen extends StatefulWidget {
  final String? file;
  final String? type;

  const MessageShowScreen({super.key, this.file, this.type});

  @override
  State<MessageShowScreen> createState() => _MessageShowScreenState();
}

class _MessageShowScreenState extends State<MessageShowScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: h * 0.02),
            widget.type == 'image'
                ? Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: PhotoView(
                          imageProvider: NetworkImage(
                            widget.file!,
                          ),
                          minScale: PhotoViewComputedScale.contained,
                          initialScale: PhotoViewComputedScale.contained,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.red,
                      child: SfPdfViewer.network(
                        widget.file!,
                        key: _pdfViewerKey,
                      ),
                    ),
                  )),
            SizedBox(height: h * 0.02),
          ],
        ),
      ),
    );
  }
}
