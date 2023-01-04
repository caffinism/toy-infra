  #!/bin/bash -xe
  exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
  yum update -y
  yum install -y httpd.x86_64
  systemctl start httpd.service
  systemctl enable httpd.service
  echo "I am ${service_name} instance!" > /var/www/html/index.html