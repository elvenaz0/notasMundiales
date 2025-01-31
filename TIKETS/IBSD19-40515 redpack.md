

i-0024022a8e0a82bcc  listo
i-0bdea34f942784149  listo
i-0b87620f7bb5e4e52  listo

i-0cde5a65053f5b35f  listo
i-01792c9ab2d4f51a1  listo
i-0c3c8b45e7a323e50 ¿no existe?
i-0d75e18ae575f83a2  listo
i-069e6469e4db01e42  listo
i-02eee047a45e37f8b  listo
i-06730da1885392f9b  listo
i-06393fdb3dd9e89c0  listo
i-042a7addb6b7cea4f  listo
i-07f6acaac1222be9e  listo
i-09f96ed0fc8e9460d  ¿no existe?
i-069489c661f7036e7  listo
i-03902112934548d45 listo

sudo systemctl status amazon-cloudwatch-agent
sudo systemctl start amazon-cloudwatch-agent

for instance_id in i-0640240d4e96a38e6
do
  echo "Configurando instancia: $instance_id"
  aws ssm send-command \
    --instance-ids $instance_id \
    --document-name "AWS-RunShellScript" \
    --comment "Configurar Amazon CloudWatch Agent" \
    --parameters 'commands=[
      "rm -rf /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json",
      "aws s3 cp s3://s3temporalram/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json",
      "/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s",
      "sudo systemctl restart amazon-cloudwatch-agent",
      "sudo systemctl status amazon-cloudwatch-agent"
    ]' \
    --region us-west-2
done

aws ssm send-command \
  --instance-ids "i-0640240d4e96a38e6" \
  --document-name "AWS-RunShellScript" \
  --parameters '{"commands":["sudo cp /var/log/messages /tmp/messages && sudo aws s3 cp /tmp/messages s3://temporalparalogs/messages"]}' \
  --region us-west-2
sudo nano /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json



{
  "agent": {
    "metrics_collection_interval": 60,
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
  },
  "metrics": {
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "*"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          "disk_used_percent"
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "/"
        ]
      }
    }
  }
}


for instance_id i-0640240d4e96a38e6
do
  echo "Configurando instancia: $instance_id"
  aws ssm send-command \
    --instance-ids $instance_id \
    --document-name "AWS-RunShellScript" \
    --comment "Descargar y configurar CloudWatch Agent" \
    --parameters 'commands=["mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json", "aws s3 cp s3://s3temporalram/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"]' \
    --output-s3-bucket-name s3temporalram \
    --region us-west-2
done


i-0c3c8b45e7a323e50
i-0d75e18ae575f83a2
i-09f96ed0fc8e9460d


[[metricasinstancias]]
