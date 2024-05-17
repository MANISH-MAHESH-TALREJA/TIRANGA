package net.manish.pokemon;


import android.os.Build;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Field;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class AndroidVersionPlugin implements FlutterPlugin, MethodCallHandler {
    private static final String CHANNEL = "net.manish.pokemon/version";

    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), CHANNEL);
        channel.setMethodCallHandler(this);
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(new AndroidVersionPlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getAndroidVersion")) {
            JSONObject obj = new JSONObject();

            try {
                int sdk_int = Build.VERSION.SDK_INT;

                obj.put("release", Build.VERSION.RELEASE);
                obj.put("code", sdk_int);
                obj.put("name", getVersionName(sdk_int));

                @SuppressWarnings("unchecked")
                Map<String, Object> map = new Gson().fromJson(obj.toString(), Map.class);

                result.success(map);
            } catch (JSONException e) {
                e.printStackTrace();
                result.notImplemented();
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private String getVersionName(int sdkInt) {
        try {
            Field[] fields = Build.VERSION_CODES.class.getFields();
            String codeName = "UNKNOWN";
            for (Field field : fields) {
                try {
                    if (field.getInt(Build.VERSION_CODES.class) == sdkInt) {
                        codeName = field.getName();
                        break;
                    }
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
            }

            return codeName;
        } catch (Exception e) {
            return null;
        }
    }
}
