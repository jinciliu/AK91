df80 <- filter(df, CENSUS == 80)[, c("YOB", "QOB", "LWKLYWGE")] %>% 
  mutate(birth_cohort = YOB + 0.25 * QOB) %>% 
  group_by(birth_cohort)  %>% 
  mutate(log_wage = mean(LWKLYWGE))


time <- seq(30.25, 50, 0.25) 
n <- length(time) 

wage <- vector("numeric", length = n) 
ind <- vector("numeric", length = n) 

for (t in c(1:n)){
  loc <- match(time[t], df80$birth_cohort) 
  wage[t] <- df80$log_wage[loc] 
  ind[t] <- (t-1) %% 4 + 1
}

wage.time <- as.data.frame(cbind(time, wage, ind))
wage.time$ind <- as.factor(wage.time$ind)

ggplot(wage.time, aes(x = time, y = wage)) + 
  geom_line(color = "dodger blue") +
  geom_point(aes(shape = ind, fill = ind),color = "blue",size = 3) + 
  geom_text(aes(label=ind), size=3, nudge_y = 0.01, check_overlap = T) +
  scale_shape_manual(values = c(22, 0,0,0)) + 
  theme(legend.position = "none") +
  xlim(30,50) +
  ylim(5.64, 5.94) +
  xlab("Year of Birth") + 
  ylab("Log Weekly Earnings")+
  ggtitle("Average Log Weekly Wage by Quarter of Birth") + 
  theme_bw() + 
  ggsave("Analysis/Output/FigureV.png", width = 8, height = 6) 
  


