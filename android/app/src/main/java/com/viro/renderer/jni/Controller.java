/**
 * Copyright © 2016 Viro Media. All rights reserved.
 */
package com.viro.renderer.jni;

/**
 * Java JNI wrapper for linking the following classes below across the bridge.
 *
 * Android Java Object  : com.viromedia.bridge.view.Controller.java
 * Java JNI Wrapper     : com.viro.renderer.ControllerJni.java
 * Cpp JNI wrapper      : Controller_JNI.cpp
 * Cpp Object           : VROInputPresenter
 */
public class Controller {
    private ViroContext mViroContext;
    public Controller(ViroContext viroContext) {
        mViroContext = viroContext;
    }

    public void setEventDelegate(EventDelegate delegate) {
        nativeSetEventDelegate(mViroContext.mNativeRef, delegate.mNativeRef);
    }

    public void setReticleVisibility(boolean visible) {
        nativeEnableReticle(mViroContext.mNativeRef, visible);
    }

    public void setControllerVisibility(boolean visible) {
        nativeEnableController(mViroContext.mNativeRef, visible);
    }

    public void getControllerForwardVectorAsync(ControllerJniCallback callback){
        nativeGetControllerForwardVectorAsync(mViroContext.mNativeRef, callback);
    }

    private native void nativeSetEventDelegate(long contextRef, long delegateRef);
    private native void nativeEnableReticle(long contextRef, boolean enabled);
    private native void nativeEnableController(long contextRef, boolean enabled);
    private native void nativeGetControllerForwardVectorAsync(long renderContextRef,
                                                              ControllerJniCallback callback);

    public interface ControllerJniCallback{
        void onGetForwardVector(float x, float y, float z);
    }
}