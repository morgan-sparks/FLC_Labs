library(geomorph); library(tidyverse); library(kableExtra)


#data <- read_csv("~/Downloads/Test data - Sheet1.csv")
data <- data3

# Length analysis ---------------------------------------------------------

data.length <- data[data$Measure == "TL" | data$Measure == "MEH", c(1:5)] 

### variation in all measurements
data.length %>% 
  group_by(Fish, Measure) %>% 
  summarise(mean= mean(Length),
            sd = sd(Length)) %>% 
  kbl() %>% 
  kable_styling() 

data.length %>% 
  group_by(Fish, Measure) %>% 
  summarise(mean= mean(Length),
            sd = sd(Length)) %>%
  ggplot() +
  geom_point(aes(x= Fish, y = mean)) +
  geom_errorbar(aes(x = Fish, ymin = mean-sd, ymax = mean + sd)) +
  facet_wrap(~Measure) +
  lims(y = c(0,35)) +
  theme_classic()

### variation by group

#look just at MEH
data.length %>% 
  group_by(Group,Fish, Measure) %>% 
  filter(Measure == "MEH") %>% 
  summarise(mean= mean(Length),
            sd = sd(Length)) %>% 
  kbl() %>% 
  kable_styling() 

data.length %>% 
  group_by(Group, Fish, Measure) %>%
  mutate_at(c("Group", "Investigator"), as.character) %>% 
  summarise(mean= mean(Length),
            sd = sd(Length)) %>%
  ungroup() %>% 
  ggplot(aes(x= Fish, y = mean, color = Group)) +
  geom_point(data = data.length, aes(x= Fish, y = Length , color = as.character(Group)), alpha = 0.5, position=position_dodge(width=0.9)) +
  geom_point(position=position_dodge(width=0.9)) +
  geom_errorbar(aes( ymin = mean-sd, ymax = mean + sd, color = Group),position=position_dodge(width=0.9)) +
  facet_wrap(~Measure) +
  lims(y = c(20,35)) +
  labs(title = "Precision by group") +
  theme_classic()


# Morhpometric analysis ---------------------------------------------------


# take our data and put into format appropriate for geomorph

data.morph<- data %>% 
  filter(Measure != "TL") %>% 
  filter(Measure != "MEH")

morph.matrix <- as.matrix(data.morph[,6:7])


morph.array <- arrayspecs(morph.matrix, 18, 2)

#run gpa and plot gpa
morph.gpa <- gpagen(morph.array)
plot(morph.gpa)

as.data.frame.array(morph.gpa$coords)

# run PCA from corrected gpa vals
morph.PCA <- gm.prcomp(morph.gpa$coords)
summary(morph.PCA)
plot(morph.PCA)


### ggplot version

# make PCs into df
comps <- morph.PCA$x %>%
  as.tibble() %>% 
  pivot_longer(cols = 1:8, names_to = "comp", values_to = "eigenvalue")


#add some covariates to PC comps df
comps <- morph.PCA$x %>%
  as.tibble()
comps$Fish <- rep(c("Bass", "Salmon", "Trout"), times = c(16))
comps$Invest <- rep(c("1", "2", "3", "4"), times = c(12,12,12,12))
comps$Group <- rep(c("1","2", "3", "4"), times = 12)

# make df of loading values
loadings <- morph.PCA$d %>%
  as.tibble() %>% 
  mutate(loading = value/sum(value)) %>% 
  select(loading)

# plot all pc loadings
loadings %>% 
  mutate(percent = round(loading*100, 1),
         PC = (1:nrow(loadings))) %>% 
  ggplot() +
  geom_col(aes(x = PC, y= percent)) +
  labs(x = "Principal Component", y = "Percent variation", main = "How much variation does each PC explain?") +
    theme_classic()
  
# plot pc1 and pc2
comps %>% 
  ggplot(aes(x = Comp1, y = Comp2, color = Fish)) +
  geom_point(aes(shape = Group), size = 2) +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0) +
  labs(x = paste0("PC1 (", round(loadings$loading[1]*100,1), "%)" ), 
       y =  paste0("PC2 (", round(loadings$loading[2]*100,1), "%)" )) +
  theme_bw()

# plot pc2 and pc3
comps %>% 
  ggplot(aes(x = Comp1, y = Comp2, color = Fish)) +
  geom_point(aes(shape = Group), size = 2) +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0) +
  labs(x = paste0("PC2 (", round(loadings$loading[2]*100,1), "%)" ), 
       y =  paste0("PC3 (", round(loadings$loading[3]*100,1), "%)" )) +
  theme_bw()

### lets go back to gpa and try and figure out which factor are driving the differentiaton on each axis

# set up data
gpa.coords <- as.data.frame.table(morph.gpa$coords) %>% 
  pivot_wider(names_from = "Var2", values_from = "Freq")

colnames(gpa.coords)[1:2] <- c("Measure", "Individual")

gpa.coords$Fish <- rep(rep(c("Bass", "Salmon", "Trout"), times = c(18,18,18)), 16)
gpa.coords$Measure <- as.character(gpa.coords$Measure)

gpa.means <- data.frame(morph.gpa$consensus)
gpa.means$Measure <- as.character(c(1:18))

