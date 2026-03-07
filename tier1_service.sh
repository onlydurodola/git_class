#!/bin/bash
# Web Server Setup Script for Amazon Linux 2
# Save this as web-server-setup.sh

# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Start Apache service
systemctl start httpd

# Enable Apache to start on boot
systemctl enable httpd

# Create a simple HTML page
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Tier 1 Web Service</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            text-align: center;
            background-color: #f0f0f0;
        }
        h1 {
            color: #333;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>✅ Tier 1 Web Service Running Successfully!</h1>
        <p>Server configured on: <span id="datetime"></span></p>
        <p>Instance ID: <span id="instance-id">Fetching...</span></p>
    </div>
    
    <script>
        // Display current date/time
        document.getElementById('datetime').textContent = new Date().toLocaleString();
        
        // Fetch instance ID (requires IMDSv2)
        fetch('http://169.254.169.254/latest/meta-data/instance-id', {
            headers: {
                'X-aws-ec2-metadata-token-ttl-seconds': '21600'
            }
        })
        .then(response => response.text())
        .then(data => {
            document.getElementById('instance-id').textContent = data;
        });
    </script>
</body>
</html>
EOF

# Set proper permissions
chmod 644 /var/www/html/index.html

# Configure firewall (if enabled)
systemctl stop firewalld 2>/dev/null || true
systemctl disable firewalld 2>/dev/null || true

# Log completion
echo "Web server setup completed at $(date)" >> /var/log/web-server-setup.log
