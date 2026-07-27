#import "AddressBook/AddressBook.h"
#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDAddressBooksManager : NSObject

+ (NSArray<NSDictionary<NSString *, id> *> *)kd_getAddressBooks;

@end

NS_ASSUME_NONNULL_END
