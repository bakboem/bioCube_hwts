package com.example.hwst
import com.example.hwst.PassKitService
import com.smavis.lib.TokenProcess
import com.smavis.lib.util.StringUtils
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
     var token = ""
     if (!(TokenProcess.gMobilepassToken == null || TokenProcess.gMobilepassToken.isEmpty())) {
      token =
       StringUtils.convertHexToString(StringUtils.hexStringFromByteArray(TokenProcess.gMobilepassToken))
     }
     result.success(token)
    } else if (call.method == "deleteToken") {
     val resMap = passKit.tokenProcess!!.deleteToken()
     val isDeleted = resMap["data"] as Boolean
     if (isDeleted)
      result.success("deleted") else result.success("faild")
    } else if (call.method == "saveToken") {
     val resMap = passKit. tokenProcess!!.putToken(
      call.arguments as String,
      1000000
     )
     val isSaved = resMap["data"] as Boolean
     result.success(isSaved)
    } else if (call.method == "updateToken") {
     val deleteResMap = passKit.tokenProcess!!.deleteToken()
     val isDeleted = deleteResMap["data"] as Boolean
     var isSaved = false
     if (isDeleted) {
      val saveResMap = passKit.tokenProcess!!.putToken(
       call.arguments as String,
       1000000
      )
      isSaved = saveResMap["data"] as Boolean

     }
     result.success(isDeleted && isSaved)
    } else if (call.method == "startBle") {
     passKit.bleScanningStart()
     result.success("success")
    } else if (call.method == "startNfc") {
    passKit. nfcScanningStart()
     result.success("success")
    } else if (call.method == "dispose") {
   passKit.  stopListen()
     result.success("success")
    } else if (call.method == "isNfcOk") {
     result.success("success")
    } else if (call.method == "setRssi") {
    passKit. rssiFromUserSettings = call.arguments as String
     result.success("success")
    } else {
     result.notImplemented()
    }
   }

  channel.setMethodCallHandler(handler)


 }





}

