h1. Proposal: Replicating Masked Data File Workflow in AWS

h2. Overview

This proposal outlines three potential approaches to replicate the legacy Connect:Direct-based masked data file transfer process in AWS. Each option provides a mechanism to move masked data files from a production environment to a QA environment, allowing QA testers to perform manipulations before ingesting the data for testing.

h2. Option 1: Automated File Transfer via AWS Lambda

Description:
A masked data file is placed in an S3 bucket in the production AWS account. An AWS Lambda function listens for new objects in the source folder and automatically copies the file to a designated S3 bucket/folder in the QA environment. QA testers can then retrieve the file, perform the necessary manipulations locally, and manually upload the modified file to the ingestion S3 bucket.

Effort Required:

Medium: Requires setup of S3 buckets, Lambda function, IAM roles, and cross-account permissions (if applicable).

Moderate scripting effort to ensure file validation and logging.

Pros:

Fully automated transfer reduces manual errors.

Simple, event-driven architecture using native AWS services.

Minimal QA tester training required.

Easily auditable via CloudTrail and Lambda logs.

Cons:

Still requires manual manipulation/upload of the file after QA changes it.

No UI for file visibility—QA must know where to download/upload files.

Difficult to trace if files are accidentally modified or misplaced after transfer.

h2. Option 2: Controlled Transfer via GitLab CI/CD Jobs

Description:
Files are moved through controlled GitLab jobs. A QA tester or developer can trigger a pipeline, passing in parameters (e.g., file name, source, destination). The job uses AWS CLI or SDK commands to move the file between S3 buckets.

Effort Required:

Medium to High: Requires CI/CD pipeline scripting, GitLab Runner setup, secret management, and permissions configuration.

Requires clear documentation and training for testers to use job variables properly.

Pros:

Controlled and auditable file movements.

Encourages discipline and logging of who moved what, when, and where.

Fully integrates with existing GitLab CI/CD workflows.

Cons:

Requires familiarity with GitLab and pipelines.

Slightly higher learning curve for QA testers.

More manual compared to Lambda automation.

Triggering jobs for each file can be cumbersome for bulk processing.

h2. Option 3: Angular Web UI for S3 File Management

Description:
A custom Angular-based web application allows users to view files in a source S3 folder and select files to download. After making the necessary changes locally, users can upload the manipulated file to a target S3 folder. This app would include basic file browsing, upload/download functionality, and optional metadata tagging.

Effort Required:

High: Requires front-end development, S3 integration (via AWS SDK), authentication (e.g., Cognito), permission controls, and secure deployment.

DevOps setup for hosting the web app (e.g., in S3 or ECS) and handling secure access.

Pros:

User-friendly UI for testers and non-technical users.

Clear visibility into files available, transferred, or pending.

Can be enhanced over time with approval workflows or audit logs.

Cons:

Highest upfront development and maintenance effort.

Security risks must be carefully managed (S3 access, identity management).

Longer lead time to deliver MVP.

h2. Summary Comparison Table

|| Option || Description || Effort || Pros || Cons || |--|--|--|--|--|--| | 1 | Lambda Automation | Files auto-copied from Prod S3 to QA S3 | Medium | Simple, fast, low-maintenance | No UI, manual final upload | | 2 | GitLab CI/CD Jobs | File movement controlled via GitLab variables | Medium-High | Controlled, auditable, integrates with CI/CD | Steeper learning curve for testers | | 3 | Angular Web UI | Full-featured web interface for QA testers | High | Friendly UI, scalable, intuitive | High effort, needs secure hosting |

h2. Recommendation

If the priority is low overhead and quick implementation, Option 1 (Lambda automation) is recommended. If auditability and controlled handling are critical, Option 2 (GitLab Jobs) is suitable. For long-term usability and non-technical access, Option 3 (Angular Web UI) offers the best UX but requires higher investment.



🟩 Option 1: Lambda Automation
1. Title: Create S3 Buckets and Folder Structure for Masked Data Workflow
Summary: Set up source and destination S3 buckets/folders in Prod and QA accounts for masked data file transfers.

2. Title: Develop AWS Lambda Function for S3 File Transfer
Summary: Create a Lambda function to trigger on S3 upload events and copy masked files from the Prod bucket to the QA bucket.

3. Title: Configure IAM Roles and Policies for Lambda Access
Summary: Create and assign IAM roles that allow the Lambda function to access source and destination S3 buckets securely.

4. Title: Set Up CloudWatch Logging and Alerts for Lambda Execution
Summary: Configure CloudWatch to log Lambda executions and raise alerts on failures.

5. Title: Perform End-to-End Test of Lambda-Based File Transfer
Summary: Upload a test file to the source S3 bucket and verify that it is successfully transferred and accessible in QA.

🟨 Option 2: GitLab CI/CD Controlled Transfer
1. Title: Write GitLab Job Script to Move Files Between S3 Buckets
Summary: Develop a GitLab CI job that moves files based on input variables specifying source and destination S3 paths.

2. Title: Configure GitLab CI/CD Variables for S3 Access
Summary: Store AWS credentials and required environment variables securely in GitLab for use in the CI pipeline.

3. Title: Create IAM User/Roles for GitLab CI Access to S3
Summary: Configure IAM with limited S3 permissions to enable secure file movement from GitLab jobs.

4. Title: Document Usage Instructions for QA Testers
Summary: Provide step-by-step guidance on how to trigger the GitLab job with appropriate parameters.

5. Title: Test GitLab File Transfer Workflow
Summary: Run the GitLab job with a sample file and validate the file is correctly moved between buckets.

🟦 Option 3: Angular Web UI for S3 File Management
1. Title: Design Angular Web UI Layout and Features for S3 File Handling
Summary: Define and mock up the layout and core functionality of the Angular app including file browsing, download, and upload.

2. Title: Set Up Angular Project and Integrate AWS SDK
Summary: Create the Angular project and implement basic S3 listing, file download, and upload features using AWS SDK.

3. Title: Configure AWS Cognito for User Authentication
Summary: Implement secure authentication to restrict access to authorized QA testers only.

4. Title: Create IAM Roles and S3 Bucket Policies for Web Access
Summary: Define the required IAM roles and permissions for the Angular app to securely access S3 resources.

5. Title: Deploy Angular App to AWS (S3 or Amplify)
Summary: Package and deploy the Angular app to a suitable AWS hosting service with a public/private access layer.

6. Title: QA Testing and Feedback Collection on Web App
Summary: Allow selected users to test the web interface and provide feedback for improvements.
