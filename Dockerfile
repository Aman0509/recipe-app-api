FROM python:3.13-alpine

# maintainer details
LABEL maintainer="aman8055"

# https://stackoverflow.com/questions/59812009/what-is-the-use-of-pythonunbuffered-in-docker-file
ENV PYTHONUNBUFFERED=1

COPY requirements.txt /tmp/requirements.txt

# copy code into 'app' folder inside the container
COPY ./app /app

# change working directory to 'app'
WORKDIR /app

# expose port 8000 from the container to the host
EXPOSE 8000

# 1. create a virtual environment - It's not necessary to create a virtual environment in Docker, but it's a good practice to isolate dependencies. This is especially useful if you plan to run multiple applications in the same container or if you want to avoid conflicts with system packages.
# 2. upgrade pip
# 3. install dependencies
# 4. remove requirements.txt
# 5. create a non-root user, 'django-user' - It's a good security practice to run applications as a non-root user inside containers. This minimizes the risk of privilege escalation attacks. Disabled password and no home directory are used to create a user that cannot log in interactively.
RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# set the PATH environment variable to include the virtual environment's bin directory - This ensures that when you run Python or pip commands, they use the versions from the virtual environment.        
ENV PATH="/venv/bin:$PATH"

USER django-user