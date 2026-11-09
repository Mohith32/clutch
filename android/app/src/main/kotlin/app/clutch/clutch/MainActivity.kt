package app.clutch.clutch

import android.app.NotificationManager
import android.app.StatusBarManager
import android.app.WallpaperManager
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.graphics.drawable.Icon
import android.os.Build
import androidx.activity.result.PickVisualMediaRequest
import java.io.File
import android.content.Intent
import android.graphics.BitmapFactory
import android.nfc.NdefMessage
import android.nfc.NdefRecord
import android.nfc.NfcAdapter
import android.nfc.tech.Ndef
import android.nfc.tech.NdefFormatable
import android.provider.ContactsContract
import android.view.WindowManager
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * FlutterFragmentActivity because local_auth needs a FragmentActivity.
 * The "clutch/native" channel covers what Flutter has no API for: setting the
 * lock-screen wallpaper, FLAG_SECURE, the system contact picker (no READ_CONTACTS
 * permission needed), opening a backup file, and writing NFC tags.
 */
class MainActivity : FlutterFragmentActivity() {
    private var pending: MethodChannel.Result? = null
    private var nfcResult: MethodChannel.Result? = null

    private val contactPicker =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { r ->
            val result = pending.also { pending = null } ?: return@registerForActivityResult
            val uri = r.data?.data ?: return@registerForActivityResult result.success(null)
            try {
                contentResolver.query(
                    uri,
                    arrayOf(
                        ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME,
                        ContactsContract.CommonDataKinds.Phone.NUMBER,
                    ),
                    null, null, null,
                )?.use { c ->
                    if (c.moveToFirst()) {
                        result.success(mapOf("name" to (c.getString(0) ?: ""), "phone" to (c.getString(1) ?: "")))
                    } else {
                        result.success(null)
                    }
                } ?: result.success(null)
            } catch (e: Exception) {
                result.error("contact", e.message, null)
            }
        }

    private val docPicker =
        registerForActivityResult(ActivityResultContracts.OpenDocument()) { uri ->
            val result = pending.also { pending = null } ?: return@registerForActivityResult
            if (uri == null) return@registerForActivityResult result.success(null)
            try {
                result.success(contentResolver.openInputStream(uri)?.bufferedReader()?.use { it.readText() })
            } catch (e: Exception) {
                result.error("open", e.message, null)
            }
        }

    private val imagePicker =
        registerForActivityResult(ActivityResultContracts.PickVisualMedia()) { uri ->
            val result = pending.also { pending = null } ?: return@registerForActivityResult
            if (uri == null) return@registerForActivityResult result.success(null)
            try {
                // New name each time so Flutter's image cache never shows a stale photo.
                filesDir.listFiles { f -> f.name.startsWith("wp_") }?.forEach { it.delete() }
                val out = File(filesDir, "wp_${System.currentTimeMillis()}.jpg")
                contentResolver.openInputStream(uri)?.use { input -> out.outputStream().use { input.copyTo(it) } }
                result.success(out.absolutePath)
            } catch (e: Exception) {
                result.error("image", e.message, null)
            }
        }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "clutch/native").setMethodCallHandler { call, result ->
            when (call.method) {
                "setLockWallpaper" -> setLockWallpaper(call.arguments as ByteArray, result)
                "setSecure" -> {
                    if (call.arguments == true) {
                        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    } else {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    }
                    result.success(null)
                }
                "pickContact" -> {
                    pending?.success(null)
                    pending = result
                    contactPicker.launch(Intent(Intent.ACTION_PICK, ContactsContract.CommonDataKinds.Phone.CONTENT_URI))
                }
                "openDocument" -> {
                    pending?.success(null)
                    pending = result
                    docPicker.launch(arrayOf("application/json", "text/plain", "application/octet-stream"))
                }
                "pickImage" -> {
                    pending?.success(null)
                    pending = result
                    imagePicker.launch(PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly))
                }
                "syncPass" -> {
                    // QR image for EmergencyActivity, the widget and the tile.
                    val png = call.arguments as ByteArray?
                    val file = File(filesDir, EmergencyActivity.FILE)
                    if (png != null) file.writeBytes(png) else file.delete()
                    SosWidgetProvider.refresh(this)
                    getSystemService(NotificationManager::class.java).cancel(7101) // older builds used a notification
                    result.success(null)
                }
                "pinWidget" -> {
                    val awm = AppWidgetManager.getInstance(this)
                    result.success(
                        awm.isRequestPinAppWidgetSupported &&
                            awm.requestPinAppWidget(ComponentName(this, SosWidgetProvider::class.java), null, null),
                    )
                }
                "addTile" -> {
                    if (Build.VERSION.SDK_INT >= 33) {
                        getSystemService(StatusBarManager::class.java).requestAddTileService(
                            ComponentName(this, SosTileService::class.java),
                            call.arguments as String,
                            Icon.createWithResource(this, R.drawable.ic_stat_clutch),
                            mainExecutor,
                        ) { code -> result.success(code) }
                    } else {
                        result.success(-1)
                    }
                }
                "nfcAvailable" -> result.success(NfcAdapter.getDefaultAdapter(this)?.isEnabled == true)
                "nfcWrite" -> startNfc(call.arguments as String, result)
                "nfcCancel" -> {
                    stopNfc()
                    nfcResult?.error("cancelled", null, null)
                    nfcResult = null
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun setLockWallpaper(png: ByteArray, result: MethodChannel.Result) {
        Thread {
            try {
                val bmp = BitmapFactory.decodeByteArray(png, 0, png.size)
                WallpaperManager.getInstance(this).setBitmap(bmp, null, true, WallpaperManager.FLAG_LOCK)
                runOnUiThread { result.success(true) }
            } catch (e: Exception) {
                runOnUiThread { result.error("wallpaper", e.message, null) }
            }
        }.start()
    }

    private fun startNfc(text: String, result: MethodChannel.Result) {
        val adapter = NfcAdapter.getDefaultAdapter(this)
            ?: return result.error("nfc", "This phone has no NFC", null)
        nfcResult?.error("cancelled", null, null)
        nfcResult = result
        val msg = NdefMessage(arrayOf(NdefRecord.createTextRecord("en", text)))
        val flags = NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_NFC_B or
            NfcAdapter.FLAG_READER_NFC_F or NfcAdapter.FLAG_READER_NFC_V
        adapter.enableReaderMode(this, { tag ->
            val error: String? = try {
                val ndef = Ndef.get(tag)
                if (ndef != null) {
                    ndef.use {
                        it.connect()
                        when {
                            !it.isWritable -> "Tag is read-only"
                            it.maxSize < msg.byteArrayLength -> "Tag is too small (${it.maxSize} bytes)"
                            else -> { it.writeNdefMessage(msg); null }
                        }
                    }
                } else {
                    NdefFormatable.get(tag)?.use { it.connect(); it.format(msg); null } ?: "Tag type not supported"
                }
            } catch (e: Exception) {
                e.message ?: "Write failed"
            }
            runOnUiThread {
                stopNfc()
                val r = nfcResult
                nfcResult = null
                if (error == null) r?.success(true) else r?.error("nfc", error, null)
            }
        }, flags, null)
    }

    private fun stopNfc() {
        NfcAdapter.getDefaultAdapter(this)?.disableReaderMode(this)
    }
}
