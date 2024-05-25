# Use the official Python image from the Docker Hub
FROM python:3.12-slim

# Add some metadata
LABEL maintainer="Ben Vicar Cain"
LABEL version="1.0"
LABEL description="Tempconverter app for DevOps class"

# Update system packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt /app/

# Install the app dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app code into the container
COPY . /app/

# Expose Flask port
EXPOSE 5000

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

# Run the Flask app
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
