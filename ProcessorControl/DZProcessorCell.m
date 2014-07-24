//
//  DZProcessorCell.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/27/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "DZProcessorCell.h"
#import "PCPreferencesController.h"

@implementation DZProcessorCell {
  unsigned int _previous_cpu_tick_system, _previous_cpu_tick_user, _previous_cpu_tick_idle;
}

- (id)init {
  if ((self = [super init]) != nil) {
    _textLayer = [[CATextLayer alloc] init];
    _textLayer.foregroundColor = [NSColor whiteColor].CGColor;
    _textLayer.alignmentMode = kCAAlignmentCenter;
    _textLayer.contentsScale = [[NSScreen mainScreen] backingScaleFactor];
    _subTextLayer = [[CATextLayer alloc] init];
    _subTextLayer.foregroundColor = [NSColor whiteColor].CGColor;
    _subTextLayer.alignmentMode = kCAAlignmentCenter;
    _subTextLayer.contentsScale = [[NSScreen mainScreen] backingScaleFactor];
    NSFont *f = [NSFont systemFontOfSize:[NSFont smallSystemFontSize] * 0.9];
    _subTextLayer.font = (__bridge CFTypeRef)f;
    _subTextLayer.fontSize = f.pointSize;
    [self addSublayer:_textLayer];
    [self addSublayer:_subTextLayer];
    _enabled = YES;
    _master = NO;
    _switchType = 0;
    [self updateTextLayer];
    [self updateSubTextLayer];
  }
  return self;
}

- (void)updateTextLayer {
  if (_master) {
    NSColor *fillColor = [NSColor colorWithRed:87.0/255.0 green:100.0/255.0 blue:199.0/255.0 alpha:1.0];
    self.backgroundColor = fillColor.CGColor;
    self.borderColor = [fillColor blendedColorWithFraction:0.1 ofColor:[NSColor blackColor]].CGColor;
    self.borderWidth = 3;
    
    NSFont *f;
    switch (_switchType) {
      case PCSwitchTypeSmiley:
        _textLayer.string = !_touching ? @"⊙__⊙" : @"¬__¬";
        f = [NSFont fontWithName:@"Everson Mono Bold" size:[NSFont systemFontSize]*2.5];
        break;
      case PCSwitchTypeDefault:
      default:
        _textLayer.string = @"Master";
        f = [NSFont systemFontOfSize:[NSFont systemFontSize]];
        break;
    }
    
    _textLayer.font = (__bridge CTFontRef)f;
    _textLayer.fontSize = f.pointSize;
    CGSize s = [_textLayer.string sizeWithAttributes:@{NSFontAttributeName: f}];
    _textLayer.frame = CGRectMake(0, self.bounds.size.height/2 - s.height/2, self.bounds.size.width, s.height);

  } else {
    
    self.borderWidth = 0.0;
    
    NSColor *fillColor = [[NSColor colorWithRed:87.0/255.0 green:100.0/255.0 blue:199.0/255.0 alpha:1.0] blendedColorWithFraction:_enabled ? 0.0f : 1.0f ofColor:[NSColor colorWithRed:199.0/255.0 green:87.0/255.0 blue:183.0/255.0 alpha:1.0]];
    self.backgroundColor = fillColor.CGColor;
    switch (_switchType) {
      case PCSwitchTypeSmiley:
        if (!_touching) {
          if (_enabled) {
            _textLayer.string = @"•‿•";
          } else {
            _textLayer.string = @"ᴗ˳ᴗ";
          }
        } else {
          _textLayer.string = @"◕ᴗ◕";
        }
        break;
      case PCSwitchTypeDefault:
      default:
        _textLayer.string = @(_row * _columns + _column).stringValue;
        break;
    }
    
    NSFont *f;
    switch (_switchType) {
      case PCSwitchTypeSmiley:
        f = [NSFont fontWithName:@"Everson Mono Bold" size:[NSFont systemFontSize]*2.5];
        break;
      case PCSwitchTypeDefault:
      default:
        f = [NSFont systemFontOfSize:[NSFont systemFontSize]];
        break;
    }
    
    _textLayer.font = (__bridge CTFontRef)f;
    _textLayer.fontSize = f.pointSize;
    CGSize s = [_textLayer.string sizeWithAttributes:@{NSFontAttributeName: f}];
    _textLayer.frame = CGRectMake(0, self.bounds.size.height/2 - s.height/2, self.bounds.size.width, s.height);
  }
  [self updateSubTextLayer];
}

- (void)updateSubTextLayer {
  if (!_showStats) {
    _subTextLayer.string = @"";
    return;
  }
  double total = _cpu_tick_system + _cpu_tick_user + _cpu_tick_idle, ptotal = _previous_cpu_tick_system + _previous_cpu_tick_user + _previous_cpu_tick_idle;
  double diffsys = (_cpu_tick_system - _previous_cpu_tick_system) / (total - ptotal);
  double diffuse = (_cpu_tick_user - _previous_cpu_tick_user) / (total - ptotal);
  double diffidle = (_cpu_tick_idle - _previous_cpu_tick_idle) / (total - ptotal);
  if (ptotal == total || ptotal == 0) {
    _subTextLayer.string = @"";
  } else {
    switch (_switchType) {
      case PCSwitchTypeSmiley:
        _subTextLayer.string = [NSString stringWithFormat:@"%.1f%% %.1f%% %.1f%%", diffsys*100, diffuse*100, diffidle*100];
        break;
      case PCSwitchTypeDefault:
      default:
        _subTextLayer.string = [NSString stringWithFormat:@"System: %.1f%%\nUser: %.1f%%\nIdle: %.1f%%", diffsys*100, diffuse*100, diffidle*100];
    }
  }
  CGSize s = [_subTextLayer.string sizeWithAttributes:@{NSFontAttributeName: (NSFont *)_subTextLayer.font}];
  _subTextLayer.frame = CGRectMake(0, CGRectGetMaxY(_textLayer.frame), self.bounds.size.width, s.height);
}

#define TLU(u, l, t) \
- (void)set ## u : ( t ) l { \
  _ ## l = l; \
  [self updateTextLayer]; \
}

#define STLU(u, l, t, b, a) \
- (void)set ## u : ( t ) l { \
  b; \
  _ ## l = l; \
  [self updateSubTextLayer]; \
  a; \
}

#define TSTLU(u, l, t) STLU(u, l, t, _previous_ ## l = _ ## l, )

TLU(Enabled, enabled, BOOL)
TLU(Master, master, BOOL)
TLU(Touching, touching, BOOL)
TLU(SwitchType, switchType, NSInteger)
TLU(Column, column, NSUInteger)
TLU(Row, row, NSUInteger)
TLU(Rows, rows, NSUInteger)
TLU(Columns, columns, NSUInteger)
TSTLU(Cpu_tick_system, cpu_tick_system, unsigned int)
TSTLU(Cpu_tick_user, cpu_tick_user, unsigned int)
TSTLU(Cpu_tick_idle, cpu_tick_idle, unsigned int)
STLU(ShowStats, showStats, BOOL,,)

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  [self updateTextLayer];
  [self updateSubTextLayer];
}

@end
