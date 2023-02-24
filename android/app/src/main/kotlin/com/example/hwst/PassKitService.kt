/*
 * Filename: /Users/bakbeom/work/bioCube/hwst/android/app/src/main/kotlin/com/example/hwst/PassKitService.kt
 * Path: /Users/bakbeom/work/bioCube/hwst/android/app/src/main/kotlin/com/example/hwst
 * Created Date: Thursday, February 23rd 2023, 4:57:54 pm
 * Author: bakbeom
 * 
 * Copyright (c) 2023 BioCube
 */



package com.example.hwst
import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothManager
import android.bluetooth.le.*
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import android.os.ParcelUuid
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat.getSystemService
import com.smavis.lib.*
import com.smavis.lib.util.BluetoothUtils
import com.smavis.lib.util.StringUtils
import com.smavis.lib.util.UtilsCallBack
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StringCodec
import  io.flutter.plugin.common.BinaryMessenger
@Suppress("CAST_NEVER_SUCCEEDS")
class PassKitService :  MethodChannel.MethodCallHandler,UtilsCallBack  {
    private val tag: String = PassKitService::class.java.simpleName
    private lateinit var channel : MethodChannel
    private lateinit var  twoWay: BasicMessageChannel<String>
    private lateinit var  context: Context

    private var apduManager: HceApduManager? =null
    private var tokenProcess: TokenProcess? =null
    private var mBluetoothAdapter: BluetoothAdapter? =null
    private var btScanner: BluetoothLeScanner? =null

    private var runnerHandler: Handler? = null
    private var settings: ScanSettings? = null
    private var filters: ArrayList<ScanFilter>?= null
    private var mGatt: BluetoothGatt?= null
    private var rssiFromUserSettings : String ="50"
    private var bMsdValue: ByteArray? = null

private  fun startListen(){
    channel.setMethodCallHandler(this)
    apduManager = HceApduManager.getInstance(context).setCallBack(this)
    tokenProcess = TokenProcess(context)
    runnerHandler = object : Handler(Looper.getMainLooper()){}
    (getSystemService(context, PassKitService::class.java) as BluetoothManager).also {
        mBluetoothAdapter = it.adapter
    }
    btScanner = mBluetoothAdapter?.bluetoothLeScanner
    settings = ScanSettings.Builder()
        .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
        .build()
    filters = ArrayList()
    val scanFilter = ScanFilter.Builder()
        .setServiceUuid(ParcelUuid(Constants.SERVICE_UUID))
        .build()
    (filters as ArrayList<ScanFilter>).add(scanFilter)
    channel.setMethodCallHandler(this)
    twoWay.setMessageHandler { message, reply ->Log.i(tag, "Received: $message")
        reply.reply("Hi from Android")  }
}
    private fun stopListen(){
        channel.setMethodCallHandler(null)
        twoWay.setMessageHandler(null)
        apduManager?.setCallBack(null)
        apduManager =null
        tokenProcess = null
        runnerHandler=null
        mBluetoothAdapter = null
        btScanner = null
        settings= null
        filters = null
        channel.setMethodCallHandler(null)
        twoWay.setMessageHandler(null)
    }

    public fun init( contextt: Context, binary:BinaryMessenger){
        context = contextt
        channel = MethodChannel(binary, "myapp/baseMethodChannel")
        twoWay = BasicMessageChannel( binary,"myapp/twoWay",StringCodec.INSTANCE )

    }

//    fun sendMessage(str:String){
//        twoWay.send(str) { reply ->
//            reply?.let { Log.i("MSG", it) }
//        }
//
//    }

