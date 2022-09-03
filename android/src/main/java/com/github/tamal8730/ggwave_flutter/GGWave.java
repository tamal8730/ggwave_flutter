package com.github.tamal8730.ggwave_flutter;

import android.util.Log;


public class GGWave {

    private CapturingThread mCapturingThread;
    private PlaybackThread mPlaybackThread;
    private MessageReceivedListener onMessageReceivedListener;
    private PlaybackCompleteListener onPlaybackCompleteListener;

    enum CaptureStatus{
        CAPTURING, NOT_CAPTURING
    }

    interface AudioPlaybackCallback{
        void onPlaybackStart();
        void onPlaybackStop();
    }

    interface MessageReceivedListener{
        void onMessageReceived(String message);
    }

    interface PlaybackCompleteListener{
        void onPlaybackComplete();
    }


    static {
        System.loadLibrary("test-cpp");
    }

    GGWave(){
        initNative();
    }

    void init(){
        mCapturingThread = new CapturingThread(this::processCaptureData);
    }

    // Native interface:
    private native void initNative();
    private native void processCaptureData(short[] data);
    private native void sendMessage(String message);

    // Native callbacks:
    private void onNativeReceivedMessage(byte[] c_message) {
        String message = new String(c_message);
        Log.v("ggwave", "Received message: " + message);
        if(onMessageReceivedListener!=null){
            onMessageReceivedListener.onMessageReceived(message);
        }
    }

    private void onNativeMessageEncoded(short[] c_message) {
        Log.v("ggwave", "Playing encoded message ..");

        mPlaybackThread = new PlaybackThread(c_message, new PlaybackListener() {
            @Override
            public void onProgress(int progress) {
                // todo : progress updates
            }
            @Override
            public void onCompletion() {
                mPlaybackThread.stopPlayback();
                if(onPlaybackCompleteListener!=null){
                    onPlaybackCompleteListener.onPlaybackComplete();
                }
            }
        });
    }

    public void setOnMessageReceivedListener(MessageReceivedListener onMessageReceivedListener){
        this.onMessageReceivedListener = onMessageReceivedListener;
    }

    public void setOnPlaybackCompleteListener(PlaybackCompleteListener onPlaybackCompleteListener){
        this.onPlaybackCompleteListener = onPlaybackCompleteListener;
    }

    private void startAudioCapturingSafe() {
        mCapturingThread.startCapturing();
    }

    public CaptureStatus toggleCapture(){
        if (!mCapturingThread.capturing()) {
            startAudioCapturingSafe();
            return CaptureStatus.CAPTURING;
        } else {
            mCapturingThread.stopCapturing();
            return CaptureStatus.NOT_CAPTURING;
        }
    }

    public void togglePlayback(String message, AudioPlaybackCallback audioPlaybackCallback){

        if (mPlaybackThread == null || !mPlaybackThread.playing()) {
            sendMessage(message);
            mPlaybackThread.startPlayback();
            audioPlaybackCallback.onPlaybackStart();
        } else {
            mPlaybackThread.stopPlayback();
            audioPlaybackCallback.onPlaybackStop();
        }

    }

}

interface PlaybackListener {
    void onProgress(int progress);
    void onCompletion();
}

interface AudioDataReceivedListener {
    void onAudioDataReceived(short[] data);
}