const AWS = require('aws-sdk')
const fs = require('fs').promises

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

  await new AWS.SQS().sendMessage({
    MessageBody: { imageUrl },
    QueueUrl: queueUrl
  }).promise()

  return {
    statusCode: 200,
    body: JSON.stringify({ message: `${imageUrl} is being procesed.` })
  }
}

module.exports.process = async event => {
  const s3 = await new AWS.S3()
  event.Records.forEach(async (record, idx) => {
    console.log(record)
    await fs.writeFile('temp.txt', 'record.message', 'utf8')
    console.log('Processing message.')
    s3.putObject({
      Bucket: process.env.BUCKET,
      Key: 'temp.txt',
      Body: await fs.readFile('temp.txt')
    })
  })
}
