# EC2 to OpenSearch Ingestion (OSI) Setup Guide

This repository contains scripts and configurations to set up log ingestion from an Amazon Linux EC2 instance to Amazon OpenSearch via OpenSearch Ingestion (OSI).

## Architecture
`EC2 (/var/log/messages) -> Fluentd -> OSI Pipeline -> OpenSearch Domain`

## 1. Prerequisites
- EC2 instance (Amazon Linux) with IAM role.
- OpenSearch Domain running.
- IAM permissions for EC2 to push to OSI (`osis:Ingest`).

## 2. Setup OpenSearch Ingestion Pipeline
1. Create an IAM Role for the pipeline (`OSI-To-OpenSearch-Role`) with a trust policy for `osis-pipelines.amazonaws.com`.
2. Attach a policy to this role allowing `es:ESHttp*` access to your OpenSearch domain.
3. Create the OSI Pipeline in the AWS Console using `osi-pipeline.yaml`.
4. Copy the **Ingestion URL** once the pipeline is active.

## 3. Install Fluentd on EC2
Run the installation script:
```bash
chmod +x install_fluentd.sh
sudo ./install_fluentd.sh
```

## 4. Configure Fluentd
1. Edit `/etc/fluent/fluentd.conf` (or `/etc/td-agent/td-agent.conf`).
2. Use the content from `fluentd.conf` in this repo.
3. Replace `<PLACEHOLDER_OSI_PIPELINE_ENDPOINT>` with your OSI endpoint URL (hostname only).
4. Restart Fluentd:
   ```bash
   sudo systemctl restart fluent-package
   ```

## 5. IAM Policy for EC2
Ensure the EC2 Instance Profile has the following permission:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "osis:Ingest",
            "Resource": "arn:aws:osis:<region>:<account-id>:pipeline/<pipeline-name>"
        }
    ]
}
```
