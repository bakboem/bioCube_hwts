package com.example.hwst
import com.example.hwst.PassKitService
import com.smavis.lib.TokenProcess
import com.smavis.lib.util.StringUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StringCodec
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
 override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
  GeneratedPluginRegistrant.registerWith(flutterEngine)
//  flutterEngine.plugins.add(PassKitService())

  var passKit =  PassKitService()
  passKit.init(context, flutterEngine.dartExecutor.binaryMessenger)
  var  channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "myapp/baseMethodChannel")
  val handler =
   MethodChannel.MethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
    if (call.method == "initState") {
      passKit.startListen()
      result.success("success")
    } else if (call.method == "getToken") {
      passKit.getToken ()
      result.success("success")
    } else if (call.method == "deleteToken") {
      passKit.deleteToken()
      result.success("success")
    } else if (call.method == "saveToken") {
     passKit.saveToken( call.arguments as String)
     result.success("success")
    } else if (call.method == "updateToken") {
     passKit.updateToken(call.arguments as String)
     result.success("success")
    } else if (call.method == "startBle") {
     passKit.bleScanningStart()
     result.success("success")
    } else if (call.method == "startNfc") {
     passKit.nfcScanningStart()
     result.success("success")
    } else if (call.method == "dispose") {
     passKit.stopListen()
     result.success("success")
    } else if (call.method == "isNfcOk") {
     passKit.sendMessage("bluOK?")
     result.success("success")
    } else if (call.method == "setRssi") {
     passKit.setRssi(call.arguments as String)
     result.success("success")
    } else {
     result.notImplemented()
    }
   }

  channel.setMethodCallHandler(handler)


 }





}

