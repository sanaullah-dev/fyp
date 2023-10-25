import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_management_and_booking_system/common/controllers/request_controller.dart';
import 'package:vehicle_management_and_booking_system/models/report_model.dart';

void showUpdateDialog(BuildContext context, ReportModel report,bool isThisMachineriesReports) {
  TextEditingController commentController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Update Report"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Provide a comment for the report owner."),
            SizedBox(height: 10),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: "Your comment...",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // TODO: Handle the comment update and status change here
              String comment = commentController.text;
              if (comment.isNotEmpty) {
                // Update the report's comment and status to "completed" in your database.
                // After the update is successful, you can close the dialog:
                String comment = commentController.text;
                if (comment.isNotEmpty) {
                  await context
                      .read<RequestController>()
                      .updateReportWithCommentAndStatus(
                          reportId: report.reportId, comment: comment,isThisMachineriesReports: isThisMachineriesReports);
                  Navigator.of(context).pop();
                }
                Navigator.of(context).pop();
              }
            },
            child: Text("Update"),
          ),
        ],
      );
    },
  );
}
