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