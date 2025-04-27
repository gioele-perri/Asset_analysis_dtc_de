import streamlit as st
import pandas as pd
import os
import json
from app.data import download_data, aggregate_data
from app.plots import (
    plot_bar_chart,
    plot_cumulative_return,
    plot_return_distribution,
    plot_volatility,
)
from app.ui import show_ticker_selection, show_warning


# Config
st.set_page_config(page_title="Asset Behavioral Analysis", layout="wide")
st.title("📊 Asset Behavioral Analysis")

# Load EMBED_URL from JSON file
def load_embed_url():
    json_path = os.path.join("app", "variables.json")
    with open(json_path, "r") as file:
        config = json.load(file)
    return config.get("EMBED_URL", "")

EMBED_URL = load_embed_url()

def main():
    # Create tabs at the top level for better navigation
    analysis_tab, looker_tab = st.tabs(["Asset Analysis", "Looker Dashboard"])
    
    with analysis_tab:
        # Your existing analysis code here
        tickers_input = st.text_input("Enter asset tickers (comma-separated, e.g. ^GSPC, ^IXIC, ^DJI, BTC-USD)", value="^GSPC")
        col1, col2 = st.columns(2)
        with col1:
            start_date = st.date_input("Start Date", pd.to_datetime("2018-01-01"), max_value=pd.to_datetime("today"))
        with col2:
            end_date = st.date_input("End Date", pd.to_datetime("today"), max_value=pd.to_datetime("today"))
        aggregation_level = st.selectbox("Select aggregation period", ["Day", "Week", "Month", "Year"])

        uploaded_file = st.file_uploader("Or upload a CSV file for custom analysis", type=["csv"])

        if uploaded_file is not None:
            df_custom = pd.read_csv(uploaded_file)
            st.subheader("📊 Custom Data Preview")
            st.write(df_custom.head())
        else:
            if st.button("Analyze"):
                tickers = [ticker.strip() for ticker in tickers_input.split(",")]
                dfs = download_data(tickers, start_date, end_date)

                if not dfs:
                    show_warning("❌ No valid data found for any of the entered tickers.")
                    st.stop()

                combined_df = pd.concat(dfs.values()).reset_index()

                # Seleziona i ticker per visualizzare nei grafici
                selected_tickers = show_ticker_selection(combined_df, aggregation_level)
                filtered_df = combined_df[combined_df["Ticker"].isin(tickers)]
                group = aggregate_data(combined_df, aggregation_level)

                # Statistica di riepilogo
                st.subheader(f"📋 Statistical Summary by {aggregation_level}")
                st.dataframe(group.style.format({"mean": "{:.2%}", "std": "{:.2%}"}))

                # Tabs per visualizzazioni
                tab1, tab2, tab3, tab4 = st.tabs(["Average Return", "Cumulative Return", "Volatility", "Return Distribution"])

                with tab1:
                    st.subheader(f"📈 Average Return by {aggregation_level}")
                    if not group.empty:
                        fig1 = plot_bar_chart(group, tickers, aggregation_level, f"Average Return by {aggregation_level}", "Return")
                        st.plotly_chart(fig1, use_container_width=True)
                    else:
                        show_warning("⚠️ No data available for selected tickers in this tab.")

                with tab2:
                    st.subheader("📉 Cumulative Return Over Time")
                    fig2 = plot_cumulative_return(filtered_df, tickers)
                    st.plotly_chart(fig2, use_container_width=True)

                with tab3:
                    st.subheader(f"📊 Volatility (Standard Deviation) by {aggregation_level}")
                    if not group.empty:
                        fig3 = plot_volatility(group, tickers, aggregation_level)
                        st.plotly_chart(fig3, use_container_width=True)
                    else:
                        show_warning("⚠️ No data available for selected tickers in this tab.")

                with tab4:
                    st.subheader(f"📉 Return Distribution")
                    fig4 = plot_return_distribution(filtered_df, tickers)
                    st.plotly_chart(fig4, use_container_width=True)
                    
    with looker_tab:
        st.subheader("📊 Looker Dashboard Integration")
    
        # Responsive iframe with loading state
        with st.spinner("Loading dashboard..."):
            st.components.v1.html(f"""
            <div style="position: relative; width: 100%; height: 0; padding-bottom: 75%;">
                <iframe 
                    src="{EMBED_URL}" 
                    style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: 0;"
                    allowfullscreen
                ></iframe>
            </div>
            """, height=1200)

if __name__ == "__main__":
    main()