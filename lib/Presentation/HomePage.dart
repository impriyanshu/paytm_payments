
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payment_through_paytm/Customs/abstract.dart';
import 'package:payment_through_paytm/Presentation/paymentStatus.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( Values.appbarTitleHomePage ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40 ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                  labelText: 'Enter amount'
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text('Pay' , style: TextStyle(
                color: Colors.white
              ),),
              color: Colors.blue[400],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: (){
                _controller.text != '' ?Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentStatus( amount: _controller.text)
                  )
                ) : null ;
              },
            )
          ],
        ),
      ),

    );
  }
}
