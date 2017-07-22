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


