+++
date = "2017-02-06T08:11:27-05:00"
title = "Golang testing package encourages good package design"
slug = "golang-testing-package-encourages-good-package-design"
tags = ["golang", "package", "development", "design", "unitests"]

+++
Software development disciplines teach us to minimize public functions and
interfaces exported by our code.  This forms what is known as the public
surface of the code package. It is through this public surface that we proclaim
to our users which interfaces and functions are available for use.

Making an interface public proclaims two things

  1. The interface is well tested and approved for use.
  2. The signature of this interface is guaranteed not to change for this major version.
<!--more-->

Developers who are cognizant of their public surface usually err on the side of
caution by making all new functions private first, and are very explicit in
exposing a small subset of functions public. Developers new to golang and which
fall into this category are often appalled to discover they are unable to
access private functions when writing tests using the built in **_test** package.

The typical response is to place the public test functions in the public package,
and avoid the **_test** package all together. The result is a littering of the
public surface with hundreds of test functions! Precisely opposite of what we
wanted to accomplish in making our functions private! 

So what are we todo?

## Good package design examples
We get clues by examining the golang standard library. Take the golang standard
**fmt** package as an example. It’s public surface is very clean and well tested
with 36 tests in the **fmt_test** package. Yet closer inspection reveals many
private functions of varying degrees of complexity within the package! How does
a package as well tested and widely used as **fmt** get away with zero tests on
private functions? The answer might surprise you, as this simple rule is one of
the hallmarks of great software design and good testing.

## Only test the public interface
One of the promises of the public surface is that the interface is well tested,
as such; the public surface should be the focus of all your tests. If the
public surface tests all possible execution paths within our public and private
functions no private function testing is required. With thorough test coverage of
the public surface, all possible code paths are covered. 

Put another way; if your are testing private functions, you are breaking the
rules of encapsulation. Or if you feel the need to test a private method, it
instead should be a public method, as private functions form the core of the
encapsulation. No matter how many ways you say it, the result is the same.
Testing private functions defeats the purpose of encapsulation.

A code refactor is judged successful if the public surface tests pass,
regardless of what private functions were modified. As long as all code paths
within the private functions are covered, the package is tested. 

To ensure our public surface tests cover all our private functions, golang comes
with a built in code coverage tool to identify un-exercised code paths. For
example, we can see all the test coverage for private functions in the **fmt**
package by running the following in a terminal. (See fmt/format.go which
contains many of the private functions)

```
 $ go test -coverprofile=coverage.out fmt
 $ go tool cover -html=coverage.out
```

Following this rule can avoid writing brittle tests of tightly coupled
private functions that are covered by tests on the public surface. 

## How do I avoid crowding the public surface?
Inevitably you will write some general interfaces which are useful to many
parts of your code, but are not strictly apart of the public surface you
wish to present. These interfaces are perfect candidates for placement in a
sub-package. In this way we create a testable public interface for our private
code to use, but which is not strictly apart of our main packages public
surface. golang supports sub packages naturally and can be a strong indicator
to users which interface surfaces are specific to our package.

```
  github.com/thrawn01/package
  github.com/thrawn01/package/utils
  github.com/thrawn01/package/db
```

`go doc` supports this naturally by generating documentation for the current
package and ignoring sub packages unless specified directly. Granted this does
not keep users from using the sub package interfaces; but the generated go docs
can help steer users toward the correct interfaces. 

## How do I know what interfaces to make public or private?
In general, functions and interfaces which are tightly coupled to the calling
function are good candidates for privatization; all others should be public. 

When deciding if a function should be private of public it can be helpful to
ask the following questions:

  1. Is this function generally useful in other parts of the code base? (public/sub package)
  2. Could this function be useful to others? (public/sub package)
  3. Is this function tightly coupled to the package? (private)
  4. Can all code paths be covered by testing the public interface? (If yes make private else public)

## Conclusion
Separation of package code and package testing is a wonderful feature of golang
which forces the developer to make sound choices about how their package is
used and tested. Over my many years of C++ and Java development I can’t tell
you how many times I’ve come across useful and reusable code that was
thoughtlessly left private and thus unasscessable. I’ve been at companies where
entire classes were copied 10+ times in different locations of a vast code base
because the original author never imagined the class would be useful to any one
but himself. Because of this, I write my code public first and make thoughtful
decisions about how my code is used. 

My hope is that this post will encourage others to make their code public first,
use the golang **_test** package, and encourage more code reuse.