    fun  checkPermission():Boolean{
        if (ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.BLUETOOTH_SCAN
            ) != PackageManager.PERMISSION_GRANTED
        )  return false
        return true
    }
    fun bleScanningStop() {
        Log.d(tag, "==== stop Ble scanning ====")
        if (checkPermission())
        btScanner?.stopScan(leScanCallback)
    }
    private fun bleScanningStart() {
        if (checkPermission())
        btScanner!!.startScan(filters, settings, leScanCallback)
        runnerHandler?.postDelayed({
            bleScanningStop()
        }, 5000)
    }
    private fun nfcScanningStart(){
        val intent = Intent(
            context,
            HceApduService::class.java
        )
      context.startService(intent)
    }
    private fun connectDevice(device: BluetoothDevice) {
        Log.d(tag, "Connecting to " + device.address)
        val gattClient = GattClient(this)
        if (checkPermission())
        mGatt = device.connectGatt(context, false, gattClient)
    }

    private val leScanCallback: ScanCallback = object : ScanCallback() {
        override fun onBatchScanResults(results: List<ScanResult>) {
            super.onBatchScanResults(results)
        }
        override fun onScanResult(callbackType: Int, result: ScanResult) {
            val devicename = BluetoothUtils.getDeviceName(result)
            if (checkPermission())
            Log.i(tag,"find name : " + result.device.name)
            val rssi = BluetoothUtils.getRssi(result)
            val guideRssi: Int = rssiFromUserSettings.toInt()
            Log.d(tag,"[BLE][scan] device Name : $devicename")
            Log.d(tag, "[BLE][scan] rssi : $rssi")
            if (BluetoothUtils.checkTMobilepassDevice(rssi, guideRssi, devicename)) { //-45
                bleScanningStop()
                bMsdValue = BluetoothUtils.getMsdValue(result)
                Log.d(tag, "[BLE][scan] MSD : " + StringUtils.hexStringFromByteArray(bMsdValue))
                Log.d(tag, "[BLE][scan] Token Value : " + StringUtils.hexStringFromByteArray(bMsdValue))
                runnerHandler!!.postDelayed({ connectDevice(result.device) }, 1)
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "initState") {
            startListen()
            result.success("success")
        } else if(call.method == "getToken"){
            var token = ""
            if (!(TokenProcess. gMobilepassToken == null || TokenProcess.gMobilepassToken.isEmpty())) {
                token =
                    StringUtils.convertHexToString(StringUtils.hexStringFromByteArray(TokenProcess.gMobilepassToken))
            }
            result.success(token)
        }
        else if(call.method == "deleteToken"){
            val resMap = tokenProcess!!.deleteToken()
            val isDeleted =resMap["data"] as Boolean
            if (isDeleted)
            result.success("deleted") else result.success("faild")
        }
        else if(call.method == "saveToken"){
            val resMap = tokenProcess!!.putToken(
               call.arguments as String,
              1000000
            )
            val isSaved = resMap["data"] as Boolean
            result.success(isSaved)
        }
        else if(call.method == "updateToken") {
            val deleteResMap = tokenProcess!!.deleteToken()
            val isDeleted =deleteResMap["data"] as Boolean
            var isSaved = false
            if (isDeleted){
                val saveResMap =  tokenProcess!!.putToken(
                    call.arguments as String,
                    1000000
                )
                isSaved = saveResMap["data"] as Boolean

            }
            result.success(isDeleted&& isSaved)
        }
        else if(call.method == "startBle") {
            bleScanningStart()
            result.success("success")
        } else if(call.method == "startNfc") {
            nfcScanningStart()
            result.success("success")
        } else if(call.method == "dispose") {
            stopListen()
            result.success("success")
        }
        else if(call.method == "isNfcOk") {
            result.success("success")
        }
        else if(call.method == "setRssi") {
            rssiFromUserSettings = call.arguments as String
            result.success(System.getProperty("http.agent"))
        }
        else  {
            result.notImplemented()
        }
    }

    // callback From com.smavis.lib.util.UtilsCallBack
    override fun onGetTerminalId(p0: String?): Boolean {
        println(p0)
        return true
    }

    override fun authenticateWithToken() {
    }

    override fun authenticateWithTokenEnd() {
        val resMap = BleProcess.writeBleData(mGatt)
        val isCompleted = resMap["isCompleted"] as Boolean
        val sendSuccess = resMap["data"] as Boolean
        if (isCompleted) {
            disconnectGattServer()
        } else if (!sendSuccess) {
            disconnectGattServer()
        }
    }

    override fun disconnectGattServer() {
        if (mGatt!= null) {
            if (checkPermission())
            mGatt!!.disconnect()
            mGatt!!.close()
        }
    }

    override fun processErrorCode(p0: MutableMap<String, Any>?) {
        TODO("Not yet implemented")
    }
}