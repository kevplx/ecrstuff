# GitLab CI/CD Pipeline for Secrets Management

This GitLab CI/CD pipeline automates the process of handling certificates, passwords, and securely pushing them to **AWS Secrets Manager**. It is designed to convert `.p12` certificates to **Base64 encoding** and securely store them, along with their corresponding passwords, as JSON secrets in **AWS Secrets Manager**.

## Overview of the Pipeline

The pipeline consists of the following stages:

1. **prepare_files**: Prepares the folder names and creates a list.
2. **base64_conversion**: Converts `.p12` certificates to Base64 encoding.
3. **push_to_aws**: Pushes the certificates and passwords as secrets to AWS Secrets Manager.

---

## Breakdown of Each Stage

### 1. `prepare_files`
In this initial stage, the pipeline prepares the necessary data for the next steps. It renames certificates, creates a list of folder names (used to identify which secrets to update in AWS), and stores them in a file (`folders.txt`). This file is passed as an artifact to the next stage.

#### Key Actions:
- **Renames certificates** according to naming conventions.
- **Creates a `folders.txt` file** that contains a list of folder names (e.g., `ABC`, `DEF`, `GHI`) used to identify the corresponding secrets.
- The **`folders.txt` file is saved as an artifact** for use in later stages.

#### Example Output (`folders.txt`):
