// import 'dart:math';
// // 
// getPasswordStrength(String password){
// if(password.isEmpty) return 0;
// double pFraction;

// if(RegExp(r'^[a-zA-Z0-9]*$').hasMatch(password)){
//   pFraction = 0.8;
//   } else if (RegExp(r'^[a-zA-Z0-9]*$').hasMatch (password)) {
//      pFraction= 1.5;

// } else if (RegExp(r'^[a-z]*$').hasMatch(password)) {

// pFraction= 1.0;

// } else if (RegExp(r'^[a-zA-Z]*$').hasMatch(password)) {

// pFraction=1.3;

// } else if (RegExp(r'^[a-z\-_!?]*$').hasMatch(password)) {
//    pFraction= 1.3;

// } else if (RegExp(r'^[a-z0-9]*$').hasMatch (password)) {
  
//    pFraction =1.2;}else{

// pFraction = 1.8;

// }

// var logF = (double x) { 
//   return 1.0 /(1.0 + exp(-x));
// };

// var logC = (double x) { return logF((x/2.0)- 4.0);};

// pstrength =logC(password.length* pFraction);
//  notifyListeners();
// }

