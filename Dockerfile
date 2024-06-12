FROM python:3.8.19-slim-bookworm

# disable suid and guid
# install build-essential and git
RUN find /usr/bin \( -perm /4000 -o -perm /2000 \) -type f -exec chmod a-s {} + && \
    apt-get update -y && \
    apt-get install --no-install-recommends build-essential git -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Create user and group
RUN groupadd -r appgroup && useradd -r -g appgroup -d /fppsomlops -s /sbin/nologin appuser

WORKDIR /fppsomlops

# Change ownership of the work directory
RUN chown appuser:appgroup /fpmlops

# Copy requirements.txt
COPY requirements.txt ./

# Install uwsgi and the requirements
# Upgrade pip
RUN python -m pip install --no-cache-dir --upgrade pip==24.0 && \
    python -m pip install --no-cache-dir uwsgi==2.0.26 && \
    python -m pip install --no-cache-dir -r requirements.txt

# Download spacy model
RUN python -m spacy download en_core_web_sm

# Copy all files
COPY . .

# Change ownership and permissions
RUN chown -R appuser:appgroup /fppsomlops && \
    chmod 755 entrypoint.sh

# Expose port 5000
EXPOSE 5000

# Switch to the non-root user
USER appuser

# Set entrypoint
ENTRYPOINT ["./entrypoint.sh"]
