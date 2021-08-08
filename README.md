Mapping Twitter Sentiments
================

## Description

This Shiny application is designed to interactively visualize Twitter
sentiments in the USA. Users are able to input the number of tweets and
a hashtag to search. The app then generates an interactive map showing
the locations of all the downloaded tweets as well as the overall
sentiment for each tweet based on the words used. Additionally,
visualizations are generated to show the most common words with their
corresponding sentiment and a the distribution of words per tweet. This
interactive application was created for the STAT-613: Data Science
course at [American University](https://www.american.edu).

## R Packages Used

-   base (R Core Team 2021)
-   rmarkdown (Xie, Dervieux, and Riederer 2020)
-   leaflet (Cheng, Karambelkar, and Xie 2021)
-   rtweet (Kearney, M.W. 2016)
-   sentimentr (Rinker 2019)
-   sf (Pebesma 2018)
-   textclean (Rinker 2018)
-   tidyverse (Wickham et al. 2019)
-   shiny (Chang et al. 2021)

## References

[Allaire, J. J., Xie, Y., McPherson, J., Luraschi, J., Ushey, K.,
Atkins, A., Wickham, H., Cheng, J., Chang, W., & Iannone, R. (2021).
rmarkdown: *Dynamic Documents for
R.*](https://github.com/rstudio/rmarkdown0)

[Brazil, N. (n.d.). Mapping Twitter Data. CRD 230: *Spacial Methods in
Community Research.*](https://crd230.github.io/index.html)

[Chang, W., Cheng, J., Allaire, J. J., Sievert, C., Schloerke, B., Xie,
Y., Allen, J., McPherson, J., Dipert, A., & Borges, B. (2021). *shiny:
Web Application Framework for
R.*](https://CRAN.R-project.org/package=shiny)

[Cheng, J., Karambelkar, B., & Xie, Y. (2021). *leaflet: Create
Interactive Web Maps with the JavaScript “Leaflet”
Library.*](https://CRAN.R-project.org/package=leaflet)

[Cheng, J., & RStudio. (n.d.). SuperZIP demo.
*GitHub.*](https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example)

[improcessing. (n.d.). How to customize legend labels in R Leaflet.
*Stackoverflow.*](https://stackoverflow.com/questions/47410833/how-to-customize-legend-labels-in-r-leaflet)

[Kearney, M. W. (2019). rtweet: Collecting and analyzing Twitter data.
*Journal of Open Source Software*, 4(42),
1829.](https://doi.org/10.21105/joss.01829)

[Machlis, S. (2020, January 25). Create a Shiny app to search Twitter
with rtweet and R.
*InfoWorld.*](https://www.infoworld.com/article/3516150/create-a-shiny-app-to-search-twitter-with-rtweet-and-r.html)

Machlis, S., & IDG Communications. (2020). *Do More With R Insider
Bonus: Create an interactive R shiny app to search Twitter.*

[Pebesma, E. (2018). Simple Features for R: Standardized Support for
Spatial Vector Data. *The R Journal*, 10(1),
439–446.](https://doi.org/10.32614/RJ-2018-009)

[R Core Team. (2021). R: A Language and Environment for Statistical
Computing. R Foundation for Statistical
Computing.](https://www.R-project.org/)

[Rinker, T. W. (2018). textclean: *Text Cleaning
Tools.*](https://github.com/trinker/textclean)

[Rinker, T. W. (2019). *sentimentr: Calculate Text Polarity
Sentiment.*](http://github.com/trinker/sentimentr)

[Slige, J. (n.d.). *Sentiment analysis with tidymodels and \#TidyTuesday
Animal Crossing reviews.*](https://juliasilge.com/blog/animal-crossing/)

[Wasser, L., & Farmer, C. (n.d.). Create Maps of Social Media Twitter
Tweet Locations Over Time in R. *Earth Lab Earth
Analytics.*](https://www.earthdatascience.org/courses/earth-analytics/get-data-using-apis/map-tweet-locations-over-time-r/)

[Wickham, H. (n.d.). *Mastering
Shiny.*](https://mastering-shiny.org/index.html)

[Wickham, H., Averick, M., Bryan, J., Chang, W., McGowan, L. D.,
François, R., Grolemund, G., Hayes, A., Henry, L., Hester, J., Kuhn, M.,
Pedersen, T. L., Miller, E., Bache, S. M., Müller, K., Ooms, J.,
Robinson, D., Seidel, D. P., Spinu, V., … Yutani, H. (2019). Welcome to
the tidyverse. *Journal of Open Source Software, 4(43),*
1686.](https://doi.org/10.21105/joss.01686)

[Xie, Y., Allaire, J. J., & Grolemund, G. (2018). *R Markdown: The
Definitive Guide.* Chapman and
Hall/CRC.](https://bookdown.org/yihui/rmarkdown)

[Xie, Y., Dervieux, C., & Riederer, E. (2020). *R Markdown Cookbook.*
Chapman and Hall/CRC.](https://bookdown.org/yihui/rmarkdown-cookbook)
