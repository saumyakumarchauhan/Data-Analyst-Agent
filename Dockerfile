# Use Python 3.12 slim image as base
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set up a non-root user (Required for Hugging Face Spaces)
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# Change working directory to the user's home
WORKDIR $HOME/app

# Copy application files (Ensure the user owns them)
COPY --chown=user . $HOME/app

# Make entrypoint script executable
RUN chmod +x entrypoint.sh

# Expose the port Hugging Face expects
EXPOSE 7860

# Command to run the application
CMD ["./entrypoint.sh"]
