import pandas as pd

# Правильний роздільник — крапка з комою
df = pd.read_csv('lol_2025(2).csv', sep=';', engine='python', on_bad_lines='skip')

# Подивимось перші рядки
print(df.head())