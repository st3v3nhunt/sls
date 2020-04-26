# Severless testing

> The 'application' consists of two http endpoints and an sqs event sourced lambda.

The application flow is to submit a message via the `submit` endpoint. This
creates a message and sends it to an sqs queue. The message triggers the
`process` function which extracts the message and writes it to a file, which is
saved in an existing s3 bucket i.e. it is not created by either SLS or
terraform. The contents of the message can be read by the `view` endpoint which
loads the file from the s3 bucket and returns the message.

## Functions

- `submit` - creates a message from input
- `process` - updates the s3 file based on messages
- `view` - returns the contents of the s3 file

## Setup

### Serverless framework

In order to deploy the application via SLS framework

- Install SLS framework


### Terraform

In order to deploy the application via Terraform (tf), tf must be installed
and initialised - this must be done within the `/tf` directory.

With tf installed the function must exist in the correct s3 bucket e.g.
`aws-lambda-tf`.
Because the only npm dependency is `aws-adk` (and this is pre-installed within
the node runtime) the packaged function can just be the handler file i.e.
`handler.js`. This results in simply zipping up the file and copying it into
the s3 bucket being sufficient.

## Testing

```

```
