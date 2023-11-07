import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptString {
  String skey = 'az1dr576yxmbxx902yrlkq65zxbv00s7';
  String siv = '1234561234567890';
  final key = encrypt.Key.fromUtf8("az1dr576yxmbxx902yrlkq65zxbv00s7");
  final iv = encrypt.IV.fromUtf8("1234561234567890");
  late final encrypt.Encrypter encrypter;

  EncryptString() {
    encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  }

  String encryptar(String text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  String desencryptar(String text) {
    final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(text), iv: iv);
    return decrypted;
  }

}
