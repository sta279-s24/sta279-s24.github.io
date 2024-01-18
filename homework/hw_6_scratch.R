library(Lahman)

Teams |>
  filter(teamID == "CHN") |>
  select(yearID, HR, HRA) |>
  pivot_longer(-yearID,
               names_to = "team",
               values_to = "runs") |>
  mutate(team = ifelse(team == "HR", "Cubs", "Opponent")) |>
  ggplot(aes(x = yearID, y = runs, color = team)) +
  geom_point() +
  geom_line() +
  labs(x = "Year", y = "Runs", color = "Team") +
  theme_bw()
  

# pivoting wider and longer

df1 <- data.frame(
  grp = c("A", "A", "B", "B"),
  sex = c("F", "M", "F", "M"),
  meanL = c(0.225, 0.47, 0.325, 0.547),
  sdL = c(0.106, 0.325, 0.106, 0.308),
  meanR = c(0.34, 0.57, 0.4, 0.647),
  sdR = c(0.0849, 0.325, 0.0707, 0.274)
)

df1 |>
  pivot_longer(-c(grp, sex),
               names_to = "stat", values_to = "value") |>
  pivot_wider(id_cols = grp,
              names_from = c(sex, stat),
              names_sep = ".",
              values_from = value)


# pivoting wider and longer

df2 <- data.frame(id = rep(c(1, 2, 3), 2),
                  group = rep(c("T", "C"), each=3),
                  vals = c(4, 6, 8, 5, 6, 10))

df2 |>
  group_by(id) |>
  summarize(diff = vals[group == "T"] - vals[group == "C"])

df2 |>
  pivot_wider(id_cols = id,
              names_from = group,
              values_from = vals) |>
  mutate(diff = T - C)


# simulation results

method1_res <- matrix(rbinom(100*5, 1, c(0.5, 0.7, 0.8, 0.9, 0.95)), nrow=5)
method2_res <- matrix(rbinom(100*5, 1, c(0.6, 0.75, 0.85, 0.9, 0.95)), nrow=5)
method3_res <- matrix(rbinom(100*5, 1, c(0.2, 0.8, 0.9, 0.93, 0.95)), nrow=5)

sim_results <- cbind(c(5, 10, 20, 50, 100),
                     2 - method1_res,
                     2 - method2_res,
                     2 - method3_res)

colnames(sim_results) <- c("n", paste("method1_", rep(1:100), sep=""),
                           paste("method2_", rep(1:100), sep=""),
                           paste("method3_", rep(1:100), sep=""))

sim_results <- as.data.frame(sim_results)

write.csv(sim_results, "sim_results.csv", row.names = F)


sim_results |>
  mutate(across(-n, function(x) {2 - x})) |>
  rowwise() |>
  mutate(method1 = mean(c_across(contains("method1"))),
         method2 = mean(c_across(contains("method2"))),
         method3 = mean(c_across(contains("method3")))) |>
  select(n, method1, method2, method3) |>
  pivot_longer(-n, 
               names_to = "method",
               values_to = "coverage") |>
  ggplot(aes(x = n, y = coverage, color = method)) +
  geom_point() +
  geom_line()



# function to calculate coefficients

n <- 100
x <- rnorm(n)
noise <- rnorm(n)
y <- 1 + x + noise

lm(y ~ x)

X <- cbind(1, x)

solve(t(X) %*% X) %*% t(X) %*% y
