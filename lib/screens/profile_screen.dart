import 'package:ev_spot_flutter/main.dart';
import 'package:ev_spot_flutter/screens/sign_in_screen.dart';
import 'package:ev_spot_flutter/utils/common.dart';
import 'package:ev_spot_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String dropDownValue = "Tesla Model X";

  List<String> listItem = [
    'Tesla Model X',
    'Porche Taycan',
    'MG ZS EV',
    'Mini Cooper SE',
    'Tata Nexon EV',
    'BMW i4'
  ];

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final userEmail = user.email;
      final response = await supabase
          .from('profile')
          .select()
          .eq('email', userEmail!)
          .single()
          ;

      if (response.isNotEmpty) {
        final data = response;
        setState(() {
          fullNameController.text = data['name'] as String? ?? '';
          phoneNumberController.text = data['phonenumber'] as String? ?? '';
          emailAddressController.text = userEmail;
          dropDownValue = data['cartype'] as String? ?? 'Tesla Model X';
        });
      } else {
        print('Error fetching profile: ${response}');
      }
    }
  }

  Future<void> _deleteUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final userEmail = user.email;
      final response = await supabase
          .from('profile')
          .delete()
          .eq('email', userEmail!)
          ;

      if (response.error == null) {
        Fluttertoast.showToast(
          msg: 'Profile deleted successfully',
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16,
          backgroundColor: appStore.isDarkMode
              ? Theme.of(context).colorScheme.surfaceVariant
              : Colors.black,
        );
        await supabase.auth.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      } else {
        print('Error deleting profile: ${response.error?.message}');
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Profile'),
        content: Text('Are you sure you want to delete your profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
              await _deleteUserProfile();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      Fluttertoast.showToast(
        msg: 'Profile deleted successfully',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16,
        backgroundColor: appStore.isDarkMode
            ? Theme.of(context).colorScheme.surfaceVariant
            : Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: appStore.isDarkMode ? Colors.black : Colors.white,
        statusBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back),
                            alignment: Alignment.topLeft,
                          ),
                          SizedBox(height: 10),
                          Text('Profile', style: boldTextStyle(fontSize: 22)),
                        ],
                      ),
                      Align(
                        heightFactor: 1.2,
                        widthFactor: 1.2,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Image.asset(person_image,
                                  height: 80, width: 80, fit: BoxFit.cover),
                            ),
                            Positioned(
                              bottom: -10,
                              right: -10,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.camera_alt_rounded,
                                    color: Colors.white, size: 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Text('Full Name', style: primaryTextStyle()),
                  SizedBox(height: 10),
                  TextField(
                    controller: fullNameController,
                    decoration:
                        inputDecoration(context, hintText: 'Enter Full Name'),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: Theme.of(context).colorScheme.primary,
                    cursorWidth: 1,
                  ),
                  SizedBox(height: 20),
                  Text('Phone Number', style: primaryTextStyle()),
                  SizedBox(height: 10),
                  TextField(
                    controller: phoneNumberController,
                    decoration: inputDecoration(context,
                        hintText: 'Enter Phone Number'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    cursorColor: Theme.of(context).colorScheme.primary,
                    cursorWidth: 1,
                  ),
                  SizedBox(height: 20),
                  Text('Email Address', style: primaryTextStyle()),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailAddressController,
                    decoration: inputDecoration(context,
                        hintText: 'Enter Email Address'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    cursorColor: Theme.of(context).colorScheme.primary,
                    cursorWidth: 1,
                    enabled: false,
                  ),
                  SizedBox(height: 20),
                  Text('Your EV Car', style: primaryTextStyle()),
                  SizedBox(height: 10),
                  Container(
                    height: 60,
                    child: DropdownButtonFormField(
                      value: dropDownValue,
                      isExpanded: true,
                      decoration: inputDecoration(context),
                      icon: Icon(Icons.keyboard_arrow_down),
                      onChanged: (String? value) {
                        setState(() {
                          dropDownValue = value!;
                        });
                      },
                      items: listItem.map((valueItem) {
                        return DropdownMenuItem(
                          child: Text(valueItem),
                          value: valueItem,
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        final user = supabase.auth.currentUser;
                        if (user != null) {
                          final fullName = fullNameController.text;
                          final phoneNumber = phoneNumberController.text;
                          final response = await supabase
                              .from('profile')
                              .update({
                                'name': fullName,
                                'phonenumber': phoneNumber,
                                'cartype': dropDownValue,
                              })
                              .eq('email', user.email as Object)
                              ;

                          if (newMethod(response) == null) {
                            Fluttertoast.showToast(
                              msg: 'Profile updated successfully',
                              gravity: ToastGravity.BOTTOM,
                              toastLength: Toast.LENGTH_SHORT,
                              fontSize: 16,
                              backgroundColor: appStore.isDarkMode
                                  ? Theme.of(context).colorScheme.surfaceVariant
                                  : Colors.black,
                            );
                          } else {
                            print(
                                'Error updating profile: ${response.error?.message}');
                          }
                        }
                      },
                      child: Text('Update',
                          style: primaryTextStyle(color: Colors.white)),
                      style: Theme.of(context).elevatedButtonTheme.style,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _showDeleteConfirmationDialog();
                      },
                      child: Text('Delete',
                          style: primaryTextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  newMethod(response) {}
}
