YR <- paste0("YR", 20:28)

controls <- c("RACE", "MARRIED", "SMSA", "NEWENG", "MIDATL",
              "ENOCENT", "WNOCENT", "SOATL", "ESOCENT", "WSOCENT", "MT")

IV <- c(paste0("QTR1", 20:29), paste0("QTR2", 20:29),
                 paste0("QTR3", 20:29), paste0("YR", 20:28))

AK91_reg <- function(name, cohort){
  reg1 <- lm(LWKLYWGE ~ ., 
             data = filter(df, COHORT == cohort)[, c("LWKLYWGE", "EDUC", YR)])
  
  reg3 <- lm(LWKLYWGE ~ ., 
             data = filter(df, COHORT == cohort)[, c("LWKLYWGE", "EDUC", YR, "AGEQ", "AGEQSQ")])
  
  reg5 <- lm(LWKLYWGE ~ ., 
             data = filter(df, COHORT == cohort)[, c("LWKLYWGE", "EDUC", controls, YR)])

  reg7 <- lm(LWKLYWGE ~ ., 
             data = filter(df, COHORT == cohort)[, c("LWKLYWGE", "EDUC", controls, YR, "AGEQ", "AGEQSQ")])
 
  #ivreg (Y~X+W|W+Z,... data =)
  #X is endogenous and W is exogenous
  
  reg2 <- paste0("LWKLYWGE", "~") %>% 
    paste(paste(YR, collapse = "+")) %>% 
    paste("+EDUC|") %>% 
    paste(paste(IV, collapse = "+")) %>% 
    ivreg(data = filter(df, COHORT == cohort))
  
  reg4 <- paste("LWKLYWGE", "~", sep = "") %>% 
    paste(paste(YR, collapse = "+")) %>% 
    paste("+AGEQ+AGEQSQ+EDUC|") %>% 
    paste(paste(IV, collapse = "+")) %>% 
    ivreg(data = filter(df, COHORT == cohort))
  
  reg6 <- paste("LWKLYWGE", "~", sep = "") %>% 
    paste(paste(YR, collapse = "+")) %>% 
    paste(paste(controls, collapse = "+"), sep = "+") %>% 
    paste("+EDUC|") %>% 
    paste(paste(IV, collapse = "+")) %>%
    paste(paste(controls, collapse = "+"), sep = "+") %>%
    ivreg(data = filter(df, COHORT == cohort))
  
  reg8 <- paste("LWKLYWGE", "~", sep = "") %>% 
    paste(paste(YR, collapse = "+")) %>% 
    paste(paste(controls, collapse = "+"), sep = "+") %>% 
    paste("+AGEQ+AGEQSQ+EDUC|") %>% 
    paste(paste(IV, collapse = "+")) %>% 
    ivreg(data = filter(df, COHORT == cohort))
  
  
  # Output
  filename <- paste("Analysis/Output/", name, ".tex",
                    sep = "", collapse = "")
  table.title <- case_when(
    cohort == 20.29 ~"OLS and TSLS Estimates of Return to Education for Men Born 
    1920-1929: 1970 Census",
    cohort == 30.39 ~"OLS and TSLS Estimates of Return to Education for Men Born 
    1930-1939: 1980 Census",
    cohort == 40.49 ~"OLS and TSLS Estimates of Return to Education for Men Born 
    1940-1949: 1980 Census")
  
  stargazer(reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, 
            digits = 4,
            title = table.title,
            keep = c("EDUC", "RACE", "SMSA", "MARRIED", "AGEQ", "AGEQSQ"),
            keep.stat = c("n"),
            out = filename
  )
}

AK91_reg("TableIV", 20.29)
AK91_reg("TableV", 30.39)
AK91_reg("TableVI", 40.49)
