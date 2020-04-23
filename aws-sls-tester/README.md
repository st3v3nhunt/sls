# Severless testing

> The 'application' consists of an http endpoint that will create a message on
  a queue based on the input data. Another function will take the body of the
  message and update a file in an S3 bucket that has another function that will
  load it to view.

## Endpoints

- `submit` - creates message from input
- `process` - updates the S3 file
