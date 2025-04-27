import yfinance as yf
import pandas as pd

def download_data(tickers, start_date, end_date):
    dfs = {}
    for ticker in tickers:
        df = yf.download(ticker, start=start_date, end=end_date, interval="1d")
        if not df.empty:
            df.index = pd.to_datetime(df.index)
            df["Return"] = df["Close"].pct_change()
            df["Cumulative Return"] = (1 + df["Return"]).cumprod()
            df["Ticker"] = ticker
            df["Weekday"] = df.index.day_name()
            df["Month"] = df.index.month
            df["Year"] = df.index.year
            df["Week"] = df.index.isocalendar().week
            dfs[ticker] = df
    return dfs

def aggregate_data(df, aggregation_level):
    if aggregation_level == "Day":
        weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        group = df.groupby(["Ticker", "Weekday"])["Return"].agg(["mean", "std", "count"]).reset_index()
        group["Weekday"] = pd.Categorical(group["Weekday"], categories=weekdays, ordered=True)
        group = group.sort_values(["Ticker", "Weekday"])
    elif aggregation_level == "Week":
        group = df.groupby(["Ticker", "Week"])["Return"].agg(["mean", "std", "count"]).reset_index()
    elif aggregation_level == "Month":
        group = df.groupby(["Ticker", "Month"])["Return"].agg(["mean", "std", "count"]).reset_index()
    elif aggregation_level == "Year":
        group = df.groupby(["Ticker", "Year"])["Return"].agg(["mean", "std", "count"]).reset_index()
    return group
