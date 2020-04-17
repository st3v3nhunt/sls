const sqs = require('aws-sdk/clients/sqs');

module.exports.echo = async (event, ctx) => {
  const region = ctx.invokedFunctionArn.split(':')[3];
  const accountId = ctx.invokedFunctionArn.split(':')[4];
  const queueName = 'MyQueue'; // comes from serverless.yml config
  const queueUrl = `https://sqs.${region}.amazonaws.com/${accountId}/${queueName}`;

  return {
    statusCode: 200,
    await sqs.sendMessage({
      MessageBody: "MessageBody",
      QueueUrl: queueUrl,
    }).promise();
    console.log(`Message sent to queue: ${queueUrl}`);

    body: JSON.stringify(
      {
        message: 'Hello cruel world!!',
        input: event,
      },
      null,
      2
    ),
  };
};

module.exports.processQ = async event => {
  console.log(`Number of records in message: ${event.Records.length}`);
  event.Records.forEach((record, idx) => {
    console.log(`Record (${idx}): `, record);
  });
};
