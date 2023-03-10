//
// BCOVOUXComponent.h
// BrightcoveOUX
//
// Copyright (c) 2018 Brightcove, Inc. All rights reserved.
// License: https://accounts.brightcove.com/en/terms-and-conditions
//

#import <CoreMedia/CoreMedia.h>

#import <BrightcovePlayerSDK/BrightcovePlayerSDK.h>

@class BCOVOUXSessionProviderOptions;


NS_ASSUME_NONNULL_BEGIN

/**
 * Category methods added to BCOVPlayerSDKManager to support BCOVOUX.
 */
@interface BCOVPlayerSDKManager (BCOVOUXAdditions)

/**
 * Creates and returns a new playback controller.
 * The returned playback controller will be configured with a
 * BCOVOUX session provider.
 *
 * @return A new playback controller with the specified parameters.
 */
- (id<BCOVPlaybackController>)createOUXPlaybackController;

/**
 * Creates and returns a new OnceUX playback controller with the specified view
 * strategy. The returned playback controller will be configured with a
 * BCOVOUX session provider.
 *
 * @param strategy A view strategy that determines the view for the returned
 * playback controller.
 * @return A new playback controller with the specified parameters.
 */
- (id<BCOVPlaybackController>)createOUXPlaybackControllerWithViewStrategy:(nullable BCOVPlaybackControllerViewStrategy)strategy;

/**
 * Creates and returns a new BCOVOUX session provider with the specified
 * parameters.
 *
 * @param provider Optional upstream session provider.
 * @return A new BCOVOUXSessionProvider with the specified parameters.
 */
- (id<BCOVPlaybackSessionProvider>)createOUXSessionProviderWithUpstreamSessionProvider:(nullable id<BCOVPlaybackSessionProvider>)provider;


#if !TARGET_OS_TV
/**
 * Returns a view strategy that wraps the video view it is given with the
 * default playback controls.
 *
 * This view strategy is intended to provide a "stock" set of controls to aide
 * development, testing, and Brightcove code samples.
 *
 * *** DEPRECATED ***
 * Use the built-in BrightcovePlayerSDK's PlayerUI controls instead.
 * See the BrightcovePlayerSDK README for details.
 *
 * @return A view strategy block that wraps the video view with stock controls.
 */
- (BCOVPlaybackControllerViewStrategy)BCOVOUXdefaultControlsViewStrategy __attribute__((deprecated("Use the built-in BrightcovePlayerSDK's PlayerUI controls instead; see the BrightcovePlayerSDK README for details")));
#endif

@end


/**
 * OUX specific methods for the plugin context.
 */
@interface BCOVSessionProviderExtension (BCOVOUXAdditions)

/**
 * The value of this property indicates whether the receiver will ignore `oux_seekToTime:completionHandler:`
 * or not. The value is NO when either an ad is in progress or the receiver 
 * is still processing a previous messaging of `oux_seekToTime:completionHandler:`;
 * otherwise, the value of this property is YES. See also `oux_seekToTime:completionHandler:`.
 */
@property (nonatomic, readonly) BOOL oux_canSeek;

/**
 * This method implements the default seek behaviour for the BCOVOUX plugin.
 * This method must be called on the main thread. The receiver will ignore this
 * message when either an ad is in progress or a previous call to `oux_seekToTime:completionHandler:` 
 * is still being processed. See also `oux_canSeek`.
 *
 * The rules are as follows:
 *
 * - If seeking to end of the logical content time, the post rolls will play.
 * - If seeking over an ad sequence, the ad will play, and the playhead will resume
 * where the seek had attempted to seek to.
 * - If seeking over multiple ad sequences, only the last ad sequence will play.
 * - If seeking backwards, no ads will play.
 * - If seeking over ads that have already been played, they will play again.
 *
 * @param time The logical time to seek to
 * @param completionHandler The block to execute when the seek is performed
 */
- (void)oux_seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler;

/**
 * Returns the absolute time that corresponds to the specified content time.
 *
 * This method is used to obtain an absolute stream time that corresponds to
 * a time that is relative to the content. For example, the stream may include
 * a thirty-second ad sequence at `kCMTimeZero`, after which the content begins.
 * In this case, a content time of zero would correspond to an absolute stream
 * time of thirty seconds, and a content time of 2:00 would correspond to an
 * absolute stream time of 2:30 (assuming no other ad sequences occur before
 * that time).
 *
 * @param contentTime A time offset into the video content.
 * @return The absolute time that corresponds to the specified content time.
 */
- (CMTime)oux_absoluteTimeAtContentTime:(CMTime)contentTime;

/**
 * Returns the content time that corresponds to the specified absolute time.
 *
 * This method is used to obtain a content stream time that corresponds to a
 * time that is relative to the payload. For example, the stream may include
 * a thirty-second ad sequence at 1:30, after which the content begins.
 *
 * In this case, a content time of zero would correspond to an absolute stream
 * time of zero, a content time of 2:00 would correspond to an
 * absolute stream time of 2:30, and a content time of 1:30 would correspond to
 * any absolute stream time from 1:30 to 2:00.
 *
 * @param absoluteTime A time offset into the video payload.
 * @return The content time that corresponds to the specified absolute time.
 */
- (CMTime)oux_contentTimeAtAbsoluteTime:(CMTime)absoluteTime;

@end

NS_ASSUME_NONNULL_END
