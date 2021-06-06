import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:payment_through_paytm/Customs/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'checksumFailed.dart';
import 'paymentFailed.dart';
import 'paymentSuccessful.dart';

class PaymentStatus extends StatefulWidget {

  final String amount;
  PaymentStatus({this.amount});

  @override
  _PaymentStatusState createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {

  bool _loadingPayment = true;
  String _responseStatus = STATUS_LOADING;


  String _loadHTML() {
    return "<html> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='$PAYMENT_URL'><input type='hidden' name='orderID' value='ORDER_${DateTime.now().millisecondsSinceEpoch}'/>" +
        "<input  type='hidden' name='custID' value='${ORDER_DATA["custID"]}' />" +
        "<input  type='hidden' name='amount' value='${widget.amount}' />" +
        "<input type='hidden' name='custEmail' value='${ORDER_DATA["custEmail"]}' />" +
        "<input type='hidden' name='custPhone' value='${ORDER_DATA["custPhone"]}' />" +
        "</form> </body> </html>";

  }

  WebViewController _webViewController;

  void getData() {
    _webViewController.evaluateJavascript("document.body.innerText").then((data) {
      var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      final checksumResult = responseJSON["status"];
      final paytmResponse = responseJSON["data"];
      if (paytmResponse["STATUS"] == "TXN_SUCCESS") {
        if (checksumResult==0) {
          _responseStatus = STATUS_SUCCESSFUL;
        } else {
          _responseStatus = STATUS_CHECKSUM_FAILED;
        }
      } else if (paytmResponse["STATUS"] == "TXN_FAILURE") {
        _responseStatus = STATUS_FAILED;
      }
      this.setState((){});
    });
  }

  Widget getResponseScreen() {
    switch (_responseStatus) {
      case STATUS_SUCCESSFUL:
        return PaymentSuccessfulScreen();
      case STATUS_CHECKSUM_FAILED:
        return CheckSumFailedScreen();
      case STATUS_FAILED:
        return PaymentFailedScreen();
    }
    return PaymentSuccessfulScreen();
  }

  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget> [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,

                child: WebView(

                  debuggingEnabled: false,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                    _webViewController.loadUrl(
                        new Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString());
                  },

                  onPageFinished: (page){
                    if (page.contains("/process")){
                      if(_loadingPayment){
                        this.setState(() {
                          _loadingPayment = false;
                        });
                      }
                    }
                    if (page.contains("/paymentReceipt")){
                      getData();
                    }

                  },

                )

            ),
            (_loadingPayment) ? Center(
              child: CircularProgressIndicator(),
            ) : Center(),
            (_responseStatus != STATUS_LOADING) ? Center(child: getResponseScreen()) : Center()
          ],
        )
      ),
    );
  }
}
