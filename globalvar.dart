library globals;
import 'package:cloud_firestore/cloud_firestore.dart';

bool isLoggedIn = false;
String current_user = '';
int Current_userID = 0;


Future<String?> getDocumentIdByUserId(String collectionPath, int userId) async {
  String? documentId;

  // Query Firestore for the document with userID equal to the specified value
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(collectionPath)
      .where('user_ID', isEqualTo: userId)
      .limit(1)
      .get();

  // If there is a matching document, retrieve its ID
  if (querySnapshot.docs.isNotEmpty) {
    documentId = querySnapshot.docs.first.id;
  }

  return documentId;
}

Future<int> getTotalDocumentCount(String collectionName) async {
  // Get a reference to the collection
  CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionName);

  // Get the documents in the collection
  QuerySnapshot querySnapshot = await collectionRef.get();

  // Return the total number of documents
  return querySnapshot.size;
}


Future<int?> getUserIdByName(String name) async {
  int? userId;

  // Query Firestore for the document with name equal to the specified value
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('User')
    .where('User_username', isEqualTo: name)
    .limit(1)
    .get();

  // If there is a matching document, retrieve its userID
  if (querySnapshot.docs.isNotEmpty) {
    // Parse the 'User_ID' field to an integer
    userId = int.tryParse(querySnapshot.docs.first.get('User_ID'));
  }

  // Return userId directly
  return userId;
}

Future<int?> getUserIdByEmail(String email) async {
  int? userId;

  // Query Firestore for the document with name equal to the specified value
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('User')
    .where('User_email', isEqualTo: email)
    .limit(1)
    .get();

  // If there is a matching document, retrieve its userID
  if (querySnapshot.docs.isNotEmpty) {
    // Parse the 'User_ID' field to an integer
    userId = int.tryParse(querySnapshot.docs.first.get('User_ID'));
  }

  // Return userId directly
  return userId;
}

Future<String?> getUsernameByID(String id) async {
  String? username;

  // Query Firestore for the document with name equal to the specified value
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('User')
    .where('User_ID', isEqualTo: id)
    .limit(1)
    .get();

  // If there is a matching document, retrieve its userID
  if (querySnapshot.docs.isNotEmpty) {
    // Parse the 'User_ID' field to an integer
    username = querySnapshot.docs.first.get('User_FullName');
  }

  // Return userId directly
  return username;
}

Future<String?> getLocationByID(String id) async {
  String? location;

  // Query Firestore for the document with name equal to the specified value
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('User')
    .where('User_ID', isEqualTo: id)
    .limit(1)
    .get();

  // If there is a matching document, retrieve its userID
  if (querySnapshot.docs.isNotEmpty) {
    // Parse the 'User_ID' field to an integer
    location = querySnapshot.docs.first.get('User_Location');
  }

  // Return userId directly
  return location;
}

Future<double?> getLatitudeByPostID(String id) async {
  double? Latitude;

  // Query Firestore for the document with name equal to the specified value
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('Post')
    .where('Post_ID', isEqualTo: id)
    .limit(1)
    .get();

  // If there is a matching document, retrieve its userID
  if (querySnapshot.docs.isNotEmpty) {
    // Parse the 'User_ID' field to an integer
    var temp = querySnapshot.docs.first.get('Latitude');
    Latitude = double.parse(temp);
  }

  // Return userId directly
  return Latitude;
}

Future<double?> getLongitudeByPostID(String id) async {
  double? Longtitude;

  // Query Firestore for the document with name equal to the specified value
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('Post')
    .where('Post_ID', isEqualTo: id)
    .limit(1)
    .get();

  // If there is a matching document, retrieve its userID
  if (querySnapshot.docs.isNotEmpty) {
    // Parse the 'User_ID' field to an integer
    var temp = querySnapshot.docs.first.get('Longtitude');
    Longtitude = double.parse(temp);
  }

  // Return userId directly
  return Longtitude;
}