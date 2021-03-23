import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peercoin/tools/app_localizations.dart';
import 'package:peercoin/providers/activewallets.dart';
import 'package:peercoin/providers/options.dart';
import 'package:peercoin/screens/setup_pin_code.dart';
import 'package:peercoin/screens/wallet_list.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class SetupSaveScreen extends StatefulWidget {
  static const routeName = "/setup-save-seed";

  @override
  _SetupSaveScreenState createState() => _SetupSaveScreenState();
}

class _SetupSaveScreenState extends State<SetupSaveScreen> {
  bool sharedYet = false;
  String seed = "";

  Future<void> shareSeed(seed) async {
    await Share.share(seed);
    Timer(
      Duration(seconds: 1),
      () => setState(() {
        sharedYet = true;
      }),
    );
  }

  @override
  void didChangeDependencies() async {
    var thisSeed = await Provider.of<ActiveWallets>(context).seedPhrase;
    setState(() {
      seed = thisSeed;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icon/ppc-icon-white-256.png",
              width: 50,
            ),
            SizedBox(height: 60),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                AppLocalizations.instance.translate('label_wallet_seed', null),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: SelectableText(
                seed,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    wordSpacing: 10),
              ),
            ),
            SizedBox(height: 40),
            Text(
              AppLocalizations.instance.translate('label_keep_seed_safe', null),
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            sharedYet
                ? TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(
                          context, SetupPinCodeScreen.routeName);
                    },
                    child: Text(
                      AppLocalizations.instance.translate('continue', null),
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : TextButton(
                    onPressed: () async => await shareSeed(seed),
                    child: Text(
                      AppLocalizations.instance.translate('export_now', null),
                      style: TextStyle(fontSize: 18),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