# plot all fish
ggplot(data = gpa.means, aes(shape =Measure)) +
  geom_point(data = gpa.coords, aes(x = X, y = Y, color = Fish)) +
  geom_point(data = gpa.means, aes(x = X, y = Y, ), color = "Black", size = 2) +
  scale_shape_manual(values = c(1:18), ) +
  guides(shape = FALSE) +
  labs(title = "Which traits drive variation on PC1 (bass vs. salmonids)") +
  theme_classic()

# plot just salmonids
ggplot(data = gpa.means, aes(shape =Measure)) +
  geom_point(data = gpa.coords[gpa.coords$Fish != "Bass",], aes(x = X, y = Y, color = Fish)) +
  geom_point(data = gpa.means, aes(x = X, y = Y, ), color = "Black", size = 2) +
  scale_shape_manual(values = c(1:18), ) +
  guides(shape = FALSE) +
  labs(title = "Which traits drive variation on PC2 (cutthroat vs. salmon)") +
  theme_classic()

gpa.coords %>% 
  filter(Fish != "Bass") %>% 
  group_by(Measure, Fish) %>% 
  summarise(mean.x = mean(X),
            mean.y = mean(Y)) %>% 
  ungroup() %>% 
  ggplot() +
  geom_point(data = gpa.means, aes(x = X, y = Y, shape = Measure), color = "Black", size = 2) +
  geom_point(aes(x = mean.x, y = mean.y, color = Fish, shape = Measure)) +
  geom_line(aes(x = mean.x, y = mean.y, group = Measure)) +
  scale_shape_manual(values = c(1:18)) +
  guides(color = FALSE) +
  labs(title = "Which traits drive variation on PC2 (cutthroat vs. salmon)") +
  theme_classic()
###

# covs <- data.morph %>% 
#   group_by(Investigator) %>% 
#   select(Fish) %>% 
#   unique() %>% 
#   ungroup() %>% 
#   group_by(Fish)
# 
# fish <- c(rep(c("Bass", "Salmon", "Trout"), times = c(3,3,3)))
# invest <-c(rep(c(1:3), times = c(3)))
# groups <- c(rep(c(1:4), times = 4))
# 
# 
# 
# covs.labs <-  as.factor(paste(fish, invest))
# covs.fish <-as.factor(paste(fish))
# plot(morph.PCA, pch= 22, cex = 1.5, bg = covs.labs) 
# legend(x = 1.1, pch=22, pt.bg = unique(covs.labs), legend = levels(covs.labs))
# 
# msh <- mshape(morph.gpa$coords)
# plotRefToTarget(morph.PCA$shapes$shapes.comp1$min, msh)
# plotRefToTarget(morph.PCA$shapes$shapes.comp1$max, msh)
# 
# plotRefToTarget(morph.PCA$shapes$shapes.comp1$min, morph.PCA$shapes$shapes.comp1$max, method = "vector", mag = 2)
# 

# Make data doc -----------------------------------------------------------
data2 <- NULL
data2 <- data.frame(matrix(NA, nrow = 16*3*20, ncol = 7))
colnames(data2) <- c("Group", "Investigator", "Fish", "Measure", "Length", "X", "Y")
data2$Measure <- rep(c("TL", "MEH", as.character(c(1:18))), times = 16*3)
data2$Group <- c(rep(1:4, times = c(240,240,240, 240)))
data2$Investigator <-c(rep(rep(1:4, times = c(60,60,60,60)), 4))
data2$Fish <-c(rep(rep(c("Bass", "Salmon", "Trout"), times = c(20,20,20)), 16))

write_csv(x = data2, "~/Downloads/class_data.csv")

# make completely fake data set
fake.data <- read_csv("~/Downloads/Test data - Sheet1.csv")

data3 <- data2
data3[1:60, 5:7] <- fake.data[1:60, 5:7]

length.data.rows <- seq(1, nrow(data3), by= 20)
counter.vector <- c(rep(c(0,20,40), times =20))
# loop to make fake data
set.seed(1234)
for (i in 1:length(length.data.rows)){
  l <- length.data.rows[i]
  c <- counter.vector[i]
  data3$Length[l:(l+1)]<- data3$Length[(1+c):(2+c)] + rnorm(2, 0, .33)
  data3$X[(l+2):(l+19)] <- data3$X[(3+c):(20+c)] +rnorm(18, 0, .33)
  data3$Y[(l+2):(l+19)] <- data3$Y[(3+c):(20+c)] +rnorm(18, 0, .33)
}

data3


# Model data --------------------------------------------------------------------

# make gpa data into a list
morph.list <- as.list(NULL)
morph.list[[1]] <- morph.gpa$coords
morph.list[[2]] <-as.factor(comps$Fish)
names(morph.list) <- c("coords", "Fish")
Fish <- morph.list$Fish

# run disparity analysis

fit <- procD.lm(coords~Fish, data = morph.list,)
MD <- morphol.disparity(fit, print.progress = FALSE)

summary(MD)

# show plot to understand differences
P <- plot(fit, type = "PC", pch = 21, bg = morph.list$Fish)
shapeHulls(P, Fish, group.cols = c(1,2,3))
