const AWS = require('aws-sdk')

const s3 = new AWS.S3()
const sqs = new AWS.SQS()

module.exports.submit = async (event, ctx) => {
  const body = event.body
  if (!body && !body.message) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Please supply a message in the body.' })
    }
  }

  const region = ctx.invokedFunctionArn.split(':')[3]
  const accountId = ctx.invokedFunctionArn.split(':')[4]
  const queueName = process.env.QUEUE_NAME
  const queueUrl = `https://sqs.${region}.amazonaws.com/${accountId}/${queueName}`

  await sqs.sendMessage({
    MessageBody: JSON.stringify({ messge: body.message }),
    QueueUrl: queueUrl
  }).promise()

  return {
    statusCode: 200,
    body: JSON.stringify({ message: `${body.message} is being procesed.` })
  }
}

module.exports.process = async event => {
  event.Records.forEach(async (record, idx) => {
    console.log('Message body:')
    console.log(record.body)
    await s3.putObject({
      Bucket: process.env.BUCKET,
      Key: 'temp.txt',
      Body: record.body.message
    }).promise()
    console.log('File has been created in s3')
  })
}
