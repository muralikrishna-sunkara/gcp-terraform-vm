#!/bin/bash

# Update package list
apt-get update

# Install nginx
apt-get install -y nginx

# Get instance metadata
INSTANCE_NAME=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name)
INSTANCE_ZONE=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/zone | cut -d'/' -f4)
INSTANCE_IP=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)

# Create DevOps HTML page
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps Demo - GCP</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 50px;
            max-width: 800px;
            width: 100%;
            animation: slideIn 0.6s ease-out;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        h1 {
            color: #667eea;
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .success-badge {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            padding: 15px 30px;
            border-radius: 50px;
            text-align: center;
            font-size: 1.2em;
            font-weight: bold;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(17, 153, 142, 0.4);
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        
        .info-card {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 20px;
            border-radius: 10px;
            border-left: 5px solid #667eea;
            transition: transform 0.3s ease;
        }
        
        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .info-card h3 {
            color: #667eea;
            margin-bottom: 10px;
            font-size: 1.1em;
        }
        
        .info-card p {
            color: #333;
            font-size: 0.95em;
            word-break: break-all;
        }
        
        .tech-stack {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 15px;
            margin: 30px 0;
        }
        
        .tech-badge {
            background: #667eea;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 0.9em;
            font-weight: 600;
            box-shadow: 0 4px 6px rgba(102, 126, 234, 0.3);
        }
        
        .footer {
            text-align: center;
            color: #666;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #eee;
        }
        
        .emoji {
            font-size: 2em;
            margin: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 DevOps Demo on GCP</h1>
        
        <div class="success-badge">
            ✅ Infrastructure Successfully Deployed!
        </div>
        
        <div class="info-grid">
            <div class="info-card">
                <h3>🖥️ Instance Name</h3>
                <p>${INSTANCE_NAME}</p>
            </div>
            
            <div class="info-card">
                <h3>🌍 Zone</h3>
                <p>${INSTANCE_ZONE}</p>
            </div>
            
            <div class="info-card">
                <h3>🌐 Public IP</h3>
                <p>${INSTANCE_IP}</p>
            </div>
            
            <div class="info-card">
                <h3>⚙️ Web Server</h3>
                <p>Nginx</p>
            </div>
        </div>
        
        <h2 style="text-align: center; color: #667eea; margin: 30px 0 20px 0;">Technology Stack</h2>
        
        <div class="tech-stack">
            <span class="tech-badge">Terraform</span>
            <span class="tech-badge">Google Cloud Platform</span>
            <span class="tech-badge">Ubuntu 22.04 LTS</span>
            <span class="tech-badge">Nginx</span>
            <span class="tech-badge">VPC Networking</span>
        </div>
        
        <div class="footer">
            <div class="emoji">🎉</div>
            <p><strong>Congratulations!</strong></p>
            <p>Your infrastructure is up and running successfully.</p>
            <p style="margin-top: 10px; font-size: 0.9em;">Deployed with ❤️ using Infrastructure as Code</p>
        </div>
    </div>
</body>
</html>
EOF

# Ensure nginx is running
systemctl enable nginx
systemctl start nginx

# Log completion
echo "Startup script completed successfully at $(date)" >> /var/log/startup-script.log
