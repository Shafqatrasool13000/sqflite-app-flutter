import 'dart:async';

void main() {
  checkFile();
}

checkFile() {
  print('Strat');
  Future<String> showMessage = downloadAFile();
  showMessage.then((value) => print(value));
  print('End');
}

Future<String> downloadAFile() {
  Future<String> message = Future.delayed(Duration(seconds: 6), () {
    return 'My Text Message';
  });
  return message;
}
