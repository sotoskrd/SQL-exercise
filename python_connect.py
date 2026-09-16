"""
python_connect.py
-----------------
Starter script για να τρέξεις τα SQL queries της εξάσκησης μέσα από Python.

Χρειάζεσαι μόνο: Python 3 + pandas (η sqlite3 είναι built-in, δεν χρειάζεται install).
Εγκατάσταση pandas αν δεν το έχεις ήδη:
    pip install pandas --break-system-packages   (Linux/Mac)
    pip install pandas                            (Windows)

Βεβαιώσου ότι το chinook.db βρίσκεται στον ίδιο φάκελο με αυτό το script
(ή άλλαξε το DB_PATH παρακάτω).
"""

import sqlite3
import pandas as pd

DB_PATH = "chinook.db"


def get_connection():
    """Ανοίγει μια σύνδεση με τη βάση SQLite."""
    return sqlite3.connect(DB_PATH)


def run_query(sql: str, params: tuple = ()) -> pd.DataFrame:
    """
    Τρέχει ένα SQL query και επιστρέφει τα αποτελέσματα σαν pandas DataFrame.
    Χρήσιμο γιατί το DataFrame σου δίνει δωρεάν: όμορφο print, .to_csv(),
    φιλτράρισμα/ταξινόμηση σε Python, γραφήματα με matplotlib, κ.λπ.
    """
    with get_connection() as conn:
        return pd.read_sql_query(sql, conn, params=params)


def list_tables() -> list[str]:
    """Επιστρέφει τα ονόματα όλων των πινάκων της βάσης."""
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;")
        return [row[0] for row in cur.fetchall()]


if __name__ == "__main__":
    print("Πίνακες στη βάση:", list_tables())
    print()

    # --- Παράδειγμα 1: απλό query (Άσκηση 1) ---
    print("=== Top 5 καλλιτέχνες αλφαβητικά ===")
    df = run_query("SELECT Name FROM Artist ORDER BY Name LIMIT 5;")
    print(df)
    print()

    # --- Παράδειγμα 2: query με JOIN + GROUP BY (Άσκηση 24) ---
    print("=== Έσοδα ανά genre (Top 5) ===")
    df = run_query("""
        SELECT g.Name AS Genre, SUM(il.UnitPrice * il.Quantity) AS Revenue
        FROM Genre g
        JOIN Track t ON g.GenreId = t.GenreId
        JOIN InvoiceLine il ON t.TrackId = il.TrackId
        GROUP BY g.Name
        ORDER BY Revenue DESC
        LIMIT 5;
    """)
    print(df)
    print()

    # --- Παράδειγμα 3: query με παράμετρο (π.χ. φιλτράρισμα δυναμικά από Python) ---
    country = "Brazil"
    print(f"=== Πελάτες από {country} ===")
    df = run_query(
        "SELECT FirstName, LastName, City FROM Customer WHERE Country = ?;",
        params=(country,),
    )
    print(df)
    print()

    # --- Παράδειγμα 4: αποθήκευση αποτελέσματος σε CSV ---
    # df.to_csv("customers_brazil.csv", index=False)

    print("Έτοιμο! Άλλαξε τα queries παραπάνω ή γράψε τα δικά σου με run_query(...).")
