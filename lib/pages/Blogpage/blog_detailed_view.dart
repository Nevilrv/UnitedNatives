import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:ndialog/ndialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:united_natives/viewModel/patient_homescreen_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/ResponseModel/api_state_enum.dart';
import 'package:united_natives/ResponseModel/research_document_details_model.dart';
import 'package:united_natives/pages/Blogpage/video_player.dart';
import 'package:united_natives/utils/utils.dart';

class BlogDetailedViewPage extends StatefulWidget {
  final String? id;
  const BlogDetailedViewPage({super.key, this.id});

  @override
  State<BlogDetailedViewPage> createState() => _BlogDetailedViewPageState();
}

class _BlogDetailedViewPageState extends State<BlogDetailedViewPage> {
  final PatientHomeScreenController _patientHomeScreenController = Get.find();

  @override
  void initState() {
    _patientHomeScreenController
        .getResearchDocumentDetails(widget.id.toString());
    super.initState();
  }

  bool? isLoading;

  bool _allowWriteFile = false;

  String progress = "";

  Dio dio = Dio();

  final bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  @override
  Widget build(BuildContext context) {
    String url = "https://www.cs.purdue.edu/homes/ayg/CS251/slides/chap5.pdf";
    String extension = url.substring(url.lastIndexOf("/"));

    return Scaffold(
      body: Obx(
        () {
          if (_patientHomeScreenController
                  .researchDocumentDetailsModelData.value.apiState ==
              APIState.COMPLETE) {
            ResearchDocumentDetails? researchDocumentDetails =
                _patientHomeScreenController.researchDocumentDetailsModelData
                    .value.researchDocumentDetails;
            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: false,
                    pinned: false,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        "${researchDocumentDetails?.researchImage}",
                        errorBuilder: (
                          BuildContext? context,
                          Object? error,
                          StackTrace? stackTrace,
                        ) {
                          return Image.network(
                            '${researchDocumentDetails?.researchImage}',
                            errorBuilder: (
                              BuildContext? context,
                              Object? error,
                              StackTrace? stackTrace,
                            ) {
                              return Image.asset(
                                  'assets/images/blog-covid.jpg');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translate.of(context)!.translate(
                            researchDocumentDetails?.researchTitle ?? ''),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        researchDocumentDetails?.researchDescription ?? '',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: <Widget>[
                        Expanded(
                          child: Text(
                            'Download Complete Research Data',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                          onPressed: () {
                            //TODO : download image
                            // downloadPDF(context);

                            getDirectoryPath().then((path) {
                              File f = File(path + extension);

                              if (f.existsSync()) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PDFScreen(f.path);
                                }));
                                return;
                              }

                              downloadFile(url, "$path/$extension", context);
                            });

                            // downloadFile(
                            //     'https://docs.google.com/viewer?url=https://www.computer-pdf.com/pdf/0299-introduction-computer-design.pdf');
                          },
                        ),
                      ]),
                      const SizedBox(
                        width: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey[350],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 175,
                          child: ChewieDemo(
                            videoUrl: _patientHomeScreenController
                                    .researchDocumentDetailsModelData
                                    .value
                                    .researchDocumentDetails
                                    ?.researchVideoUrl ??
                                "",
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.transparent,
                            backgroundImage: _isdark
                                ? const AssetImage(
                                    'assets/images/neww_b_Logo.png',
                                  )
                                : const AssetImage(
                                    'assets/images/neww_w_Logo.png',
                                  ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Translate.of(context)!
                                      .translate('Released By')
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  researchDocumentDetails?.researchAuthor ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  researchDocumentDetails
                                          ?.researcherSpeciality ??
                                      "",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (_patientHomeScreenController
                  .researchDocumentDetailsModelData.value.apiState ==
              APIState.COMPLETE_WITH_NO_DATA) {
            return const Center(
              child: Text(
                "No data to show!",
                style: TextStyle(fontSize: 21),
              ),
            );
          } else if (_patientHomeScreenController
                  .researchDocumentDetailsModelData.value.apiState ==
              APIState.ERROR) {
            return const Center(
              child: Text("Error"),
            );
          } else if (_patientHomeScreenController
                  .researchDocumentDetailsModelData.value.apiState ==
              APIState.PROCESSING) {
            return Center(
              child: Utils.circular(),
            );
          } else {
            return const Center(
              child: Text(
                "No data!",
                style: TextStyle(fontSize: 21),
              ),
            );
          }
        },
      ),
    );
  }

  requestWritePermission() async {
    if (await Permission.storage.request().isGranted) {
      _allowWriteFile = true;
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      log('statuses---------->>>>>>>>${statuses.toString()}');
    }
  }

  Future<String> getDirectoryPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory directory =
        await Directory('${appDocDirectory.path}/dir').create(recursive: true);
    return directory.path;
  }

  Future downloadFile(String url, path, context) async {
    if (!_allowWriteFile) {
      requestWritePermission();
    }
    try {
      ProgressDialog progressDialog = ProgressDialog(context,
          dialogTransitionType: DialogTransitionType.Bubble,
          title: const Text("Downloading File"),
          message: null);
      progressDialog.show();
      await dio.download(url, path, onReceiveProgress: (rec, total) {
        isLoading = true;
        progress = "${((rec / total) * 100).toStringAsFixed(0)}%";
        progressDialog.setMessage(Text("Downloading $progress"));
      });
      progressDialog.dismiss();
    } catch (e) {
      log('e==========>>>>>$e');
    }
  }
}

class PDFScreen extends StatelessWidget {
  final String pathPDF;
  PDFScreen(this.pathPDF, {super.key});
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.file(
      File(pathPDF),
      key: _pdfViewerKey,
    );
  }
}
