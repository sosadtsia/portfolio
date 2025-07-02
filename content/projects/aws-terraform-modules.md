---
title: "AWS Terraform Modules"
date: 2024-05-14
draft: false
---

## Overview

A collection of reusable Terraform modules for AWS infrastructure. These modules help standardize infrastructure deployment across multiple environments and projects.

## Features

- **VPC Module**: Creates a VPC with public and private subnets, NAT gateways, and route tables.
- **EKS Cluster Module**: Deploys a production-ready EKS cluster with node groups, IAM roles, and security groups.
- **RDS Module**: Sets up an RDS instance with security groups, parameter groups, and backup configurations.
- **S3 Module**: Creates S3 buckets with proper access controls, encryption, and lifecycle policies.
- **AWS Backup Module**: Sets up AWS Backup for EC2 and RDS instances.

## Technologies Used

- Terraform
- AWS
- GitHub Actions or AWS CodeStar (for CI/CD)

## Impact

These modules reduced environment provisioning time from 3 days to 30 minutes and ensured infrastructure consistency across all environments.

## GitHub Repository

TO DO: Add link to GitHub repository.
[View on GitHub](https://github.com/sosadtsia/aws-terraform-modules)
