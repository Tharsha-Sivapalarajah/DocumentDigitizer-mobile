import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan_me/pick_images.dart';
import 'package:scan_me/preview_scanned_pdf.dart';
import 'sign_in.dart';
import 'sign_up.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_mode.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  File? imageFile;

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          // Navigate to the Search Screen
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              icon: const Icon(Icons.search)),

              PopupMenuButton(
                   // add icon, by default "3 dot" icon
                   // icon: Icon(Icons.book)
                   itemBuilder: (context){
                     return [
                            // const PopupMenuItem<int>(
                            //     value: 0,
                            //     child: Text("Sign In"),
                            // ),
                            //
                            const PopupMenuItem<int>(
                                value: 1,
                                child: Text("PDFs"),

                            ),
                           const PopupMenuItem<int>(
                             value: 2,
                             child: Text("Sign Out"),
                           ),
                        ];
                   },
                   onSelected:(value){
                    // if (value == 0) {
                    //   Navigator.of(context).
                    //     pushReplacement( MaterialPageRoute(
                    //       builder: (BuildContext context) => const SignIn()));
                    // } else
                      if (value == 1) {
                      Navigator.of(context).
                        pushReplacement(MaterialPageRoute(
                          builder: (_) => const PreviewScannedPDF()));
                    }else
                      if(value ==2){
                        FirebaseAuth.instance.signOut();
                    }
                   }
                  ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageFile != null) 
              Container(
                width: 500,
                height: 400,
                alignment: Alignment.center,
                decoration: BoxDecoration (
                  color: Colors.white,
                  image: DecorationImage(
                    image: FileImage(imageFile!),
                    fit: BoxFit.cover
                  ),
                  border: Border.all(width: 8, color: Colors.black),
                  borderRadius: BorderRadius.circular(3),
                ),
              )
            else
              Container()
              // const SizedBox(height: 20,),
              //   Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: GridView.builder(
              //             itemCount: imageFileList!.length,
              //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //               crossAxisCount: 3
              //             ),
              //             itemBuilder: (BuildContext context, int index) {
              //               return Image.file(File(imageFileList![index].path), fit: BoxFit.cover);
              //             }
              //         ),
              //       )
              //   )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () async {
            await availableCameras().then((value) => Navigator.push(context,
                MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
            },
            tooltip: "increment",
            child: const Icon(Icons.camera_alt_rounded),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 15)),

          FloatingActionButton(
            heroTag: 'button2',
            //onPressed: () => getImage(ImageSource.gallery),
            onPressed: () async {
              selectImages();
            },
            tooltip: "increment",
            child: const Icon(Icons.photo_library_rounded),
      ),

      const Padding(
            padding: EdgeInsets.only(bottom: 15)),

          FloatingActionButton(
            heroTag: 'button3',
            onPressed: () async {
              PickImagesPage();
            },
            tooltip: "increment",
            child: const Icon(Icons.file_copy_rounded),
      ),

        ],
      ),

    );
  }

  void getImage(ImageSource source) async {
    final file = await ImagePicker().pickImage(
      source: source,
      imageQuality: 100
    );

    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
      });
    }
  }

  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {
    });
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);
  
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    /* Clear the search field */
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none),
          ),
        ),
      )),
    );
  }
}

