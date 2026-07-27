
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^KDDeviceInfoCompletionHandler)(NSDictionary *deviceInfo);


@interface KDSustainManager : NSObject

/// new 1.0.0
- (void)KDUploadInfoCompletion:(KDDeviceInfoCompletionHandler)completion;
/// old
- (NSDictionary<NSString *, NSString *> *)KDSustainDeviceInfos;

- (NSString *)KDBarnacleUABeach:(NSString *)rude;
- (NSString *)KDSubsoilSurvey;
- (NSString *)KDTonightForeman;
/// galaxy -> name, nebula -> time, moon -> phone
- (NSArray<NSDictionary<NSString *, id> *> *)KDGetBooks;

@end

NS_ASSUME_NONNULL_END
