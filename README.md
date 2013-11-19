# IRFAutoCompletionKit

[![Version](https://cocoapod-badges.herokuapp.com/v/IRFAutoCompletionKit/badge.png)](http://cocoadocs.org/docsets/DSAutoCompletionKit)
[![Platform](https://cocoapod-badges.herokuapp.com/p/IRFAutoCompletionKit/badge.png)](http://cocoadocs.org/docsets/DSAutoCompletionKit)
[![Build Status](https://travis-ci.org/irrationalfab/IRFAutoCompletionKit.png?branch=master)](https://travis-ci.org/irrationalfab/IRFAutoCompletionKit)

_Warning this library is under development and although it is functional is has some important bugs._

Small kit designed to provide autocompletion triggered by a character. Built in
support is provided for emojis and completions from an user list. The base
classes are easily extendible to provide support for other uses.

Currently only OS X is supported, however many of the classes would compile (in
some cases with minor adaptations) on iOS.

<p align="center">
  <img src="https://raw.github.com/irrationalfab/IRFAutoCompletionKit/master/Web/Screen%20Shot%200.png"/>
</p>

## Usage

To run the example project; clone the repo, and run `pod install` from the
Project directory first.

```objc
#import <IRFAutoCompletionKit/IRFAutoCompletionKit.h>

- (void)viewSetupMethod {
    IRFEmojiAutoCompletionProvider *emojiCompletionProvider = [IRFEmojiAutoCompletionProvider new];
    NSArray *completionsProviders = @[emojiCompletionProvider];
    [self setAutoCompletionManager:[IRFAutoCompletionTextFieldManager new]];
    [self.autoCompletionManager setCompletionProviders:completionsProviders];
    [self.autoCompletionManager attachToTextField:self.textField];
    [self.autoCompletionManager setTextFieldFowardingDelegate:self];
}
```

## Installation

DSAutoCompletionKit is available through [CocoaPods](http://cocoapods.org), to
install it simply add the following line to your Podfile:

    pod "DSAutoCompletionKit"

## Author

Fabio Pelosin, [@fabiopelosin](https://twitter.com/fabiopelosin)

## License

DSAutoCompletionKit is available under the MIT license. See the LICENSE file
for more info.

