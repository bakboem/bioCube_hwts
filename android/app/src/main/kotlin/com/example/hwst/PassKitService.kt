/*
 * Filename: /Users/bakbeom/work/bioCube/hwst/android/app/src/main/kotlin/com/example/hwst/PassKitService.kt
 * Path: /Users/bakbeom/work/bioCube/hwst/android/app/src/main/kotlin/com/example/hwst
 * Created Date: Thursday, February 23rd 2023, 4:57:54 pm
 * Author: bakbeom
 * 
 * Copyright (c) 2023 BioCube
 */



package com.example.hwst

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.le.*
import android.content.ContentValues.TAG
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.os.ParcelUuid
import android.util.Log
import android.widget.Toast
import com.smavis.lib.*
import com.smavis.lib.util.BluetoothUtils
import com.smavis.lib.util.StringUtils
import com.smavis.lib.util.UtilsCallBack
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StringCodec

@Suppress("CAST_NEVER_SUCCEEDS", "DEPRECATION")
class PassKitService :  UtilsCallBack{
    private val tag: String = PassKitService::class.java.simpleName
    private lateinit var  twoWay: BasicMessageChannel<String>
    private lateinit var  context: Context
    private var apduManager: HceApduManager? =null
    var tokenProcess: TokenProcess? =null
    private var mBluetoothAdapter: BluetoothAdapter? =null
    private var btScanner: BluetoothLeScanner? =null
    private var runnerHandler: Handler? = null
    private var settings: ScanSettings? = null
    private var filters: ArrayList<ScanFilter>?= null
    private var mGatt: BluetoothGatt?= null
    var rssiFromUserSettings : String ="-100"
    var token : String =""
    var deviceName : String = ""
    var  setSessionTimeVlue : Int = 60
    private var bMsdValue: ByteArray? = null


    fun startListen(){
        apduManager = HceApduManager.getInstance(context).setCallBack(this)
        tokenProcess = TokenProcess(context)
        runnerHandler = object : Handler(Looper.getMainLooper()){}
        mBluetoothAdapter =   BluetoothAdapter.getDefaultAdapter();
        btScanner = mBluetoothAdapter?.bluetoothLeScanner
        Log.d(tag, "==== btscanner ====" +"${ btScanner!=null}" )
        settings = ScanSettings.Builder()
            .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
            .build()
        filters = ArrayList()
        val scanFilter = ScanFilter.Builder()
            .setServiceUuid(ParcelUuid(Constants.SERVICE_UUID))
            .build()
        (filters as ArrayList<ScanFilter>).add(scanFilter)

    }

    fun stopListen(){
        // apduManager =null
        // tokenProcess = null
        // runnerHandler=null
        // mBluetoothAdapter = null
        // btScanner = null
        // settings= null
        // filters = null
    }
    public  fun saveToken (t:String){
        val resMap =  tokenProcess!!.putToken(
           t,
           setSessionTimeVlue*1000 // 최대치.,

        )
        val isSaved = resMap["data"] as Boolean
       if (isSaved){
           token =
               StringUtils.convertHexToString(StringUtils.hexStringFromByteArray(TokenProcess.gMobilepassToken))
           sendMessage("saveToken successful!~~ $token")
       }
    }
    public  fun getToken (){
        if (!(TokenProcess.gMobilepassToken == null || TokenProcess.gMobilepassToken.isEmpty())) {
            token =
                StringUtils.convertHexToString(StringUtils.hexStringFromByteArray(TokenProcess.gMobilepassToken))
        }
        sendMessage("token is $token")
    }
    public fun init( contextt: Context, binary:BinaryMessenger){
        context = contextt
        twoWay = BasicMessageChannel( binary,"myapp/twoWay",StringCodec.INSTANCE )
    }
    public fun updateToken (t:String){
        deleteToken()
        saveToken(t)
    }
    public fun disableToken(){
        tokenProcess?.setDisableToken()
    }
    public fun activeToken(){
        tokenProcess?.setActiveToken()
    }
    public fun deleteToken(){
       if(tokenProcess?.getToken()!=null && tokenProcess!!.getToken().isNotEmpty()){
        val resMap = tokenProcess!!.deleteToken()
        val isDeleted = resMap["data"] as Boolean
        if (isDeleted){
            sendMessage("deleteToken successful!")
        }
       }else{
           sendMessage("not token find!")
       }
    }
    public fun setRssi(r:String){
        rssiFromUserSettings = r
    }
    public fun  setSessionTime (s:Int){
        setSessionTimeVlue = s
    }
    public fun sendMessage(str:String){
           twoWay.send(str)
    }

