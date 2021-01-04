import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async' show Future;
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';

class PolicyPage extends StatelessWidget {

  Future<String> loadAsset(BuildContext context) async {
    return await DefaultAssetBundle.of(context).loadString('assets/policy.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        //backgroundColor: Color(0xFF54C5F8),
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Our Privacy Policy",
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Html(
            data: """<p><span>&nbsp;</span></p>
<p><span><b>I. INTRODUCTION</b></span></p>
<p><span>&nbsp;</span></p>
<ol type="1">
    <li><span>Welcome to the Cartsini website run by Core Allied Sdn Bhd and its affiliates (individually and collectively, "Cartsini", "we", "us" or "our"). Cartsini takes its responsibilities under applicable privacy laws and regulations ("Privacy Laws") seriously and is committed to respecting the privacy rights and concerns of all users of our website (the "Site"). We recognize the importance of the personal data you have entrusted to us and believe that it is our responsibility to properly manage, protect and process your personal data. This Privacy Policy (</span>
        <span>“</span><span>Privacy Policy</span><span>”&nbsp;</span><span>or&nbsp;</span><span>“</span><span>Policy</span><span>”</span>
            <span>) is designed to assist you in understanding how we collect, use, disclose and/or process the personal data you have provided to us and/or possess about you, whether now or in the future, as well as to assist you in making an informed decision
                before providing us with any of your personal data.</span>
    </li>
</ol>
<p><span>&nbsp;</span></p>
<ol start="2" type="1">
    <li><span>"Personal Data" or "personal data" means data, whether true or not, about an individual who can be identified from that data, or from that data and other information to which an organisation has or is likely to have access. Common examples of personal data could include name, identification number and contact information.</span></li>
</ol>
<p><span>&nbsp;</span></p>
<ol start="3" type="1">
    <li><span>By visiting and/or accessing the Site, you acknowledge and agree that you accept the practices, requirements, and/or policies outlined in this Privacy Policy, and you hereby consent to us collecting, using, disclosing and/or processing your personal data as described herein. IF YOU DO NOT CONSENT TO THE PROCESSING OF YOUR PERSONAL DATA AS DESCRIBED IN THIS PRIVACY POLICY, PLEASE DO NOT VIST AND/OR ACCESS THE SITE. If we change our Privacy Policy, we will post those changes or the amended Privacy Policy on our Site. We reserve the right to amend this Privacy Policy at any time.</span></li>
</ol>
<p><span>&nbsp;</span></p>
<p><span><b>II. WHEN WILL CARTSINI COLLECT PERSONAL DATA?</b></span></p>
<p><span>&nbsp;</span></p>
<p><span>1.</span><span>&nbsp;&nbsp;</span><span>We will/may collect personal data about you:</span></p>
<p><span>&nbsp;</span></p>
<p><span>●</span><span>&nbsp;&nbsp;</span><span>when you access and/or visit our Site;</span></p>
<p><span>●</span><span>&nbsp;&nbsp;</span><span>when you submit any form, including, but not limited to, application forms or other forms relating to any of our job postings;</span></p>
<p><span>●</span><span>&nbsp;</span><span>when you interact with us, such as via telephone calls (which may be recorded), letters, fax, face-to-face meetings, social media platforms, emails or through the Site. This includes, without limitation, through cookies which we may deploy when you access and/or visit our Site;</span></p>
<p><span>●</span><span>&nbsp;&nbsp;</span><span>when you provide documentation or information in respect of your interactions with us;</span></p>
    <p><span>●</span><span>&nbsp;&nbsp;</span><span>when you provide us with feedback;</span></p>
    <p><span>●</span><span>&nbsp;&nbsp;</span><span>when you submit your personal data to us for any reason.</span></p>
    <p><span>&nbsp;</span></p>
    <p><span>The above does not purport to be exhaustive and sets out some common instances of when personal data about you may be collected.</span><br><span>&nbsp;</span></p>
    <p><span><b>III. WHAT PERSONAL DATA WILL CARTSINI COLLECT?</b></span></p>
    <p><span>&nbsp;</span></p>
    <p><span>1.</span><span>&nbsp;&nbsp;</span><span>The personal data that Cartsini may collect includes but is not limited to:</span></p>
    <p><span>●</span><span>&nbsp;&nbsp;</span><span>name;</span></p>
    <p><span>●</span><span>&nbsp;&nbsp;</span><span>email address;</span></p>
    <p><span>●</span><span>&nbsp;&nbsp;</span><span>date of birth;</span></p>
    <p><span>●</span><span>&nbsp;&nbsp;</span><span>home address;</span></p>
    <p><span>●</span><span>&nbsp;&nbsp;</span><span>telephone number;</span></p>
    <p><span>●</span><span>&nbsp;&nbsp;</span><span>gender;</span></p>
    <p><span>●</span><span>&nbsp;&nbsp;</span><span>any other information about you when you access, visit and/or interact with the Site: and aggregate data on content you engage with.</span></p>
    <p><span>&nbsp;</span></p>
        <p><span>2.</span><span>&nbsp;&nbsp;</span><span>If you do not want us to collect the aforementioned information/personal data, you may opt out at any time by notifying our Data Protection Officer in writing. Further information on opting out can be found in the section below entitled "How can you withdraw consent, remove, request access to or modify information you have provided to us?". Note, however, that opting out or withdrawing your consent for us to collect, use or process your personal data may affect your use of the Services and the Platform. For example, opting out of the collection of location information will cause its location-based features to be disabled.</span></p>
        <p><span>&nbsp;</span></p>
            <p><span><b>IV. COLLECTION OF OTHER DATA</b></span></p>
            <p><span>&nbsp;</span></p>
            <ol type="1">
                <li><span>As with most websites and mobile applications, your device sends information which may include data about you that gets logged by a web server when you browse our Platform. This typically includes without limitation, your Internet Protocol (IP) address, computer/mobile device operating system and browser type, type of mobile device, the characteristics of the mobile device, the unique device identifier (UDID) or mobile equipment identifier (MEID) for your mobile device, the address of a referring web site (if any), and the pages you visit on our website and mobile applications and the times of visit, and sometimes a "cookie" (which can be disabled using your browser preferences) to help the site remember your last visit. The information is also included in anonymous statistics to allow us to understand how visitors use our Site.</span></li>
            </ol>
            <p><span>&nbsp;</span></p>
            <ol start="2" type="1">
                <li><span>Our mobile applications may collect precise information about the location of your mobile device using technologies such as GPS, Wi-Fi, etc. We collect, use, disclose and/or process this information for one or more Purposes including, without limitation, location-based services that you request or to deliver relevant content to you based on your location or to allow you to share your location to other users as part of the services under our mobile applications. For most mobile devices, you are able to withdraw your permission for us to acquire this information on your location through your device settings. If you have questions about how to disable your mobile device's location services, please contact your mobile device service provider or the device manufacturer.</span></li>
            </ol>
            <p><span>&nbsp;</span></p>
            <p><span><b>V. COOKIES</b></span><br><span>&nbsp;</span></p>
            <ol type="1">
                <li><span>We may from time to time implement "cookies" or other features to allow us or third parties to collect or share information that will help us improve our Site or offer new features.&nbsp;</span>
                    <span>“</span><span>Cookies</span><span>”&nbsp;</span><span>are identifiers we transfer to your computer or mobile device that allow us to recognize your computer or device and tell us how and when the Site is used, accessed and/or visited, by how many people and to track movements within the Site. We may link cookie information to personal data.&nbsp;</span></li>
            </ol>
            <p><span>&nbsp;</span></p>
            <ol start="2" type="1">
                <li><span>You may refuse the use of cookies by selecting the appropriate settings on your browser. However, please note that if you do this you may not be able to use and/or access the full functionality of our Site.</span></li>
            </ol>
            <p><br><span><b>VI. HOW DO WE USE THE INFORMATION YOU PROVIDE US?</b></span></p>
            <p><span>&nbsp;</span></p>
            <ol type="1">
                <li><span>We may collect, use, disclose and/or process your personal data for one or more of the following purposes:</span></li>
            </ol>
            <p><span>&nbsp;</span></p>
            <p><span>●</span><span>&nbsp;&nbsp;</span><span>to consider and/or process your application with us;</span></p>
            <p><span>●</span><span>&nbsp;&nbsp;</span><span>to manage, operate, provide and/or administer your use of and/or access to the Site;</span></p>
            <p><span>●</span><span>&nbsp;&nbsp;</span><span>to tailor your experience by providing a faster method for you to submit information to us and allowing us to contact you, if necessary;</span></p>
            <p><span>●</span><span>&nbsp;&nbsp;</span><span>to enforce our Terms of Service or any applicable end user license agreements;</span></p>
                <p><span>●</span><span>&nbsp;&nbsp;</span><span>to protect personal safety and the rights, property or safety of others;</span></p>
                <p><span>●</span><span>&nbsp;&nbsp;</span><span>for identification and/or verification;</span></p>
                <p><span>●</span><span>&nbsp;&nbsp;</span><span>to maintain and administer any software updates and/or other updates and support that may be required from time to time to ensure the smooth running of the Site; to deal with or respond to any enquiries from (or purported to be from) you;</span></p>
                <p><span>●</span><span>&nbsp;</span><span>&nbsp;to contact you or communicate with you via voice call, text message and/or fax message, email and/or postal mail or otherwise for the purposes of administering and/or managing the Site, such as but not limited to communicating administrative information to you relating to the Site. You acknowledge and agree that such communication by us could be by way of the mailing of correspondence, documents or notices to you, which could involve disclosure of certain personal data about you to bring about delivery of the same as well as on the external cover of envelopes/mail packages;</span></p>
                    <p><span>●</span><span>&nbsp;&nbsp;</span><span>to conduct research, analysis and development activities (including, but not limited to, data analytics, surveys, technology development and/or profiling), to analyse how you use the Site, to improve and/or to enhance the Site;</span></p>
                        <p><span>●</span><span>&nbsp;&nbsp;</span><span>to allow for audits and surveys to, among other things, validate the size and composition of our target audience, and understand their experience with the Site;</span></p>
                            <p><span>●</span><span>&nbsp;</span><span>for marketing and in this regard, to send you by various modes of communication such as postal mail, email, location-based services or otherwise, information and materials relating to job offerings that Cartsini (and/or its affiliates or related corporations) may have, whether such listings exist now or are created in the future;</span></p>
                                <p><span>●</span><span>&nbsp;&nbsp;</span><span>to respond to legal processes or to comply with or as required by any applicable law, governmental or regulatory requirements of any relevant jurisdiction, including, without limitation, meeting the requirements to make disclosure under the requirements of any law binding on Cartsini or on its related corporations or affiliates;</span></p>
                                    <p><span>●</span><span>&nbsp;&nbsp;</span><span>to produce statistics and research for internal and statutory reporting and/or record-keeping requirements;</span></p>
                                        <p><span>●</span><span>&nbsp;&nbsp;</span><span>to carry out due diligence or other screening activities (including, without limitation, background checks) in accordance with legal or regulatory obligations or our risk management procedures that may be required by law or that may have been put in place by us;</span></p>
                                            <p><span>●</span><span>&nbsp;&nbsp;</span><span>to audit our Site; to prevent or investigate any fraud, unlawful activity, omission or misconduct, whether relating to your use of the Site or any other matter arising from your relationship with us, and whether or not there is any suspicion of the aforementioned;</span></p>
                                                <p><span>●</span><span>&nbsp;&nbsp;</span><span>to store, host, back up (whether for disaster recovery or otherwise) of your personal data, whether within or outside of your jurisdiction; and/or</span></p>
                                                    <p><span>●</span><span>&nbsp;&nbsp;</span><span>&nbsp;Any other purposes which we notify you of at the time of obtaining your consent. (collectively, the&nbsp;</span>
                                                        <span>“</span><span>Purposes</span><span>”</span><span>).</span></p>
                                                            <p><span>&nbsp;</span></p>
                                                            <ol start="2" type="1">
                                                                <li><span>As the purposes for which we will/may collect, use, disclose or process your personal data depend on the circumstances at hand, such purpose may not appear above. However, we will notify you of such other purpose at the time of obtaining your consent, unless processing of the applicable data without your consent is permitted by the Privacy Laws.</span></li>
                                                            </ol>
                                                            <p><span>&nbsp;</span></p>
                                                            <p><span><b>VII. HOW DOES CARTSINI PROTECT CUSTOMER INFORMATION?</b></span></p>
                                                            <p><span>&nbsp;</span></p>
                                                            <ol type="1">
                                                                <li><span>We implement a variety of security measures to ensure the security of your personal data on our systems. User personal data is contained behind secured networks and is only accessible by a limited number of employees who have special access rights to such systems. We will retain personal data in accordance with the Privacy Laws and/or other applicable laws. That is, we will destroy or anonymize your personal data when we have reasonably determined that (i) the purpose for which that personal data was collected is no longer being served by the retention of such personal data; (ii) retention is no longer necessary for any legal or business purposes. If you cease using the Site, or your permission to access or use the Site is terminated, we may continue storing, using and/or disclosing your personal data in accordance with this Privacy Policy and our obligations under the Privacy Laws. Subject to applicable law, we may securely dispose of your personal data without prior notice to you.</span></li>
                                                            </ol>
                                                            <p><span>&nbsp;</span></p>
                                                            <p><span><b>VIII. DOES CARTSINI DISCLOSE THE INFORMATION IT COLLECTS FROM ITS VISITORS TO OUTSIDE PARTIES?</b></span><br><span>&nbsp;</span></p>
                                                            <ol type="1">
                                                                <li><span>In conducting our business, we will/may need to disclose your personal data to our third-party service providers, agents and/or our affiliates or related corporations, and/or other third parties, whether sited in Singapore or outside of Singapore, for one or more of the above-stated Purposes. Such third-party service providers, agents and/or affiliates or related corporations and/or other third parties would be processing your personal data either on our behalf or otherwise, for one or more of the above-stated Purposes. Such third parties include, without limitation:</span></li>
                                                                </ol>
                                                                <p><span>&nbsp;</span></p>
                                                                <p><span>●</span><span>&nbsp;&nbsp;</span><span>Our subsidiaries, affiliates and related corporations;</span></p>
                                                                <p><span>●</span><span>&nbsp;&nbsp;</span><span>Contractors, agents, service providers and other third parties we use to support our business. These include but are not limited to those which provide administrative or other services to us such as mailing houses, telecommunication companies, information technology companies and data centres; and</span></p>
                                                                <p><span>●</span><span>&nbsp;&nbsp;</span><span>Third parties to whom disclosure by us is for one or more of the Purposes and such third parties would in turn be collecting and processing your personal data for one or more of the Purposes</span></p>
                                                                    <p><span>&nbsp;</span></p>
                                                                        <ol start="2" type="1">
                                                                            <li><span>This may require, among other things, for us to share statistical and demographic information about you and your use of the Site. This would not include anything that could be used to identify you specifically or to discover individual information about you.</span></li>
                                                                        </ol>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <ol start="3" type="1">
                                                                            <li><span>For the avoidance of doubt, in the event that Privacy Laws or other applicable laws permit an organisation such as us to collect, use or disclose your personal data without your consent, such permission granted by the laws shall continue to apply.</span></li>
                                                                        </ol>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <ol start="4" type="1">
                                                                            <li><span>Third parties may unlawfully intercept, or access personal data transmitted to or contained on the Site, technologies may malfunction or not work as anticipated, or someone might access, abuse or misuse information through no fault of ours. We will nevertheless deploy reasonable security arrangements to protect your personal data as required by the Privacy Laws; however, there can inevitably be no guarantee of absolute security such as but not limited to when unauthorised disclosure arises from malicious and sophisticated hacking by malcontents through no fault of ours.</span></li>
                                                                        </ol>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <p><span><b>IX. INFORMATION ON CHILDREN</b></span></p>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <ol type="1">
                                                                            <li><span>The Site is not intended for children under the age of 10. We do not knowingly collect or maintain any personal data or non-personally-identifiable information from anyone under the age of 10 nor is any part of our Site directed to children under the age of 10. We will remove and/or delete any personal data we believe was submitted by any child under the age of 10.</span></li>
                                                                        </ol>
                                                                        <p><br><span><b>X. INFORMATION COLLECTED BY THIRD PARTIES</b></span></p>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <ol type="1">
                                                                            <li><span>The Site uses Google Analytics, a web analytics service provided by Google, Inc. ("Google"). Google Analytics uses cookies, which are text files placed on your device, to help the website analyse how users use the Site. The information generated by the cookie about your use of the Site (including your IP address) will be transmitted to and stored by Google on servers in the United States. Google will use this information for the purpose of evaluating your use of the Site, compiling reports on website activity for website operators and providing other services relating to website activity and Internet usage. Google may also transfer this information to third parties where required to do so by law, or where such third parties process the information on Google's behalf. Google will not associate your IP address with any other data held by Google.</span></li>
                                                                        </ol>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <p><span><b>XI. DISCLAIMER REGARDING SECURITY AND THIRD-PARTY SITES</b></span></p>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <ol type="1">
                                                                            <li><span>WE DO NOT GUARANTEE THE SECURITY OF PERSONAL DATA AND/OR OTHER INFORMATION THAT YOU PROVIDE ON THIRD PARTY SITES. We do implement a variety of security measures to maintain the safety of your personal data that is in our possession or under our control. Your personal data is contained behind secured networks and is only accessible by a limited number of persons who have special access rights to such systems and are required to keep the personal data confidential. When you access your personal data, we offer the use of a secure server. All personal data or sensitive information you supply is encrypted into our databases to be only accessed as stated above.</span></li>
                                                                        </ol>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <ol start="2" type="1">
                                                                            <li><span>In an attempt to provide you with increased value, we may choose various third-party websites to link to, and frame within the Site. These linked sites have separate and independent privacy policies as well as security arrangements. Even if the third party is affiliated with us, we have no control over these linked sites, each of which has separate privacy and data collection practices independent of us. Data collected by such third-party web sites (even if offered on or through our Site) may not be received by us.</span></li>
                                                                        </ol>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <ol start="3" type="1">
                                                                            <li><span>We therefore have no responsibility or liability for the content, security arrangements (or lack thereof) and activities of these linked sites. These linked sites are only for your convenience and you therefore access them at your own risk. Nonetheless, we seek to protect the integrity of our Site and the links placed upon each of them and therefore welcome any feedback about these linked sites (including, without limitation, if a specific link does not work).</span></li>
                                                                        </ol>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <p><span><b>XII. WILL CARTSINI TRANSFER YOUR INFORMATION OVERSEAS?</b></span></p>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <ol type="1">
                                                                            <li><span>Your personal data and/or information may be transferred to, stored or processed outside of your country. In most cases, your personal data will be processed in Malaysia, where our servers are located and our central database is operated. Cartsini will only transfer your information overseas in accordance&nbsp;</span>
                                                                                <span>to&nbsp;</span><span>Privacy Laws.</span></li>
                                                                        </ol>
                                                                        <p><span>&nbsp;</span></p>
                                                                        <p><span><b>XIII. HOW CAN YOU WITHDRAW CONSENT, REQUEST ACCESS TO OR CORRECT INFORMATION YOU HAVE PROVIDED TO US?</b></span><br><span>&nbsp;</span></p>
                                                                        <ol type="1">
                                                                            <li><span>Withdrawing Consent</span></li>
                                                                            </ol>
                                                                            <p><span>&nbsp;</span></p>
                                                                            <p><span>1.1.</span><span>You may withdraw your consent for the collection, use and/or disclosure of your personal data in our possession or under our control by sending an email to our Personal Data Protection Officer at dpo@</span>
                                                                                <span>app.e-dagang.asia</span><span>. &nbsp;However, your withdrawal of consent may mean that we will not be able to continue assessing your application as well as any information provided by you to us.</span></p>
                                                                            <p><span>&nbsp;</span></p>
                                                                                <ol start="2" type="1">
                                                                                    <li><span>Requesting Access and/or Correction of Personal Data</span></li>
                                                                                </ol>
                                                                                <p><span>&nbsp;</span></p>
                                                                                <p><span>2.1.</span><span>You may request to access and/or correct your personal data currently in our possession or control by submitting a written request to us. We will need enough information from you in order to ascertain your identity as well as the nature of your request so as to be able to deal with your request. Hence, please submit your written request by sending an email to our Personal Data Protection Officer at dpo@app.e-dagang.asia</span>
                                                                                    <a href="mailto:dpo@shopee.com"></a>
                                                                                </p>
                                                                                <p><span>&nbsp;</span></p>
                                                                                <p><span>2.2&nbsp;</span><span>We may charge you a reasonable fee for the handling and processing of your requests to access your personal data. If we so choose to charge, we will provide you with a written estimate of the fee we will be charging. Please note that we are not required to respond to or deal with your access request unless you have agreed to pay the fee.</span></p>
                                                                                <p><span>&nbsp;</span></p>
                                                                                    <p><span>2.3.</span><span>We reserve the right to refuse to correct your personal data in accordance with the provisions as set out in Privacy Laws, where they require and/or entitle an organisation to refuse to correct personal data in stated circumstances.</span></p>
                                                                                    
                                                                                        <p><span><b>XIV. QUESTIONS, CONCERNS OR COMPLAINTS? CONTACT US</b></span></p>
                                                                                        <p><span>&nbsp;</span></p>
                                                                                        <ol type="1">
                                                                                            <li><span>If you have any questions or concerns about our privacy practices, we welcome you to contact us by e-mail:</span><span>&nbsp;dpo@app.e-dagang.asia</span>
                                                                                                <a href="mailto:dpo@shopee.com"></a><span></span></li>
                                                                                        </ol><p><span>&nbsp;</span></p><br><br>""",
            //Optional parameters:
            defaultTextStyle: TextStyle(fontSize: 15.0, fontFamily: "Quicksand", fontWeight: FontWeight.w500,),
            //padding: EdgeInsets.all(4.0),
            linkStyle: const TextStyle(
              color: Colors.redAccent,
              decorationColor: Colors.redAccent,
              decoration: TextDecoration.underline,
            ),
            onLinkTap: (url) {
              print("Opening $url...");
            },
            onImageTap: (src) {
              print(src);
            },
            //Must have useRichText set to false for this to work
            customRender: (node, children) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "custom_tag":
                    return Column(children: children);
                }
              }
              return null;
            },
            customTextAlign: (dom.Node node) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "p":
                    return TextAlign.justify;
                }
              }
              return null;
            },
            customTextStyle: (dom.Node node, TextStyle baseStyle) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "p":
                    return baseStyle.merge(TextStyle(height: 1, fontSize: 13));
                }
              }
              return baseStyle;
            },
          ),
        ),
      ),
    );
  }
}

Widget _normalText(String text) {
  return Text(text);
}

Widget _headingText(String text) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
  );
}
