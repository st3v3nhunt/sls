const AWS = require('aws-sdk')

const s3 = new AWS.S3()
const sqs = new AWS.SQS()

module.exports.submit = async (event, ctx) => {
  console.log(event)
  const body = event.body
  if (!body) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Please supply a message in the body.' })
    }
  }
  const message = JSON.parse(body).message

  const region = ctx.invokedFunctionArn.split(':')[3]
  const accountId = ctx.invokedFunctionArn.split(':')[4]
  const queueName = process.env.QUEUE_NAME
  const queueUrl = `https://sqs.${region}.amazonaws.com/${accountId}/${queueName}`

  await sqs.sendMessage({
    MessageBody: JSON.stringify({ message }),
    QueueUrl: queueUrl
  }).promise()

  return {
    statusCode: 200,
    body: JSON.stringify({ message: `${message} is being processed.` })
  }
}

module.exports.process = async event => {
  console.log('Starting to process the message...')
  console.log(event)
  event.Records.forEach(async record => {
    console.log('Message body:')
    console.log(record.body)
    await s3.putObject({
      Bucket: process.env.BUCKET,
      Key: 'temp.txt',
      Body: JSON.parse(record.body).message
    })
      .promise()
      .catch((err) => {
        console.log(err)
      })
      .then((msg) => {
        console.log('File has been created in s3')
        console.log(msg)
      })
  })
}

module.exports.view = async event => {
  const buf = await s3.getObject({
    Bucket: 'aws-lmda-test-bucket',
    Key: 'temp.txt'
  }).promise()

  return {
    statusCode: 200,
    body: buf.Body.toString()
  }
}
