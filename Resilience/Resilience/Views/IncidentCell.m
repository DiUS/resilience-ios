#import "IncidentCell.h"
#import "UIColor+Resilience.h"

@implementation IncidentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];

    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(DETAIL_EDGE, 5, 250, 20)];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor defaultTextColor];
    self.nameLabel.font = [self.nameLabel.font fontWithSize:16.];

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DETAIL_EDGE, 30, 250, 15)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor defaultTextColor];
    self.timeLabel.font = [self.timeLabel.font fontWithSize:14.];

    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(DETAIL_EDGE, 50, 250, 15)];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    self.locationLabel.textColor = [UIColor defaultTextColor];
    self.locationLabel.font = [self.locationLabel.font fontWithSize:12.];

    self.contentView.backgroundColor = [UIColor colorWithRed:233./255. green:233./255. blue:233./255. alpha:1];
    self.accessoryView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor colorWithRed:233./255. green:233./255. blue:233./255. alpha:1];

    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.locationLabel];
    [self.contentView addSubview:self.photoImageView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

@end