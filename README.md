# Internal WISE dashboard for wastewater-based Rt estimates

### Online dashboard
You can access the dashboard online [here](https://wise-ch.shinyapps.io/WISE_Rt_internal_dashboard/).

### Lauching the dashboard locally
To launch the dashboard locally, you need to have R with the packages `shiny`, `dplyr`, and `ggplot2` installed. Then, simply run the following code of line in R:
```
shiny::runGitHub("wise-ch/wise_Rt_current", ref = "refs/heads/main", subdir = "app", launch.browser = TRUE)
```

Alternatively, you can download the [run_app.R file](https://github.com/wise-ch/wise_Rt_current/blob/main/run_app.R) from this repository and execute it in R. If you also download the [start_app.bash file](https://github.com/wise-ch/wise_Rt_current/blob/main/start%20app.bash), you can launch the dashboard without opening R.
