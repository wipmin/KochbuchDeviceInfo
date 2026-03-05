

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface KDKeychainDeepen : NSObject

+ (instancetype)sharedInstance;

- (BOOL)KDKeychainSaveStr:(NSString *)string forKey:(NSString *)key;

- (nullable NSString *)KDKeychainReadStrForKey:(NSString *)key;

- (BOOL)KDKeychainDeleteStrForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
