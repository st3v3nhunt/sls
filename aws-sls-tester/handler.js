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
  console.log(`Number of records in message: ${event.Records.length}`);
  event.Records.forEach((record, idx) => {
    console.log(`Record (${idx}): `, record);
  });
};
