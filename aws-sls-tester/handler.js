module.exports.echo = async event => {
  return {
    statusCode: 200,
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
  console.log(`${event.Records.length}`);
  for (const record of event.Records) {
    const messageAttributes = record.messageAttributes;
    console.log('Message Attributtes -->  ', messageAttributes.AttributeNameHere.stringValue);
    console.log('Message Body -->  ', record.body);
  }
};
