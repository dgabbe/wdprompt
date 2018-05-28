
### wdprompt

[![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![packageversion](https://img.shields.io/badge/Package%20version-2018.05.24-orange.svg?style=flat-square)](commits/master)
<!-- travis badge --> <!-- code coverage badge -->
<!-- Github download badge? -->

Emulate bash prompt behavior in R console by replacing R’s default
prompt of `>` with the `getwd` string. RStudio does display the current
working directory in the Console window title bar, but it is not
normally where I look. The global environment can be cleared without
affecting the prompt behavior.

``` r
> library(wdprompt)
> stop_wd()
> getwd()
#> [1] "/Users/dgabbe/_git/_r/wdprompt"
> init_wd()
> start_wd()
#> [1] FALSE
```

Complete package documentation is
[here](https://blog.frame38.com/wdprompt/reference/wdprompt-package.html).
