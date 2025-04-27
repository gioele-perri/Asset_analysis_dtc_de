# Dockerfile

FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential curl && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the entire project (including the root and app folder)
COPY . .

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Expose Streamlit port
EXPOSE 8501


# Run the app with shell to expand environment variables
CMD ["sh", "-c", "streamlit run main.py --server.port=$PORT --server.enableCORS=false --server.enableXsrfProtection=false"]
