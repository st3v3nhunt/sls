const AWS = require('aws-sdk')
const fs = require('fs').promises

const s3 = new AWS.S3()
const sqs = new AWS.SQS()

module.exports.submit = async (event, ctx) => {
  const imageUrl = event.imageUrl
  if (!imageUrl) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Please supply an imageUrl.' })
    }
  }

  const region = ctx.invokedFunctionArn.split(':')[3]
  const accountId = ctx.invokedFunctionArn.split(':')[4]
  const queueName = process.env.QUEUE_NAME
  const queueUrl = `https://sqs.${region}.amazonaws.com/${accountId}/${queueName}`

  await sqs.sendMessage({
    MessageBody: JSON.stringify({ imageUrl }),
    QueueUrl: queueUrl
  }).promise()

  return {
    statusCode: 200,
    body: JSON.stringify({ message: `${imageUrl} is being procesed.` })
  }
}

module.exports.process = async event => {
  const buf = Buffer.from('some string')
  event.Records.forEach(async (record, idx) => {
    console.log(record)
    console.log('Processing message.')
    s3.putObject({
      Bucket: process.env.BUCKET,
      Key: 'temp.txt',
      Body: buf
    })
  })
}
