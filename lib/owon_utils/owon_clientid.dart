
import 'dart:math';

class OwonClientId {

 static String createClientID(String userName){
   String result ;
   if(userName.length<10){
     userName = userName +"0000000000";
   }

   String alphabet = '0123456789abcdefghijklmnopqrstuvwxyz';
   int constLength = 6;
   String sixRandom = '';
   for (var i = 0; i < constLength; i++) {
     sixRandom = sixRandom + alphabet[Random().nextInt(alphabet.length)];
   }

   var now = DateTime.now();
   Duration d = now.difference(DateTime(1970));
   String timeString = d.inSeconds.toRadixString(16);
   if(timeString.length <8){
     timeString = timeString +"00000000";
   }
   result = userName.substring(0,10) + sixRandom +timeString;

   return result;
 }




}