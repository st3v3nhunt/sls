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

In order to deploy the application via Terraform:

- Install terraform and initialise it

## Testing

```

```
