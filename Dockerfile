# 1. Use a slim base image
FROM python:3.9-slim

# 2. Add required metadata labels
LABEL maintainer="Fazal ur Rehman"
LABEL version="1.0"
LABEL description="Optimized Sakila Flask Application"

# 3. Create a non-root user for security
RUN useradd -m appuser

WORKDIR /app

# 4. Leverage layer caching by installing dependencies FIRST
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the actual application code
COPY . .

# 6. Change ownership of files to the non-root user
RUN chown -R appuser:appuser /app

# 7. Switch to the non-root user
USER appuser

# 8. Expose ONLY the necessary port
EXPOSE 5000

# 9. Add a Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:5000/ || exit 1

CMD ["python", "app.py"]