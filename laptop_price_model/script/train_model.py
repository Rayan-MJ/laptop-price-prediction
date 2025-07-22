
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import pandas as pd
from pathlib import Path

cwd = Path().resolve()

data_path = model_path = cwd.parent / 'data' / 'raw'/ 'laptop_data (regression).csv'

df = pd.read_csv(data_path)

X = df.drop(['Product ID','Price ($)'],axis=1)

y = df['Price ($)']

X = pd.get_dummies(X, columns=['Brand', 'Type', 'CPU', 'GPU', 'Operating System','Hard Disk','Screen Specs'],dtype=int)

X['RAM'] = X['RAM'].str.replace('GB', '').astype(int)
X['Weight'] = X['Weight'].str.replace('kg', '').astype(float)


X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

model = RandomForestRegressor(random_state=45)
model.fit(X_train, y_train)

y_pred = model.predict(X_test)

mse = mean_squared_error(y_test, y_pred)
mae = mean_absolute_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

print("Mean Squared Error (MSE):", mse)
print("Mean Absolute Error (MAE):", mae)
print("R² Score:", r2)

#pred_df = pd.DataFrame(y_pred, columns=['Predicted_Price'], index=y_test.index)

# Combine actual y_test and predicted values
#result_df = pd.concat([y_test, pred_df], axis=1)

# Save to CSV
#result_df.to_csv('y_test_with_predictions.csv', index=True)
