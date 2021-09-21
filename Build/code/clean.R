
input <- import(infile)

df<- input %>% 
  rename(AGE = v1,
         AGEQ = v2,
         EDUC = v4,
         ENOCENT = v5,
         ESOCENT = v6,
         LWKLYWGE = v9,
        MARRIED = v10,
        MIDATL = v11,
        MT = v12,
        NEWENG = v13,
        CENSUS = v16,
        QOB = v18,
        RACE = v19,
        SMSA = v20,
        SOATL = v21,
        WNOCENT = v24,
        WSOCENT = v25,
        YOB = v27) %>% 
  mutate(COHORT = 20.29) %>% 
  mutate(COHORT = case_when(
    (YOB>=30)&(YOB<=39) ~ 30.39,
    (YOB>=40)&(YOB<=49) ~ 40.49,
    TRUE ~ as.numeric(COHORT))) %>% 
  mutate(AGEQ = ifelse(CENSUS == 80, AGEQ-1900, AGEQ)) %>% 
  mutate(AGEQSQ = AGEQ * AGEQ)%>%
  mutate(YR20 = ifelse(YOB %% 10 == 0, 1, 0)) %>% 
  mutate(YR21 = ifelse(YOB %% 10 == 1, 1, 0)) %>%
  mutate(YR22 = ifelse(YOB %% 10 == 2, 1, 0)) %>%
  mutate(YR23 = ifelse(YOB %% 10 == 3, 1, 0)) %>%
  mutate(YR24 = ifelse(YOB %% 10 == 4, 1, 0)) %>%
  mutate(YR25 = ifelse(YOB %% 10 == 5, 1, 0)) %>%
  mutate(YR26 = ifelse(YOB %% 10 == 6, 1, 0)) %>%
  mutate(YR27 = ifelse(YOB %% 10 == 7, 1, 0)) %>%
  mutate(YR28 = ifelse(YOB %% 10 == 8, 1, 0)) %>%
  mutate(YR29 = ifelse(YOB %% 10 == 9, 1, 0)) %>%
  mutate(QTR1 = ifelse(QOB == 1, 1, 0)) %>%
  mutate(QTR2 = ifelse(QOB == 2, 1, 0)) %>%
  mutate(QTR3 = ifelse(QOB == 3, 1, 0)) %>%
  mutate(QTR4 = ifelse(QOB == 4, 1, 0))




# Generate YOB*QOB dummies

#TEM3 <- df%>%select(c("QTR1", "QTR2", "QTR3"))
#for(i in 1:3){
  for (y in 20:29) {
    q <- y +100
    TEM1 <-paste("QTR",q,sep ="")
    TEM2 <-paste("YR",y,sep = "")
    df <- df%>% mutate(!!TEM1 := QTR1*df[[TEM2]])
  }

for (y in 20:29) {
  q <- y +200
  TEM1 <-paste("QTR",q,sep ="")
  TEM2 <-paste("YR",y,sep = "")
  df <- df%>% mutate(!!TEM1 := QTR2*df[[TEM2]])
}
for (y in 20:29) {
  q <- y +300
  TEM1 <-paste("QTR",q,sep ="")
  TEM2 <-paste("YR",y,sep = "")
  df <- df%>% mutate(!!TEM1 := QTR3*df[[TEM2]])
}


save(df, file =outfile1)
