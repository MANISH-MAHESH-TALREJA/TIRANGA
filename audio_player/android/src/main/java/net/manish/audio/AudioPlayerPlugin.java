package net.manish.audio;

import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Build;
import android.os.Handler;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * Modernized AudioPlayerPlugin
 * Compatible with Flutter Embedding v2 (Flutter 3.0+)
 * Handles basic audio playback using Android MediaPlayer
 */
public class AudioPlayerPlugin implements FlutterPlugin, MethodCallHandler {

  private static final String CHANNEL_ID = "net.manish.audio/audio";

  private MethodChannel channel;
  private AudioManager audioManager;
  private final Handler handler = new Handler();
  private MediaPlayer mediaPlayer;
  private Context context;

  // -------------------- Plugin Lifecycle --------------------
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    initInstance(binding.getBinaryMessenger(), binding.getApplicationContext());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    cleanup();
  }

  private void initInstance(BinaryMessenger messenger, Context ctx) {
    this.context = ctx;
    channel = new MethodChannel(messenger, CHANNEL_ID);
    channel.setMethodCallHandler(this);
    audioManager = (AudioManager) ctx.getSystemService(Context.AUDIO_SERVICE);
  }

  private void cleanup() {
    handler.removeCallbacks(sendData);
    if (mediaPlayer != null) {
      try {
        mediaPlayer.stop();
        mediaPlayer.release();
      } catch (Exception ignored) {}
      mediaPlayer = null;
    }
    if (channel != null) {
      channel.setMethodCallHandler(null);
      channel = null;
    }
    audioManager = null;
    context = null;
  }

  // -------------------- Method Calls from Flutter --------------------
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "play":
        String url = Objects.requireNonNull(call.argument("url"), "URL cannot be null").toString();
        play(url);
        result.success(null);
        break;

      case "pause":
        pause();
        result.success(null);
        break;

      case "stop":
        stop();
        result.success(null);
        break;

      case "seek":
        Double position = call.argument("position");
        if (position != null) seek(position);
        result.success(null);
        break;

      case "mute":
        Boolean muted = call.argument("muted");
        if (muted != null) mute(muted);
        result.success(null);
        break;

      default:
        result.notImplemented();
    }
  }

  // -------------------- Core Audio Functions --------------------
  private void play(String url) {
    if (mediaPlayer == null) {
      mediaPlayer = new MediaPlayer();
      mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);

      try {
        mediaPlayer.setDataSource(url);
        mediaPlayer.prepareAsync();
      } catch (IOException e) {
        Log.e(CHANNEL_ID, "Invalid DataSource: " + e.getMessage());
        channel.invokeMethod("audio.onError", "Invalid DataSource");
        return;
      }

      mediaPlayer.setOnPreparedListener(mp -> {
        mediaPlayer.start();
        channel.invokeMethod("audio.onStart", mediaPlayer.getDuration());
        handler.post(sendData);
      });

      mediaPlayer.setOnCompletionListener(mp -> {
        stop();
        channel.invokeMethod("audio.onComplete", null);
      });

      mediaPlayer.setOnErrorListener((mp, what, extra) -> {
        channel.invokeMethod("audio.onError",
                String.format("{\"what\":%d,\"extra\":%d}", what, extra));
        return true;
      });

    } else {
      mediaPlayer.start();
      channel.invokeMethod("audio.onStart", mediaPlayer.getDuration());
      handler.post(sendData);
    }
  }

  private void pause() {
    handler.removeCallbacks(sendData);
    if (mediaPlayer != null && mediaPlayer.isPlaying()) {
      mediaPlayer.pause();
      channel.invokeMethod("audio.onPause", true);
    }
  }

  private void stop() {
    handler.removeCallbacks(sendData);
    if (mediaPlayer != null) {
      try {
        mediaPlayer.stop();
        mediaPlayer.release();
      } catch (Exception ignored) {}
      mediaPlayer = null;
      channel.invokeMethod("audio.onStop", null);
    }
  }

  private void seek(double positionSeconds) {
    if (mediaPlayer != null) {
      int positionMs = (int) (positionSeconds * 1000);
      mediaPlayer.seekTo(positionMs);
    }
  }

  private void mute(boolean muted) {
    if (audioManager == null) return;
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      audioManager.adjustStreamVolume(
              AudioManager.STREAM_MUSIC,
              muted ? AudioManager.ADJUST_MUTE : AudioManager.ADJUST_UNMUTE,
              0
      );
    } else {
      audioManager.setStreamMute(AudioManager.STREAM_MUSIC, muted);
    }
  }

  // ------------
  //
  //
  // -------- Position Updater --------------------
  private final Runnable sendData = new Runnable() {
    @Override
    public void run() {
      try {
        if (mediaPlayer == null) return;
        if (!mediaPlayer.isPlaying()) {
          handler.removeCallbacks(this);
          return;
        }
        int time = mediaPlayer.getCurrentPosition();
        channel.invokeMethod("audio.onCurrentPosition", time);
        handler.postDelayed(this, 200);
      } catch (Exception e) {
        Log.w(CHANNEL_ID, "Error in handler: " + e.getMessage());
      }
    }
  };
}
