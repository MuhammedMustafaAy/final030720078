import 'package:ev_spot_flutter/utils/common.dart';
import 'package:ev_spot_flutter/utils/constant.dart';
import 'package:flutter/material.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms & Conditions', style: boldTextStyle(fontSize: 22)),
            SizedBox(height: 30),
            Text('Company\'s Terms of use', style: secondaryTextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(COMPANY_TERMS, style: primaryTextStyle(), textAlign: TextAlign.justify, strutStyle: StrutStyle(fontSize: 18)),
            SizedBox(height: 30),
            Text('Terms & Conditions', style: secondaryTextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(TERMS_CONDITIONS, style: primaryTextStyle(), textAlign: TextAlign.justify, strutStyle: StrutStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text(TERMS_CONDITIONS, style: primaryTextStyle(), textAlign: TextAlign.justify, strutStyle: StrutStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
