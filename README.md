# SUV Purchase Prediction

## Project Overview
This project uses Machine Learning classification algorithms to predict whether a customer is likely to purchase an SUV based on their age, estimated salary and gender.

The objective is to help a company identify potential customers based on historical social media advertising data.

## Dataset
- **Dataset:** Social_Network_Ads.csv
- **Observations:** 400 customers
- **Features:** Gender, Age and Estimated Salary
- **Target Variable:** Purchased (0 = No, 1 = Yes)

`User.ID` was excluded because it is an identifier rather than a meaningful predictive feature.

## Technologies Used
- R
- caTools
- rpart
- pROC

## Project Workflow
1. Data loading and inspection
2. Exploratory Data Analysis (EDA)
3. Data preprocessing
4. Training and testing split (80:20)
5. Model development
   - Logistic Regression
   - Decision Tree
6. Probability prediction and classification
7. Model evaluation and comparison

## Model Performance

| Evaluation Metric | Logistic Regression | Decision Tree |
|---|---:|---:|
| Accuracy | 81.25% | 85.00% |
| Precision | 75.00% | 77.42% |
| Recall | 72.41% | 82.76% |
| Specificity | 86.27% | 86.27% |
| F1-Score | 73.68% | 80.00% |
| AUC | 0.906 | 0.8796 |

Both models use a probability threshold of 0.5 for classification.

**Note:** Logistic Regression uses Gender, Age and Estimated Salary, whereas the Decision Tree uses Age and Estimated Salary. Therefore, this comparison is not a controlled comparison of the algorithms alone.

## Key Findings
- Age and Estimated Salary were statistically significant predictors in the Logistic Regression model.
- The Decision Tree achieved higher accuracy and recall on the test dataset.
- Logistic Regression achieved a higher AUC, indicating better overall ranking ability across classification thresholds.
- Both models can help identify customers who are more likely to purchase an SUV.

## Conclusion
The project demonstrates how classification algorithms can be used to predict customer purchasing behaviour using historical advertising data.

The results show that model selection should consider the business objective and the evaluation metric, rather than accuracy alone.
