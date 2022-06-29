import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'SendEther'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String rpcUrl = "http://10.0.2.2:7545";
  String wsUrl = "ws://10.0.2.2:7545/"; //ws stands for websocket. This is a websocket url and u need to "/" at the end.
  EthereumAddress? fromAddress;
  EthereumAddress? toAddress;
  int totalEth = 0;

  Future<void> sendEther() async {
    Web3Client client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
    String privateKey =
        "f63b1b38301f3b2a675035991b196d72b02a65f91463e23ea6b117730c793a44";
    Credentials credentials =
        await client.credentialsFromPrivateKey(privateKey);

    EthereumAddress receiverAddress =
        // EthereumAddress.fromHex("0xd6BE8B26fA5CAB6022543D1F9E6d33F702681274");
        EthereumAddress.fromHex("0xa087E8b14Ad15Ee4196eC907f94c2064c9c67f98");


    EthereumAddress ownAddress = await credentials.extractAddress();
    print(ownAddress);

    client.sendTransaction(
        credentials,
        Transaction(
            from: ownAddress,
            to: receiverAddress,
            value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 10)));

            setState(() {
                fromAddress = ownAddress;
                toAddress = receiverAddress;
                totalEth +=10;
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              // height: 70,
              margin: EdgeInsets.all(10),
              // color: Colors.red,
              child: Text(
                "$totalEth Ethereum transferred from\n\n$fromAddress\n\nto\n\n$toAddress",
                style: TextStyle(fontWeight: FontWeight.w400,fontSize:20.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendEther,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
