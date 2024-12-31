# Lighthouse Viewer Docker

A containerized solution for viewing and analyzing Google Lighthouse reports. This project provides a Docker image that runs a Lighthouse Viewer server, making it easy to host your own instance for viewing Lighthouse performance reports.

## 🚀 Features

- Self-hosted Lighthouse report viewer
- Dockerized for easy deployment
- Lightweight and fast
- Compatible with standard Lighthouse JSON reports
- Port 7333 exposed for web access

## 📋 Prerequisites

- Docker installed on your system
- Basic understanding of Docker commands
- Lighthouse JSON reports you want to view

## 🛠️ Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/lighthouse-viewer-docker.git
cd lighthouse-viewer-docker
```

2. Build the Docker image:
```bash
docker build -t lighthouse-viewer .
```

3. Run the container:
```bash
docker run -p 7333:7333 -d --name lighthouse-viewer lighthouse-viewer
```

The viewer will be available at `http://localhost:7333`

## 🧪 Running Tests

### Local Integration Tests

The project includes integration tests for both Caddy and Nginx server implementations. To run the tests:

1. Make sure Docker is running on your system
2. Execute the test script:
```bash
./run-tests.sh
```

This will:
- Build and test the Caddy implementation
- Build and test the Nginx implementation
- Provide detailed output for each test stage
- Clean up test containers and images automatically

The tests verify:
- Docker image builds successfully
- Container starts properly
- Server is accessible on the configured port
- Health checks pass
- Basic HTTP functionality works

If any test fails, you'll see detailed error output to help with debugging.

### Testing GitHub Workflows Locally

You can test the GitHub workflows locally before pushing changes using [act](https://github.com/nektos/act). This ensures your CI pipeline works as expected:

1. Install `act` (on macOS):
```bash
brew install act
```

2. Run the workflow:
```bash
act -v --container-architecture linux/amd64
```

This will:
- Run the entire workflow locally
- Execute all test stages
- Show detailed output for each step
- Clean up resources automatically

The `-v` flag provides verbose output, helpful for debugging, and the `--container-architecture` flag ensures compatibility with M1/M2 Macs.

Common issues and solutions:
- If you get Docker permission errors, ensure your user has proper Docker permissions
- For memory issues, adjust Docker's resource limits in Docker Desktop settings
- If tests fail, check the verbose output for specific error messages

## 🔧 Configuration

By default, the server runs on port 7333. You can modify the port mapping when running the container:

```bash
docker run -p <your-desired-port>:7333 -d --name lighthouse-viewer lighthouse-viewer
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

Please make sure to update tests as appropriate and follow the existing code style.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐️ Show your support

Give a ⭐️ if this project helped you!

## 📫 Contact

If you have any questions or suggestions, please open an issue in the repository.

## 🙏 Acknowledgments

- Google Lighthouse team for creating the excellent Lighthouse tool