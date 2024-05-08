import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:pfa_frontend/models/Lecons.dart';
import 'package:pfa_frontend/services/visitor/lesson_details_visitor.dart';
import 'package:pfa_frontend/utils/setting_provider.dart';
import 'package:provider/provider.dart';

class LessonDetailsScreen extends StatelessWidget {
  final int lessonId;

  const LessonDetailsScreen({Key? key, required this.lessonId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson Details'),
      ),
      body: FutureBuilder<LessonDetails>(
        future: LessonDetailsService().fetchLessonDetails(lessonId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final lessonDetails = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lessonDetails.titre,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lesson Details:' +
                        lessonDetails.imageNumber.toString() +
                        "images," +
                        lessonDetails.audioNumber.toString() +
                        "audios," +
                        lessonDetails.videoNumber.toString() +
                        "videos," +
                        lessonDetails.textNumber.toString() +
                        "texts,",
                    style: TextStyle(
                      fontSize: context
                          .watch<SettingsProvider>()
                          .settings
                          .smallTextSize,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Content:',
                    style: TextStyle(
                      fontSize:
                          context.watch<SettingsProvider>().settings.titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var content in lessonDetails.content)
                          _Accordion(
                            content: content,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class _Accordion extends StatelessWidget {
  final LessonContent content;

  const _Accordion({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(color: Colors.white, fontSize: 18);
    final contentStyle = TextStyle(color: Colors.black, fontSize: 16);

    Widget sectionContent;
    if (content is LessonText) {
      sectionContent = ListTile(
        title: Text((content as LessonText).titre, style: contentStyle),
        subtitle: Text((content as LessonText).texte, style: contentStyle),
      );
    } else if (content is LessonImage) {
      sectionContent = ListTile(
        title: Text((content as LessonImage).titre, style: contentStyle),
        subtitle:
            Text((content as LessonImage).desciptionImage, style: contentStyle),
      );
    } else if (content is LessonVideo) {
      sectionContent = ListTile(
        title: Text((content as LessonVideo).titre, style: contentStyle),
        subtitle:
            Text((content as LessonVideo).desciptionVideo, style: contentStyle),
      );
    } else if (content is LessonAudio) {
      sectionContent = ListTile(
        title: Text((content as LessonAudio).titre, style: contentStyle),
        subtitle:
            Text((content as LessonAudio).desciptionAudio, style: contentStyle),
      );
    } else {
      sectionContent = SizedBox();
    }

    return AccordionSection(
      isOpen: false,
      contentVerticalPadding: 20,
      leftIcon: _getIconForContentType(content),
      header: Text(_getHeaderForContentType(content), style: headerStyle),
      content: sectionContent,
    );
  }

  Widget _getIconForContentType(LessonContent content) {
    if (content is LessonText) {
      return Icon(Icons.text_fields_rounded, color: Colors.white);
    } else if (content is LessonImage) {
      return Icon(Icons.image_rounded, color: Colors.white);
    } else if (content is LessonVideo) {
      return Icon(Icons.video_collection_rounded, color: Colors.white);
    } else if (content is LessonAudio) {
      return Icon(Icons.audiotrack_rounded, color: Colors.white);
    } else {
      return Icon(Icons.error, color: Colors.white);
    }
  }

  String _getHeaderForContentType(LessonContent content) {
    if (content is LessonText) {
      return "Text:" + content.titre;
    } else if (content is LessonImage) {
      return "Image:" + content.titre;
    } else if (content is LessonVideo) {
      return "Video:" + content.titre;
    } else if (content is LessonAudio) {
      return "Audio:" + content.titre;
    } else {
      return 'Unknown Content';
    }
  }
}
