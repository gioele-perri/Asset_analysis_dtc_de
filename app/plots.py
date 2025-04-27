import plotly.graph_objects as go

def plot_bar_chart(group, selected_tickers, aggregation_level, title, yaxis_title):
    fig = go.Figure()
    for ticker in selected_tickers:
        group_ticker = group[group["Ticker"] == ticker]
        fig.add_trace(go.Bar(x=group_ticker.iloc[:, 1], y=group_ticker["mean"], name=ticker))
    fig.update_layout(
        title=title,
        yaxis_title=yaxis_title,
        xaxis_title=aggregation_level,
        template="plotly_white",
        showlegend=True,
        barmode='group'
    )
    return fig

def plot_cumulative_return(filtered_df, selected_tickers):
    fig = go.Figure()
    for ticker in selected_tickers:
        ticker_df = filtered_df[filtered_df["Ticker"] == ticker]
        if not ticker_df.empty:
            fig.add_trace(go.Scatter(
                x=ticker_df["Date"],
                y=ticker_df["Cumulative Return"],
                mode="lines",
                name=ticker
            ))
    fig.update_layout(
        title="Cumulative Return Over Time",
        xaxis_title="Date",
        yaxis_title="Cumulative Return",
        template="plotly_white",
        hovermode="x unified"
    )
    return fig

def plot_return_distribution(filtered_df, selected_tickers):
    fig = go.Figure()
    for ticker in selected_tickers:
        ticker_df = filtered_df[filtered_df["Ticker"] == ticker]
        if not ticker_df.empty:
            fig.add_trace(go.Histogram(x=ticker_df["Return"].dropna(), nbinsx=50, name=ticker))
    fig.update_layout(
        title="Return Distribution",
        xaxis_title="Return",
        yaxis_title="Frequency",
        template="plotly_white",
        barmode='overlay'
    )
    return fig

def plot_volatility(group, selected_tickers, aggregation_level):
    fig = go.Figure()
    for ticker in selected_tickers:
        group_ticker = group[group["Ticker"] == ticker]
        fig.add_trace(go.Bar(x=group_ticker.iloc[:, 1], y=group_ticker["std"], name=ticker))
    fig.update_layout(
        title=f"Volatility (Standard Deviation) by {aggregation_level}",
        yaxis_title="Volatility",
        xaxis_title=aggregation_level,
        template="plotly_white",
        barmode='group'
    )
    return fig
