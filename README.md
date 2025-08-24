
# 🚀 EnigMano Free RDP Solution

**Get unlimited free Windows RDP access with 64-core CPU, 16GB RAM, and 3GB/s internet speed using GitHub Actions!**

![EnigMano Banner](https://img.shields.io/badge/EnigMano-Free%20RDP-blue?style=for-the-badge&logo=windows&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-Powered-green?style=for-the-badge&logo=github&logoColor=white)
![ngrok](https://img.shields.io/badge/ngrok-Tunneling-orange?style=for-the-badge&logo=ngrok&logoColor=white)

## 🎯 What is EnigMano?

**EnigMano** (Enigma + Mano = "Hand of Mystery") is an automated solution that leverages GitHub Actions' free compute resources to provide high-performance Windows RDP instances. This project implements the exact methodology demonstrated by Shahzaib Khan in his viral YouTube video.

### ⚡ Key Features

- **🆓 Completely Free**: Uses GitHub Actions free tier (2000 minutes/month)
- **💪 High Performance**: AMD EPYC 7763 64-Core CPU, 16GB RAM
- **🌐 Fast Internet**: ~3GB/s connection speed
- **🔒 Secure Access**: Built-in VPN, ad-blockers, and privacy tools
- **🚀 One-Click Deploy**: Automated setup via GitHub workflows
- **🔄 Multi-Instance**: Deploy multiple RDP instances simultaneously
- **⏰ Long Sessions**: Up to 6 hours per deployment

## 🛠️ System Specifications

| Component | Specification |
|-----------|---------------|
| **CPU** | AMD EPYC 7763 64-Core Processor |
| **RAM** | 16GB DDR4 |
| **Storage** | SSD (Temporary) |
| **Internet** | 2916.99 Mbps ↓ / 968.97 Mbps ↑ |
| **OS** | Windows Server (Latest) |
| **Access** | RDP via ngrok tunnel |

## 🚀 Quick Start Guide

### Prerequisites

1. **GitHub Account** (Free)
2. **ngrok Account** (Free tier available)
3. **Remote Desktop Client** (Built into Windows, available for Mac/Linux)

### Step 1: Fork This Repository

1. Click the **Fork** button at the top of this repository
2. Clone your forked repository or work directly on GitHub

### Step 2: Get ngrok Auth Token

1. Sign up at [ngrok.com](https://ngrok.com) (free account)
2. Go to [Your Authtoken](https://dashboard.ngrok.com/get-started/your-authtoken)
3. Copy your authtoken

### Step 3: Configure Repository Secrets

1. Go to your forked repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add the following secret:
   - **Name**: `NGROK_SHAHZAIB`
   - **Value**: Your ngrok authtoken

### Step 4: Deploy RDP Instance

1. Go to **Actions** tab in your repository
2. Click on **EnigMano Instance Deployment** workflow
3. Click **Run workflow**
4. Enter an instance number (1-10)
5. Click **Run workflow**

### Step 5: Connect to Your RDP

1. Wait for the workflow to complete (2-3 minutes)
2. Check the workflow logs for connection details
3. Look for the connection box with:
   - **Host**: ngrok tunnel address
   - **Username**: `runneradmin`
   - **Password**: `P@ssw0rd!`
4. Use Remote Desktop Connection to connect

## 📋 Connection Instructions

### Windows
1. Press `Win + R`, type `mstsc`, press Enter
2. Enter the ngrok host address
3. Use the provided credentials
4. Click **Connect**

### Mac
1. Download Microsoft Remote Desktop from App Store
2. Add new PC with ngrok host address
3. Use the provided credentials

### Linux
1. Install `remmina` or `freerdp`
2. Connect using: `xfreerdp /v:ngrok-host /u:runneradmin /p:P@ssw0rd!`

## 🔧 Advanced Configuration

### Custom Software Installation

Edit `.github/workflows/windows-rdp.yml` to add your software:

```yaml
- name: Install Custom Software
  run: |
    choco install vscode -y
    choco install git -y
    choco install python -y
```

### Multiple Instances

Run the workflow multiple times with different instance numbers to create multiple RDP sessions simultaneously.

### Extended Sessions

The default session lasts up to 6 hours. To extend:
- Re-run the workflow before the current session expires
- Use multiple GitHub accounts for more compute time

## 🛡️ Security Features

### Pre-installed Security Tools
- **Cloudflare WARP VPN**: Encrypted internet connection
- **uBlock Origin**: Ad and tracker blocking
- **Ghostery**: Privacy protection
- **Secure RDP**: Network-level authentication enabled

### Best Practices
- Change default password after first connection
- Enable Windows Firewall
- Use VPN for additional privacy
- Don't store sensitive data (sessions are temporary)

## 📊 Performance Benchmarks

Based on testing, you can expect:

- **CPU Performance**: Excellent for development, compilation, light gaming
- **RAM Usage**: 16GB available, ~2GB used by system
- **Network Speed**: Perfect for streaming, downloads, web browsing
- **Storage**: Fast SSD, but temporary (data lost after session)

## 🔍 Troubleshooting

### Common Issues

**❌ Workflow fails to start**
- Check if GitHub Actions is enabled in repository settings
- Verify ngrok token is correctly set in secrets

**❌ Can't connect to RDP**
- Ensure you're using the correct ngrok host from workflow logs
- Check if your firewall blocks RDP connections
- Try different RDP client

**❌ ngrok tunnel not working**
- Verify ngrok authtoken is valid
- Check ngrok account limits (free tier has restrictions)
- Wait a few minutes and try again

**❌ Session disconnects frequently**
- Keep the GitHub Actions workflow window open
- Don't close the PowerShell window in RDP session
- Check your internet connection stability

### Getting Help

1. Check the [Issues](../../issues) section
2. Review workflow logs for error messages
3. Verify all prerequisites are met
4. Try with a fresh ngrok token

## ⚖️ Legal & Ethical Usage

### ✅ Acceptable Use
- Software development and testing
- Educational purposes
- Personal productivity tasks
- Learning and experimentation

### ❌ Prohibited Activities
- Cryptocurrency mining
- Illegal content distribution
- DDoS attacks or hacking
- Commercial use without proper licensing
- Violating GitHub Terms of Service

### Important Notes
- This uses GitHub's free resources - use responsibly
- Sessions are temporary - don't store important data
- Respect GitHub's Terms of Service and Fair Use Policy
- Consider upgrading to paid plans for heavy usage

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch
3. **Make** your improvements
4. **Test** thoroughly
5. **Submit** a pull request

### Areas for Contribution
- Additional software packages
- Performance optimizations
- Security enhancements
- Documentation improvements
- Bug fixes and stability

## 📈 Roadmap

### Upcoming Features
- [ ] GPU-enabled instances (when available)
- [ ] Persistent storage options
- [ ] Custom Windows images
- [ ] Multi-cloud deployment
- [ ] Web-based management interface
- [ ] Automated backups
- [ ] Load balancing across instances

## 🙏 Acknowledgments

- **Shahzaib Khan** - Original EnigMano concept and implementation
- **GitHub** - For providing free compute resources
- **ngrok** - For reliable tunneling service
- **Community** - For testing, feedback, and contributions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Support the Project

If this project helped you, please:
- ⭐ Star this repository
- 🍴 Fork and contribute
- 📢 Share with others
- 🐛 Report issues
- 💡 Suggest improvements

---

**Disclaimer**: This project is for educational and personal use. Users are responsible for complying with GitHub's Terms of Service and applicable laws. The authors are not responsible for any misuse of this software.

---

<div align="center">

**🚀 Happy Computing with EnigMano! 🚀**

Made with ❤️ by the EnigMano Community

</div>