    @SuppressLint("MissingPermission")
    fun bleScanningStop() {
        Log.d(tag, "==== stop Ble scanning ====")
        btScanner?.stopScan(leScanCallback)
        
    }
    @SuppressLint("MissingPermission")
    fun bleScanningStart() {
        sendMessage("bleStart")
        Log.d(tag, "==== start Ble scanning ====")
            btScanner!!.startScan(filters, settings, leScanCallback)
            runnerHandler?.postDelayed({
                bleScanningStop()
                sendMessage("Timeout")
            }, 5000)
    }
    fun nfcScanningStart(){
        val intent = Intent(
            context,
            HceApduService::class.java
        )
        context.startService(intent)
    }
    @SuppressLint("MissingPermission")
    private fun connectDevice(device: BluetoothDevice) {
        Log.d(tag, "Connecting to " + device.address)
        sendMessage("peripheral Ready")
        val gattClient = GattClient(this)
        mGatt = device.connectGatt(context, false, gattClient)
    }
    @SuppressLint("MissingPermission")
    private val leScanCallback: ScanCallback = object : ScanCallback() {
        override fun onBatchScanResults(results: List<ScanResult>) {
            Log.d(tag, "onBatchScanResults " + results.toString())
            super.onBatchScanResults(results)
        }
        override fun onScanResult(callbackType: Int, result: ScanResult) {
             deviceName=""
             deviceName = BluetoothUtils.getDeviceName(result)
            Log.i(tag,"find name : " + result.device.name)
            val rssi = BluetoothUtils.getRssi(result)
            val guideRssi: Int = rssiFromUserSettings.toInt()
            Log.d(tag,"[BLE][scan] device Name : $deviceName")
            Log.d(tag, "[BLE][scan] rssi : $rssi")
            if (BluetoothUtils.checkTMobilepassDevice(rssi, guideRssi, deviceName)) { //-45
                sendMessage("bleSuccess:$deviceName")
                bleScanningStop()
                bMsdValue = BluetoothUtils.getMsdValue(result)
                Log.d(tag, "[BLE][scan] MSD : " + StringUtils.hexStringFromByteArray(bMsdValue))
                Log.d(tag, "[BLE][scan] Token Value : " + StringUtils.hexStringFromByteArray(bMsdValue))
                runnerHandler!!.postDelayed({ connectDevice(result.device) }, 1)
            }
        }
    }


    // callback From com.smavis.lib.util.UtilsCallBack
    override fun onGetTerminalId(p0: String?): Boolean {
       var tid = StringUtils.convertHexToString(p0)
        Log.d(TAG, "onGetTerminalId $tid")
        sendMessage("nfcSuccess:$tid")
        // disableToken()
        return  true
    }

    override fun authenticateWithToken() {
        Log.d(TAG, "authenticateWithToken")
        val bleprocess = BleProcess.getInstance()
        var res = bleprocess.encryptToken(token.toByteArray(), bMsdValue) //jni
        if (res["data"] as Boolean) {
            Log.d(TAG, "encryptToken successful $token!")
            res = BleProcess.writeBleData(mGatt)
            val isCompleted = res["isCompleted"] as Boolean?
            Log.d(TAG, "isCompleted$isCompleted")
            if (res["data"] as Boolean) {
                Log.d(TAG, "success!???  ${res["data"] as Boolean}")
                Log.d(TAG, "InstanceToken:::  ${tokenProcess?.token}")

            } else {
                Log.d(TAG, "[BLE] write Data Fail[" + res["resultCode"].toString() + "]")
            }
        } else {
            Log.d(TAG, "[BLE] Encrypt Token Fail[" + res["resultCode"].toString() + "]")
        }
    }

    override fun authenticateWithTokenEnd() {
        val resMap = BleProcess.writeBleData(mGatt)
        val isCompleted = resMap["isCompleted"] as Boolean
        val sendSuccess = resMap["data"] as Boolean
        Log.i(tag,"SendSuccess!? $sendSuccess")
        if (isCompleted) {
            disconnectGattServer()

        } else if (!sendSuccess) {
            disconnectGattServer()
        }
        // disableToken()

    }

    @SuppressLint("MissingPermission")
    override fun disconnectGattServer() {
        if (mGatt!= null) {
            mGatt!!.disconnect()
            mGatt!!.close()
            Log.i(tag,"mGatt Closed! ")
        }
    }

    override fun processErrorCode(p0: MutableMap<String, Any>?) {
        Log.i(tag,"Error!? $p0")
    }
}