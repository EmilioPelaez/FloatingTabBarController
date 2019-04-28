# CGMath

## About

CGMath is a collection of extensions and functions around CGGeometry types, `CGPoint`, `CGSize`, `CGRect` and `CGVector`. It includes some other functions for `FloatingPoint` and `Comparable` types.

### Comparable
`clamp` is a function that takes three parameters, `value`, `min` and `max`. It will return a value that will be `min` if `value <= min`, `max` if `value >= max` and `value` in any other case.

### Floating Point
`lerp` is the linear interpolation function. Given two values, `start` and `end`, and a `progress` (usually in the range `[0, 1]`), it will perform a linear interpolation between `start` and `end` and return that value.

You can read more about linear interpolation [here](https://en.wikipedia.org/wiki/Linear_interpolation)  but the basic gist of it is that it will return `start` when `progress` is `0`, `end` when progress is `1`, and for any value in `[0, 1]` it will return the percentage of the difference between `end` and `start`. For example, `lerp(start: 5, end: 15, progress: 0.5)` will return `10`, which is right between `5` and `15`, because progress is `0.5`.   

This method can take a `progress` value outside the `[0, 1]` range, this can be useful in some cases, like when making a bouncy animation, but you can prevent this by using `clamp()` on the progress before calling the function. 

`inverseLerp` is the opposite of `lerp`. Given three values, `start`, `end` and a `value` (usually in the `[start, end]` range), it will return a `progress` value such that using it in `lerp` with the same `start` and `end` values, it will return `value`. For example, `lerp(start: 5, end: 15, value: 10)` will return `0.5`, since `10` is right between `5` and `15`.

`remap` takes to ranges and converts the value from one range to another. For example, if you have a few values in the `[20, 40]` range and you want them in the `[50, 100]` range, you would call `value.remap(from: (20, 40), to: (50, 100))`. `20` would become `50`, `40` would become `100` and `30` would become `75`. 

### CGGeometry and DoubleListRepresentable
The four `CGGeometry` types `CGPoint`, `CGSize`, `CGRect` and `CGVector` conform to  the protocols in `DoubleListRepresentable`. This means that they can be initialized and converted to a list of doubles. In the case of `CGRect`, this list is exactly four elements long, in all other cases the list should have exactly two elements.

`DoubleListRepresentable` adds the `magnitude` variable and the `normalize` and `lerp` methods, which should be quite self explanatory. It also adds four basic arithmetic functions: `+`, `-`, `*` and `/`. In the case of the multiplication and division, this is done with a scalar (`Double`) that multiplies or divides each component of the element.

### CGGeometry Extensions
Besides the functions and variables provided by `DoubleListRepresentable`, each of the four `CGGeometry` types contains at least one convenience initializer, which should be very easy to understand, and `CGPoint`, `CGSize` and `CGVector` contain variables to transform the value from one type to any of the other two types.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

CGMath is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CGMath'
```

## Author

Emilio Peláez, i.am@emiliopelaez.me

## License

CGMath is available under the MIT license. See the LICENSE file for more info.
