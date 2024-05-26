# Use the official Python image from the Docker Hub
FROM python:3.12-slim

# Add some metadata
LABEL maintainer="Ben Vicar Cain"
LABEL version="1.0"
LABEL description="Tempconverter app for DevOps class"

# Update and install system packages
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

# Copy docker-entrypoint.sh that will handle Swarm secrets
COPY docker-entrypoint.sh /

# Set the entrypoint to docker-entrypoint.sh that will start Gunicorn
ENTRYPOINT ["/docker-entrypoint.sh"]

# Run the Flask app via Gunicorn
# Only needed if user will override ENTRYPOINT
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
