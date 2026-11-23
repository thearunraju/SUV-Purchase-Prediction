# 1. load required libraries

library(caTools)
library(rpart)

# 2. load the dataset

data <- read.csv("Social_Network_Ads.csv")

head(data)
str(data)

# 3. Select relevant columns

data <- data[3:5]

# Selected Age, EstimatedSalary and Purchased.
# User.ID and Gender are excluded from this model.

# Convert Purchased into a factor
data$Purchased <- factor(data$Purchased, levels = c(0, 1))

str(data)

table(data$Purchased)

# 4. Split the dataset into training and testing sets
# 80% of the data is used for training and 20% for testing.
# Stratified sampling maintains the target class proportions.

set.seed(123)

split <- sample.split(data$Purchased, SplitRatio = 0.8)

training_set <- subset(data, split == TRUE)

test_set <- subset(data, split == FALSE)

nrow(training_set)

nrow(test_set)

table(training_set$Purchased)

table(test_set$Purchased)

# 5. Build the Decision Tree model

classifier <- rpart(
  Purchased ~ .,
  data = training_set,
  method = "class"
)

# 6. Visualise the Decision Tree

plot(classifier)

text(classifier, use.n = TRUE)

# 7. Predict probabilities

prob_pred <- predict(
  classifier,
  newdata = test_set,
  type = "prob"
)

# Predicted probabilities represent the likelihood of purchasing an SUV.
# Extracted the probability of class 1 (Purchased).

prob_pred <- prob_pred[, "1"]

head(prob_pred)

# 8. Convert probabilities into predicted classes

predicted_class <- ifelse(prob_pred >= 0.5, 1, 0)

head(predicted_class)
# 9. Create the confusion matrix

cm <- table(
  Predicted = predicted_class,
  Actual = test_set$Purchased
)

cm

# TN (44): Actual non-buyers correctly predicted as non-buyers.
# TP (24): Actual buyers correctly predicted as buyers.
# FP (7): Actual non-buyers incorrectly predicted as buyers.
# FN (5): Actual buyers incorrectly predicted as non-buyers.
# The model correctly classified 68 out of 80 customers.

# 10. Calculate performance metrics

TP <- cm["1", "1"]
TN <- cm["0", "0"]
FP <- cm["1", "0"]
FN <- cm["0", "1"]

accuracy <- (TP + TN) / sum(cm)
precision <- TP / (TP + FP)
recall <- TP / (TP + FN)
specificity <- TN / (TN + FP)
f1_score <- 2 * precision * recall / (precision + recall)

accuracy
precision
recall
specificity
f1_score

# Accuracy (85%): The model correctly classified 85% of test observations.
# Precision (77.42%): 77.42% of predicted buyers were actual buyers.
# Recall (82.76%): The model identified 82.76% of actual buyers.
# Specificity (86.27%): The model correctly identified 86.27% of actual non-buyers.
# F1-score (80%): Provides a balance between precision and recall.

# 11. ROC Curve and AUC

library(pROC)

roc_curve <- roc(test_set$Purchased, prob_pred)

plot(roc_curve, main = "ROC Curve - Decision Tree", col = "blue")

auc(roc_curve)

# The ROC curve is above the diagonal baseline,
# indicating good classification performance.

# AUC = 0.8796 (87.96%),
# indicating good ability to distinguish between buyers and non-buyers.

# 12. Final Conclusion

# The Decision Tree model estimates the probability 
# of a customer purchasing an SUV.

# A 0.5 probability threshold is used to classify customers 
# as buyers (1) or non-buyers (0).

# The model achieved 85% accuracy, 80% F1-score and an AUC of 0.8796.

# Age and Estimated Salary are used by the model to make predictions.

# The model can help the company identify potential SUV buyers.