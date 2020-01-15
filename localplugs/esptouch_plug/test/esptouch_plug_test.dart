import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:esptouch_plug/esptouch_plug.dart';

void main() {
  const MethodChannel channel = MethodChannel('esptouch_plug');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

//  test('getPlatformVersion', () async {
//    expect(await EsptouchPlug.platformVersion, '42');
//  });
}
