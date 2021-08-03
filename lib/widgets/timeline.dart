import 'package:flutter/material.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/config/frappe_palette.dart';
import 'package:frappe_app/model/get_doc_response.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/email_form.dart';
import 'package:frappe_app/widgets/doc_version.dart';
import 'package:frappe_app/widgets/email_box.dart';

import 'package:timelines/timelines.dart' as timeline;

import 'comment_box.dart';

class Timeline extends StatelessWidget {
  final Docinfo docinfo;
  final String doctype;
  final String name;
  final String emailSubjectField;
  final String emailSenderField;
  final bool communicationOnly;
  final Function switchCallback;
  final Function refreshCallback;

  Timeline({
    required this.docinfo,
    required this.doctype,
    required this.name,
    required this.emailSenderField,
    required this.emailSubjectField,
    required this.communicationOnly,
    required this.switchCallback,
    required this.refreshCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        List<Widget> children = [
          Row(
            children: [
              Text(
                'Activity',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: FrappePalette.grey[900],
                ),
              ),
              Spacer(),
              Switch.adaptive(
                value: communicationOnly,
                activeColor: Colors.blue,
                onChanged: (val) {
                  switchCallback(val);
                },
              ),
              Text(
                "Communication Only",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: FrappePalette.grey[700],
                ),
              ),
            ],
          ),
        ];

        children.add(
          Row(
            children: [
              FlatButton.icon(
                color: FrappePalette.grey[600],
                shape: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                label: Text(
                  'New Email',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                icon: FrappeIcon(
                  FrappeIcons.email,
                ),
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return EmailForm(
                          callback: () {
                            refreshCallback();
                          },
                          subjectField: emailSubjectField,
                          senderField: emailSenderField,
                          doctype: doctype,
                          doc: name,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );

        for (var event in _processData()) {
          if (event["_category"] == "communications") {
            event = Communication.fromJson(event);
          } else if (event["_category"] == "comments") {
            event = Comment.fromJson(event);
          }

          if (event is Communication) {
            children.add(EmailBox(event));
          } else if (event is Comment) {
            children.add(
              CommentBox(
                event,
                () {
                  refreshCallback();
                },
              ),
            );
          } else {
            if (communicationOnly) {
              continue;
            }

            children.add(DocVersion(event));
          }
        }

        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: timeline.Timeline.tileBuilder(
            theme: timeline.TimelineThemeData(
              connectorTheme: timeline.ConnectorThemeData(
                space: 51,
                thickness: 2,
                color: FrappePalette.grey[200],
              ),
              nodePosition: 0,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            builder: timeline.TimelineTileBuilder.connected(
              indicatorBuilder: (context, idx) {
                return CircleAvatar(
                  radius: 10,
                  backgroundColor: FrappePalette.grey[300],
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 8,
                    child: Icon(
                      Icons.lens,
                      size: 6,
                      color: FrappePalette.grey[600],
                    ),
                  ),
                );
              },
              connectorBuilder: (_, index, __) {
                return timeline.SolidLineConnector();
              },
              itemCount: children.length,
              contentsBuilder: (context, idx) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: children[idx],
                );
              },
            ),
          ),
        );
      },
    );
  }

  List _processData() {
    var _events = [
      ...docinfo.comments.map(
        (comment) {
          var c = comment.toJson();
          c["_category"] = "comments";
          return c;
        },
      ).toList(),
      ...docinfo.communications.map((communication) {
        var c = communication.toJson();
        c["_category"] = "communications";
        return c;
      }).toList(),
      ...docinfo.versions.map((version) {
        var v = version.toJson();
        v["_category"] = "versions";
        return v;
      }).toList(),
      ...docinfo.views.map((view) {
        var v = view.toJson();
        v["_category"] = "views";
        return v;
      }).toList(),
    ];
    var events = sortBy(_events, "creation", OrderBy.desc);
    return events;
  }
}
