# googleMeasureR

Send tracking hits to Google Analytics from R code using the [Google Analytics Measurement Protocol](https://developers.google.com/analytics/devguides/collection/protocol/v1/)

For general web tracking, install the [Google Analytics tracking script](https://support.google.com/analytics/answer/1008080) instead.

This library is for when you want to send custom tracking events to a Google Analytics property, and is suitable for server-side tracking such as when R code is executed.

Do not send personal identifiable information (PII) to Google Analytics using this library as its against Google Anaytics' terms of service. e.g. Don't send emails, usernames etc. 

## Useage

Install from github via devtools:

```r
devtools::install_github("MarkEdmondson1234/googleMeasureR")
```

Send hits as per the [measurement protocol parameter reference](https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters) - you need to create a named list of the parameters you want to send.

Then send them via `gmr_post` - a minimal example is below:

```r
gmr_post(list(t=2, tid = "UA-XXXXX-Y", cid = 1234567L))
```

## Default Google Analytics Web property

you can set the default web analytics property by setting an environment variable:

In the `.Renviron` file set `MP_TRACKING_ID="UA-123455-1"`

## Hit helpers

Common hit types have been put into functions so you don't need to look up parameters all the time.

So far they are:

*Page type*

```r
gmr_hit_page("/hi-from-r-test", dp = "/bye-from-r-test")
```

*Events*

```r
gmr_hit_event("Rcat","Raction","Rlabel",300)
```

*Timing*

```r
gmr_hit_timing("R_app","shiny_loadtime",3000, label = "appname")
```

In all the above cases, you can override arguments by adding to the call - for example to add your own `cid` would be:

```r
gmr_hit_page("/hi-from-r-test", dp = "/bye-from-r-test", cid = "blah")
```

## Cookie ID / User ID

By default each hit has a new cookie ID (e.g. a new user) - you may want to associate hits with one user when you know that is the case, so you can set the `cid` argument to a fixed value using `my_cid <- gmr_uuid()`

### Enhanced Ecommerce

There are some helpers to add enchanced ecommerce arguments. An example is shown below:

```r
## send an enhanced ecommerce hit
gmr_hit_page(url_path = "/checkout",
             enhanced_ecom = gmr_enhanced_ecom("purchase", transaction_id = "blah223",
                                                revenue = 4300.23, 
                                                product_sku = c("sku4","sku23","sku7")))

# Make your own hit
my_promotion_id <- gmr_enhanced_index(c("aff3","aff2","aff2"), prefix = "promo", suffix = "id")

# make your own enhanced ecom obj
my_ee <- do.call(gmr_enhanced_ecom,
                  args = c(list(action = "purchase",
                               transaction_id = "2323",
                               product_sku = c("sku4","sku3","sku7")
                               ),
                          my_promotion_id)
                          )

# register hit
gmr_hit_page(url_path = "/checkout-thanks", enhanced_ecom = my_ee)
```

## Debug mode

You can not send a proper hit and just see if the hit was valid by setting `options(googleMeasureR.debug = TRUE)` which will send the hit to the debug API endpoint instead. 

```r
options(googleMeasureR.debug = TRUE)

## send a debug enhanced ecommerce hit
gmr_hit_page(url_path = "/checkout",
             enhanced_ecom = gmr_enhanced_ecom("purchase", transaction_id = "blah223",
                                                revenue = 4300.23, 
                                                product_sku = c("sku4","sku23","sku7")))
                                                
# Debug mode
# List of 12
#  $ ds   : chr "googleMeasureR"
#  $ cid  : chr "8c906d8e-70a1-11e7-9fad-ac87a30fc0b7"
#  $ dp   : chr "%2Fcheckout"
#  $ pa   : chr "purchase"
#  $ tr   : chr "4300.23"
#  $ ti   : chr "blah223"
#  $ pr1id: chr "sku4"
#  $ pr2id: chr "sku23"
#  $ pr3id: chr "sku7"
#  $ v    : chr "1"
#  $ tid  : chr "UA-540134324-3"
#  $ t    : chr "pageview"
# $hitParsingResult
#   valid parserMessage
# 1  TRUE          NULL
#                                                                                                                                                                                             hit
# 1 /debug/collect?ds=googleMeasureR&cid=8c906d8e-70a1-11e7-9fad-ac87a30fc0b7&dp=%2Fcheckout&pa=purchase&tr=4300.23&ti=blah223&pr1id=sku4&pr2id=sku23&pr3id=sku7&v=1&tid=UA-54019251-3&t=pageview
# 
# $parserMessage
#   messageType                 description
# 1        INFO Found 1 hit in the request.
```
