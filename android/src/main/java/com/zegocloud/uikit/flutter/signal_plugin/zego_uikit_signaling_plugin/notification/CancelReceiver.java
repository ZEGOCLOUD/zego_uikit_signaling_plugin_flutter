package com.zegocloud.uikit.flutter.signal_plugin.zego_uikit_signaling_plugin.notification;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.zegocloud.uikit.flutter.signal_plugin.zego_uikit_signaling_plugin.Defines;

public class CancelReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Log.i("signaling plugin", "cancel receiver, Received broadcast " + intent.getAction());
        LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
    }
}
