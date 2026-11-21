# Project Objective:

# The objective of this project is to build a Logistic
# Regression classification model using historical
# customer data to predict the probability of a potential
# customer purchasing a newly advertised SUV.

# Based on the predicted probabilities, customers are
# classified as likely buyers or non-buyers.


# 1. LOAD LIBRARIES
# Load the R packages required for data splitting and
# model evaluation.

library(caTools)
library(pROC)

# 2. LOAD DATASET
# Import the customer dataset into R.

data <- read.csv("Social_Network_Ads.csv")

# 3. INITIAL DATA EXPLORATION
# Understand the dataset's structure, dimensions,
# column names, summary statistics and missing values.

head(data)

str(data)

dim(data)

colnames(data)

summary(data)

colSums(is.na(data))

# Dataset contains 400 rows and 5 columns.
# Each row represents a customer.
# Purchased is the target variable (0 = No, 1 = Yes).
# Gender is a categorical variable and needs to be converted into a factor.
# User.ID is only an identifier and is not required for prediction.
# Customer age ranges from 18 to 60 years.
# Estimated salary ranges from 15,000 to 1,50,000.
# Approximately 35.75% of customers purchased the SUV.
# No missing values were found in the dataset.

# 4. EXPLORATORY DATA ANALYSIS (EDA)
# Explore the distribution of the target variable and
# relationships between customer attributes and purchases.

# 4.1 Purchase distribution

table(data$Purchased)

prop.table(table(data$Purchased))*100

# 64.25% of customers did not purchase the SUV.
# 35.75% of customers purchased the SUV.
# The dataset contains more non-buyers than buyers.

# 4.2 Visualize purchase distribution

barplot(
  table(data$Purchased),
  main = 'Purchase Distribution',
  xlab = "Purchased",
  ylab = 'Number of Customers',
  col = 'skyblue'
)

# 4.3 Age vs purchase behaviour

boxplot(
  Age ~ Purchased,
  data = data,
  main = "Age vs Purchase behaviour",
  xlab = "Purchased (0 = No, 1 = Yes)",
  ylab = "Age",
  col = c("skyblue", "orange")
)

# Older customers appear more likely to purchase the SUV.
# Median age is approximately 47 for buyers and 34 for non-buyers.

# 4.4 Estimated salary vs purchase behaviour

boxplot(
  EstimatedSalary ~ Purchased,
  data = data,
  main = "Estimated Salary vs Purchase behaviour",
  xlab = 'Purchased (0=No, 1=Yes)',
  ylab = 'Estimated Salary',
  col  = c("skyblue", 'orange')
)

# Buyers generally have higher estimated salaries than non-buyers.
# Buyers also show a wider spread of salaries (higher IQR).

# 5. DATA PREPROCESSING
# Convert categorical variables into factors and
# remove unnecessary columns.

str(data)

# convert gender into a factor
data$Gender <- as.factor(data$Gender)

# remove user_id
data$User.ID <- NULL

str(data)

head(data)

# Converted Gender from character to factor for classification.
# Removed User.ID because it is only an identifier 
# & not useful for prediction.
# Dataset now contains 4 columns: 
# Gender, Age, EstimatedSalary and Purchased.

# 6. TRAIN-TEST SPLIT
# Divide the dataset into training and testing sets.
# Use 80% for training and 20% for testing.

set.seed(123)

split <- sample.split(data$Purchased, SplitRatio=0.8)

training_set <- subset(data, split == TRUE)
test_set <- subset(data, split == FALSE)

# Verify the dimensions of both datasets.
dim(training_set)
dim(test_set)

# 7. MODEL BUILDING - LOGISTIC REGRESSION
# Train a logistic regression model using the training data.
# Purchased is the target variable.

model <- glm(
  Purchased ~ Gender + Age + EstimatedSalary,
  data = training_set,
  family = binomial
)
summary(model)

# Model Interpretation:

# Age and Estimated Salary have a positive relationship 
# with SUV purchase probability.

# Both Age and Estimated Salary are statistically 
# significant predictors (p-value < 0.05).

# Gender is not statistically significant (p-value = 0.328).

# The model shows improvement over the null model, 
# as residual deviance (208.88) is lower than null deviance (416.79).

# AIC value is 216.88 and can be used to compare models.

# 8. PREDICTION
# Generate purchase probabilities for unseen test data.

prob_pred <- predict(
  model,
  newdata = test_set,
  type = "response"
)

head(prob_pred, 10)

# Convert predicted probabilities into binary classes
# using a threshold of 0.5.

predicted_class <- ifelse(prob_pred >= 0.5, 1, 0)

head(predicted_class, 10)

table(predicted_class)

# 9. CONFUSION MATRIX
# Compare predicted classes with actual purchase values.

cm <- table(
  Predicted = predicted_class,
  Actual = test_set$Purchased
)

cm

# 9.1 Extract confusion matrix values
TP <- cm["1", "1"]
TN <- cm["0", "0"]
FP <- cm["1", "0"]
FN <- cm["0", "1"]

# Confusion Matrix Interpretation
# TN (44): Actual non-buyers correctly predicted as non-buyers.
# TP (21): Actual buyers correctly predicted as buyers.
# FP (7): Actual non-buyers incorrectly predicted as buyers.
# FN (8): Actual buyers incorrectly predicted as non-buyers.
# The model correctly classified 65 out of 80 customers.

# 10. MODEL EVALUATION
# Calculate classification performance metrics.

# 10.1 Accuracy
accuracy <- (TP + TN) / sum(cm)

# 10.2 Precision
precision <- TP / (TP + FP)

# 10.3 Recall
recall <- TP / (TP + FN)

# 10.4 Specificity
specificity <- TN / (TN + FP)

# results
accuracy
precision
recall
specificity

# 10.5 F1-score
f1_score <- 2 * (precision * recall) / (precision + recall)
f1_score

# Accuracy (81.25%): The model correctly classified 81.25% of 
# test observations.

# Precision (75%): 75% of the customers predicted as buyers 
# were actual buyers.

# Recall (72.41%): The model identified 72.41% of all actual buyers.

# Specificity (86.27%): The model correctly identified 
# 86.27% of actual non-buyers.

# F1-score (73.68%): Provides a balance between precision and recall.

# 11. ROC CURVE AND AUC
# Evaluate the model's ability to distinguish between
# buyers and non-buyers across different thresholds.

roc_curve <- roc(test_set$Purchased, prob_pred)

plot(roc_curve,
     main = "ROC Curve",
     col = "blue")

auc(roc_curve)

# The ROC curve is well above the diagonal baseline, 
# indicating good classification performance.

# AUC = 0.906 (90.6%), 
# indicating excellent ability to distinguish between buyers & non-buyers.

# 12. Final Conclusion

# Final Conclusion:
# The Logistic Regression model predicts the probability 
# of a customer purchasing the SUV.

# A 0.5 probability threshold is used to classify 
# customers as potential buyers (1) or non-buyers (0).

# The model achieved an accuracy of 81.25% and an AUC of 0.906.

# Age & Estimated Salary were significant predictors of SUV purchases.

# The model can help the company identify customers 
# who are more likely to purchase the SUV.