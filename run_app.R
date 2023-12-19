if (!require("shiny")){
  install.packages("shiny")
}
if (!require("dplyr")){
  install.packages("dplyr")
}
if (!require("ggplot2")){
  install.packages("ggplot2")
}

shiny::runGitHub(
  "wise-ch/wise_Rt_current", ref = "refs/heads/main", subdir = "app",
  launch.browser = TRUE
  )