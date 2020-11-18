## Methodology
To analyze  dashboard usage, a Market Basket Analysis (MBA) was performed to determine what combinations of dashboards are frequently used together (note: order does not matter). MBA generates probabilistic if-then statements (i.e., the “rules”). MBA is useful for anticipating users’ behavior when considering dashboard organization, accessibility and consolidation. 
The Apriori algorithm was applied using the arules package in R to calculate frequent itemsets based on the minimum support threshold specified in the parameters of the model. Confidence and lift were calculated for all frequent itemsets. Note that only itemsets between size 2 and 5 were included.  

## Data Preprocessing
All commas were removed from dashboard titles. The all rows with the dashboard category categorized as ‘landing pages’ were removed.  There were no duplicates and no missing values in the data. 
The data frame was processed so that each tuple is a unique combination of ‘Campus.ID’ and ‘Date’. Therefore, each tuple lists the dashboards a user accessed on a particular day. For lists of more than one dashboard, dashboard names are separated by commas.

## Key Terms for Interpretation of Results

### Antecedent
The “if” part of the rule. 
### Consequent
The “then” part of the rule.
### Support
Probability of the antecedent and consequent.
### Confidence
Conditional probability of consequent occurring, given that the antecedent occurred. 
### Lift
The ratio of the confidence of the rule and the expected confidence of the rule. The expected confidence of a rule is defined as the product of the support values of the rule body and the rule head divided by the support of the rule body. The expected confidence is identical to the support of the rule head. Note: Only rules with lifts > 1 were included in reports. 

{% include heavyusers_rules_network.html %}
