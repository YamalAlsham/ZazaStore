var request = require("request");

var options = {
  method: 'POST',
  url: 'https://api.ultramsg.com/instance1150/messages/chat',
  headers: {'content-type': 'application/x-www-form-urlencoded'},
  form: {
    token: 'Instance_token',
    to: '0969132045',
    body: 'WhatsApp API on UltraMsg.com works good',
    priority: '10',
    referenceId: ''
  }
};

request(options, function (error, response, body) {
  if (error) throw new Error(error);

  console.log(body);
});