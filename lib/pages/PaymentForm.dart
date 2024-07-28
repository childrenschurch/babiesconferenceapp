import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:chc_kids/pages/AppLayout.dart';
import 'package:chc_kids/pages/MyDatabase.dart';
import 'package:flutter/material.dart';
import 'package:chc_kids/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path;
import '../FirebaseFileUpload.dart';
import '../receiptNumberHelper.dart';
import 'package:http/http.dart' as http;

class PaymentForm extends StatefulWidget {
  final Map<String, dynamic> paymentDetails;
  // final int receiptNumber = 1;

  // Add a default value for the paymentDetails parameter
  const PaymentForm({Key? key, this.paymentDetails = const {}})
      : super(key: key);

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController amountInWordsController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController payerPhoneController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController receiptNumberController = TextEditingController();

  int receiptNumber = 1;

  @override
  Future<void> initState() async {
    super.initState();
    if (widget.paymentDetails != null) {
      payerPhoneController.text = widget.paymentDetails!['phone'];
      reasonController.text = widget.paymentDetails!['nameOfParent'];
      try {
        await _loadCurrentReceiptNumber();
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    print('paymentDetails: ${widget.paymentDetails}');

    // Extract and print each value individually
    final clientName = widget.paymentDetails?['name'];
    final receiptNo = receiptNumber;
    final amount = amountController.text;
    final amountInWords = amountInWordsController.text;
    final parentName = reasonController.text;
    final payerPhone = payerPhoneController.text;
    final balance = balanceController.text;

    print('Client Name: $clientName');
    print('Receipt Number: $receiptNo');
    print('Amount: $amount');
    print('Amount in Words: $amountInWords');
    print('Parent Name: $parentName');
    print('Payer Phone: $payerPhone');
    print('Balance: $balance');
    return AppLayout(
        body: ListView(
      children: [
        Column(
          children: [
            const Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Icon(
                    Icons.print,
                    size: 30.0,
                    color: Color.fromARGB(255, 100, 204, 98),
                  ),
                  SizedBox(width: 30.0),
                  Text(
                    "CREATE RECEIPT",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 100, 204, 98)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, top: 0, right: 25.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  ${widget.paymentDetails["name"]}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' --Receipt no. --$receiptNumber',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 16, 168, 23)),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: 'Amount (Figures)'),
                    style: TextStyle(
                        color: Color.fromARGB(255, 188, 4, 4),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                    validator: (value) => value!.isEmpty
                        ? 'Please enter the payment amount'
                        : null,
                  ),
                  TextFormField(
                    controller: amountInWordsController,
                    decoration: InputDecoration(labelText: 'Amount in Words'),
                    style: TextStyle(
                        color: Color.fromARGB(255, 188, 4, 4),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                    validator: (value) => value!.isEmpty
                        ? 'Please enter the amount in words'
                        : null,
                  ),
                  TextFormField(
                    controller: reasonController,
                    decoration: InputDecoration(labelText: 'Parent\'s Name'),
                    style: TextStyle(
                        color: Color.fromARGB(255, 188, 4, 4),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                    validator: (value) => value!.isEmpty
                        ? 'Please enter the name of parent'
                        : null,
                  ),
                  TextFormField(
                    controller: payerPhoneController,
                    decoration: InputDecoration(labelText: 'Payer Phone'),
                    style: TextStyle(
                        color: Color.fromARGB(255, 188, 4, 4),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                    validator: (value) => value!.isEmpty
                        ? 'Please enter the payer\'s phone number'
                        : null,
                  ),
                  TextFormField(
                    controller: balanceController,
                    decoration: InputDecoration(labelText: 'Balance'),
                    style: TextStyle(
                        color: Color.fromARGB(255, 188, 4, 4),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    children: [
                      Container(
                        color: Color.fromARGB(255, 46, 46, 46),
                        child: TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyDatabase()));
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            label: Text(
                              "Back",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            )),
                      ),
                      SizedBox(
                        width: 50.0,
                      ),
                      Container(
                        color: Color.fromARGB(255, 14, 178, 38),
                        child: TextButton.icon(
                            onPressed: () {
                              try {
                                print(widget.paymentDetails['clientId']);
                              } on Exception {
                                print(
                                    "Error getting client ID------------------");
                              }
                              ;

                              try {
                                _submitPayment();
                              } on Exception {
                                print(
                                    "Error SUBMITTING form------------------");
                              }
                            },
                            icon: Icon(
                              Icons.print,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            label: Text(
                              "Create",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        )
      ],
    ));
  }

  void _submitPayment() async {
    if (_validateInputs()) {
      Map<String, dynamic> payment = {
        //'clientId': widget.paymentDetails['id'],
        // 'clientName': widget.paymentDetails['name'],
        'clientId': 1,
        'paymentDate': DateTime.now().toIso8601String(),
        'amount': amountController.text,
        'amountInWords': amountInWordsController.text,
        'reasonOfPayment': reasonController.text,
        'payerPhone': payerPhoneController.text,
        'balance': balanceController.text,
        'dueDate': '',
        'year': '',
      };

      try {
        int result = await DatabaseHelper.instance
            .insertOrUpdatePaymentForMonth(payment);
        if (result != -1) {
          // Payment inserted/updated successfully
          print(payment);

          try {
            await _submitToGoogleSheet(payment);
            print('------------SUCCESSFULLY UPLOADED TO GOOGLE SHEET');
          } catch (e) {
            print(e);
          }
          ;
          _createReceipt(payment);
        } else {
          // Error occurred during insertion/update
          _showErrorDialog('Failed to submit payment. Please try again.');
        }
      } catch (e) {
        // Error occurred during payment submission
        print('Error submitting payment: $e');
        _showErrorDialog('Error submitting payment: $e');
      }
    }
  }

  bool _validateInputs() {
    if (amountController.text.isEmpty ||
        amountInWordsController.text.isEmpty ||
        reasonController.text.isEmpty ||
        payerPhoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all the fields'),
          backgroundColor: Color.fromARGB(255, 187, 37, 37),
        ),
      );
      return false;
    }
    return true;
  }

  void _createReceipt(Map<String, dynamic> payment) async {
    if (widget.paymentDetails != null) {
      try {
        // Create a PDF document
        final PdfDocument document = PdfDocument();

        // Add a page to the document
        document.pageSettings.size = PdfPageSize.a4;
        PdfPage page = document.pages.add();

        // Change the page orientation to landscape
        document.pageSettings.orientation = PdfPageOrientation.landscape;

        // Get the background image from assets

        // Draw the background image

        // Draw the image
        final ByteData data = await rootBundle.load('assets/receipt_bg.png');
        final Uint8List backgroundImageBytes = data.buffer.asUint8List();
        final PdfBitmap backgroundBitmap = PdfBitmap(backgroundImageBytes);

        // Calculate the position and size to maintain the aspect ratio
        double imageWidth, imageHeight;
        if (backgroundBitmap.width > backgroundBitmap.height) {
          imageWidth = page.getClientSize().width;
          imageHeight = (page.getClientSize().width / backgroundBitmap.width) *
              backgroundBitmap.height;
        } else {
          imageHeight = page.getClientSize().height;
          imageWidth = (page.getClientSize().height / backgroundBitmap.height) *
              backgroundBitmap.width;
        }

        page.graphics.drawImage(
          backgroundBitmap,
          Rect.fromLTWH(0, 0, imageWidth, imageHeight),
        );

        // Add text and payment details to the document
        final PdfFont font = PdfStandardFont(
            PdfFontFamily.helvetica, 16); // Increased font size to 20

        // Define the sky blue color
        final PdfColor skyBlue = PdfColor(0, 107, 179);

        // Set initial position
        double x = 50;
        double y = 117;

        // Add payment details in paragraphs with increased font size
        String receiptforclient =
            '${widget.paymentDetails["nameOfParent"] ?? ''},   Tel: ${payment["payerPhone"] ?? ""}';

        String _getMonthName(int month) {
          switch (month) {
            case 1:
              return 'Jan';
            case 2:
              return 'Feb';
            case 3:
              return 'Mar';
            case 4:
              return 'Apr';
            case 5:
              return 'May';
            case 6:
              return 'Jun';
            case 7:
              return 'Jul';
            case 8:
              return 'Aug';
            case 9:
              return 'Sep';
            case 10:
              return 'Oct';
            case 11:
              return 'Nov';
            case 12:
              return 'Dec';
            default:
              return '';
          }
        }

        int receiptNumber = 1;
        try {
          receiptNumber = await ReceiptNumberHelper.instance.getReceiptNumber();
          print(receiptNumber);
        } catch (e) {
          print('Error fetching receipt number: $e');
        }
        final String receiptNumberText = 'No: $receiptNumber';
        String dateofreceipt =
            "${DateTime.now().day}/${_getMonthName(DateTime.now().month)}/${DateTime.now().year}";
        print('date is--------------------- $dateofreceipt');
        _drawParagraph(
          page.graphics,
          font,
          '$receiptNumberText                                                             $dateofreceipt',
          x,
          y,
          skyBlue,
        );
        y += 45; // Increased line spacing for readability

        _drawParagraph(
          page.graphics,
          font,
          receiptforclient,
          x,
          y,
          skyBlue,
        );
        y += 20; // Increased line spacing for readability

        _drawParagraph(
          page.graphics,
          font,
          '',
          x,
          y,
          skyBlue,
        );
        y += 27;

        _drawParagraph(
          page.graphics,
          font,
          ' ${payment["amountInWords"] ?? ""}',
          x,
          y,
          skyBlue,
        );
        y += 28;

        _drawParagraph(
          page.graphics,
          font,
          '                            ${widget.paymentDetails["name"] ?? ''}',
          x,
          y,
          skyBlue,
        );
        y += 50;

        _drawParagraph(
          page.graphics,
          font,
          '                                                                   ${payment["balance"] ?? ""}',
          x,
          y,
          skyBlue,
        );
        y += 27;
        _drawParagraph(
          page.graphics,
          font,
          '            ${payment["amount"] ?? ""}',
          x,
          y,
          skyBlue,
        );
        y += 25;

        // Save the PDF to a file in the "receipts" subfolder
        final List<int> bytes = await document.save();
        document.dispose();

        // Save the PDF to a file in the "receipts" subfolder
        final String selectedMonth =
            widget.paymentDetails['selectedMonth'] ?? 'default';
        final String subfolderPath = await _getSubfolderPath(selectedMonth);
        final String timestamp = getFormattedTimestamp();
        final String fileName =
            'Receipt_${widget.paymentDetails["name"]}_$timestamp.pdf';
        final String filePath =
            await _saveAsFile(bytes, selectedMonth, fileName);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('Receipt'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      await _sharePdf(filePath);
                    },
                  ),
                ],
              ),
              body: SfPdfViewer.file(File(filePath)),
            ),
          ),
        );

        //UPLOAD TO firebase
        //await FirebaseFileUpload.uploadPdf(context, filePath, selectedMonth);

        // Share the PDF file
        await _sharePdf(filePath);

        // Display the PDF using Syncfusion PDF Viewer
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('Receipt'),
              ),
              body: SfPdfViewer.file(File(filePath)),
            ),
          ),
        );
      } catch (e) {
        print('Error creating receipt: $e');
        _showErrorDialog('Error creating receipt: $e');
      }
    }
  }

  void _drawParagraph(
    PdfGraphics graphics,
    PdfFont font,
    String text,
    double x,
    double y,
    PdfColor color,
  ) {
    final PdfStringFormat format = PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.middle,
    );

    graphics.drawString(
      text,
      font,
      brush: PdfSolidBrush(color),
      format: format,
      bounds: Rect.fromLTWH(x, y, graphics.clientSize.width - 2 * x, 25),
    );
  }

  Future<void> _sharePdf(String filePath) async {
    try {
      // Check if the file exists
      File file = File(filePath);
      bool exists = await file.exists();
      print('File exists: $exists');
      if (exists) {
        // Share the PDF file
        await Share.shareFiles([filePath], text: 'Receipt');
      } else {
        throw 'The source file doesn\'t exist.';
      }
    } catch (e) {
      print('Error sharing PDF: $e');
      _showErrorDialog('Error sharing PDF: $e');
    }
  }

  Future<String> _getSubfolderPath(String selectedMonth) async {
    final String externalStorageDir = await _getExternalStorageDirectory();
    final String subfolderPath =
        path.join(externalStorageDir, 'receipts', selectedMonth);

    // Create the subfolder if it doesn't exist
    final Directory subfolderDir = Directory(subfolderPath);
    if (!await subfolderDir.exists()) {
      await subfolderDir.create(recursive: true);
    }

    return subfolderPath;
  }

  Future<String> _getExternalStorageDirectory() async {
    final Directory? externalDir = await getExternalStorageDirectory();
    if (externalDir != null) {
      return externalDir.path;
    } else {
      throw 'External storage directory not available';
    }
  }

  Future<String> _saveAsFile(
      List<int> bytes, String selectedMonth, String fileName) async {
    final String subfolderPath = await _getSubfolderPath(selectedMonth);

    // Save the PDF to a file in the subfolder
    final String filePath = path.join(subfolderPath, fileName);
    final File file = File(filePath);
    await file.writeAsBytes(bytes);

    // Print the file path for debugging
    print('File Path: $filePath');

    return filePath;
  }

  String getFormattedTimestamp() {
    final DateTime now = DateTime.now();
    final String day = now.day.toString();
    final String month = _getMonthName(now.month);
    final String year = now.year.toString();
    final String hour = _getHour(now.hour);
    final String minute = now.minute.toString().padLeft(2, '0');

    return '$day$month$year-$hour-$minute hrs';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'jan';
      case 2:
        return 'feb';
      case 3:
        return 'mar';
      case 4:
        return 'apr';
      case 5:
        return 'may';
      case 6:
        return 'jun';
      case 7:
        return 'jul';
      case 8:
        return 'aug';
      case 9:
        return 'sep';
      case 10:
        return 'oct';
      case 11:
        return 'nov';
      case 12:
        return 'dec';
      default:
        return '';
    }
  }

  String _getHour(int hour) {
    if (hour == 0) {
      return '12';
    } else if (hour > 12) {
      return (hour - 12).toString();
    } else {
      return hour.toString();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadCurrentReceiptNumber() async {
    int receiptNumberGot =
        await ReceiptNumberHelper.instance.getReceiptNumber();
    setState(() {
      receiptNumber = receiptNumberGot;
    });
  }

  Future<void> _submitToGoogleSheet(Map<String, dynamic> payment) async {
    final String url = 'https://sheetdb.io/api/v1/n1ivgtsb3x0dd';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name_of_child': widget.paymentDetails["name"] ?? '',
          'phone': payment["payerPhone"] ?? '',
          'amountInWords': payment["amountInWords"] ?? '',
          'parent': widget.paymentDetails["nameOfParent"] ?? '',
          'balance': payment["balance"] ?? '',
          'amount': payment["amount"] ?? '',
          'receiptNumber': receiptNumber.toString(),
          'date': payment["paymentDate"] ?? '',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        print('Data submitted successfully');
      } else {
        print('Failed to submit data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  Future<void> _submitToGoogleSheetTest() async {
    final String url = 'https://sheetdb.io/api/v1/n1ivgtsb3x0dd';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name_of_child': 'John Doe',
          'phone': '123456789',
          'amountInWords': 'one hundred dollars',
          'parent': 'Jane Doe',
          'balance': '50',
          'amount': '100',
          'receiptNumber': '12345',
          'date': '2024-07-25',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        print('Data submitted successfully');
      } else {
        print('Failed to submit data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }
}
