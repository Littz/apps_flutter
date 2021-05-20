package com.digital.dagang.asia.edagang;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.view.ViewTreeObserver;
import android.view.WindowManager;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "app.edagang/cnannel";
    private static final String EVENTS = "app.edagang/events";
    private String startString;
    private BroadcastReceiver linksReceiver;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        Intent intent = getIntent();
        Uri data = intent.getData();

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("initialLink")) {
                        if (startString != null) {
                            result.success(startString);
                        }
                    }
                });

        if (data != null) {
            startString = data.toString();
            if(linksReceiver != null) {
                linksReceiver.onReceive(this.getApplicationContext(), intent);
            }
        }
    }

    @Override
    public void onNewIntent(Intent intent){
        super.onNewIntent(intent);
        if(intent.getAction() == android.content.Intent.ACTION_VIEW && linksReceiver != null) {
            linksReceiver.onReceive(this.getApplicationContext(), intent);
        }
    }

    private BroadcastReceiver createChangeReceiver(final EventChannel.EventSink events) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String dataString = intent.getDataString();

                if (dataString == null) {
                    events.error("UNAVAILABLE", "Link unavailable", null);
                } else {
                    events.success(dataString);
                }
                ;
            }
        };
    }
}
