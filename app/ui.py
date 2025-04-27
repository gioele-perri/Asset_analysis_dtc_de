import streamlit as st

def show_ticker_selection(df, aggregation_level):
    selected = st.multiselect(
        f"Select tickers to display in charts ({aggregation_level})",
        options=df["Ticker"].unique(),
        default=df["Ticker"].unique()
    )
    return selected

def show_warning(message):
    st.warning(message)
