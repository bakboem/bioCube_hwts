package com.example.hwst
import android.content.Context
import android.content.Intent
import android.nfc.NfcAdapter
import android.nfc.NfcManager
import com.smavis.lib.HceApduService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
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
     if (hasNfc(context)){
      passKit.sendMessage("Is Powered On")
     }else{
      passKit.sendMessage("Is None.")
     }


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

 fun hasNfc(context: Context?): Boolean {
  var bRet = false
  if (context == null) return bRet
  val manager: NfcManager = context.getSystemService(Context.NFC_SERVICE) as NfcManager
  val adapter: NfcAdapter = manager.getDefaultAdapter()
  if (adapter != null && adapter.isEnabled()) {
   bRet = true
  }
  return bRet
 }

}

