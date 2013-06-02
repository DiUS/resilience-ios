
#import "UITableViewCell+Form.h"
#import "UIColor+Resilience.h"

@implementation UITableViewCell (Form)

+ (UITableViewCell *)cellWithName:(NSString *)name andField:(UITextField *)field {
  UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
  tableViewCell.textLabel.text = name;
  field.frame = CGRectMake(110,12,230,30);
  field.textColor = [UIColor darkGreyTextColor];
  [tableViewCell.contentView addSubview:field];
  return tableViewCell;
}

@end