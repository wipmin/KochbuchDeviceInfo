

#import "KDKeychainDeepen.h"
#import <Security/Security.h>

static NSString *const kdService = @"com.deepen.service";
static NSString *const kdAccount = @"com.deepen.account";

@implementation KDKeychainDeepen

+ (instancetype)sharedInstance {
    static KDKeychainDeepen *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)KDKeychainSaveStr:(NSString *)string forKey:(NSString *)key {
    if (!string || !key) {
        return NO;
    }
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self saveData:data forKey:key];
}

- (nullable NSString *)KDKeychainReadStrForKey:(NSString *)key {
    NSData *data = [self readDataForKey:key];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (BOOL)KDKeychainDeleteStrForKey:(NSString *)key {
    if (!key) {
        return NO;
    }
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:kdService forKey:(__bridge id)kSecAttrService];
    [query setObject:kdAccount forKey:(__bridge id)kSecAttrAccount];
    [query setObject:key forKey:(__bridge id)kSecAttrGeneric];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    return (status == errSecSuccess || status == errSecItemNotFound);
}


- (BOOL)saveData:(NSData *)data forKey:(NSString *)key {
    if (!data || !key) {
        return NO;
    }
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:kdService forKey:(__bridge id)kSecAttrService];
    [query setObject:kdAccount forKey:(__bridge id)kSecAttrAccount];
    [query setObject:key forKey:(__bridge id)kSecAttrGeneric];
    
    SecItemDelete((__bridge CFDictionaryRef)query);
    
    [query setObject:data forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    
    return (status == errSecSuccess);
}

- (nullable NSData *)readDataForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:kdService forKey:(__bridge id)kSecAttrService];
    [query setObject:kdAccount forKey:(__bridge id)kSecAttrAccount];
    [query setObject:key forKey:(__bridge id)kSecAttrGeneric];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    if (status == errSecSuccess && result != NULL) {
        NSData *data = (__bridge_transfer NSData *)result;
        return data;
    }
    
    return nil;
}


@end
