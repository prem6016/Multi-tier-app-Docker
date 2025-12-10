# AWS Security Group Configuration

## Required Security Group Rules

Configure your EC2 instance's security group to allow inbound traffic on the following ports:

### Port 8080 (Frontend - Required)

- **Type:** Custom TCP
- **Port:** 8080
- **Source:** 0.0.0.0/0 (or restrict to specific IPs/CIDR blocks)
- **Description:** Frontend web application access

### Port 5000 (API - Required)

- **Type:** Custom TCP
- **Port:** 5000
- **Source:** 0.0.0.0/0 (or restrict to specific IPs/CIDR blocks)
- **Description:** Backend API access

## Step-by-Step Configuration

### Via AWS Console:

1. **Navigate to EC2 Console**

   - Go to AWS Console → EC2 → Instances
   - Select your EC2 instance

2. **Access Security Group**

   - Click on the instance
   - In the "Security" tab, click on the Security Group name/link

3. **Edit Inbound Rules**

   - Click "Edit inbound rules"
   - Click "Add rule"

4. **Add Port 8080 Rule**

   - Type: Custom TCP
   - Port range: 8080
   - Source: 0.0.0.0/0 (or your specific IP/CIDR)
   - Description: Frontend access
   - Click "Add rule" again

5. **Add Port 5000 Rule**

   - Type: Custom TCP
   - Port range: 5000
   - Source: 0.0.0.0/0 (or your specific IP/CIDR)
   - Description: API access

6. **Save Rules**
   - Click "Save rules"

### Via AWS CLI:

```bash
# Get your security group ID
aws ec2 describe-instances --instance-ids <your-instance-id> --query 'Reservations[0].Instances[0].SecurityGroups[0].GroupId' --output text

# Add rule for port 8080
aws ec2 authorize-security-group-ingress \
    --group-id <your-security-group-id> \
    --protocol tcp \
    --port 8080 \
    --cidr 0.0.0.0/0 \
    --description "Frontend access"

# Add rule for port 5000
aws ec2 authorize-security-group-ingress \
    --group-id <your-security-group-id> \
    --protocol tcp \
    --port 5000 \
    --cidr 0.0.0.0/0 \
    --description "API access"
```

### Via Terraform (if using IaC):

```hcl
resource "aws_security_group_rule" "frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app.id
  description       = "Frontend access"
}

resource "aws_security_group_rule" "api" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app.id
  description       = "API access"
}
```

## Security Best Practices

1. **Restrict Source IPs**: Instead of `0.0.0.0/0`, use:

   - Your office IP: `YOUR.IP.ADDRESS/32`
   - Specific CIDR blocks: `10.0.0.0/8`
   - VPN CIDR: `YOUR.VPN.CIDR`

2. **Use Security Groups**: Reference other security groups instead of IPs when possible

3. **Review Regularly**: Periodically audit security group rules

## Verification

After configuring, verify access:

- Frontend: `http://<your-ec2-public-ip>:8080`
- API: `http://<your-ec2-public-ip>:5000/api/health`

## Troubleshooting

If you can't access the application:

1. Check security group rules are saved
2. Verify instance is running
3. Check if ports are listening: `sudo netstat -tuln | grep -E '8080|5000'`
4. Verify Docker containers are running: `docker-compose ps`
5. Check EC2 instance firewall/iptables rules
