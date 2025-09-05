# Apps Folder

This folder contains the source code and configuration for the main application.

## Files

- **main.py**: The main Python script for running the application.
- **requirements.txt**: Lists Python dependencies required to run the app.
- **Dockerfile**: Contains instructions to build a Docker image for the application.

## How to Run

### Using Python

1. Install dependencies:
    ```bash
    pip install -r requirements.txt
    ```
2. Run the application:
    ```bash
    python main.py
    ```

### Using Docker

1. Build the Docker image:
    ```bash
    docker build -t caladan-app .
    ```
2. Run the Docker container:
    ```bash
    docker run --rm caladan-app
    ```

## Notes

- Make sure you have Python 3 and Docker installed.
- Modify `main.py` as needed for your