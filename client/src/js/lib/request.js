var XMLHttpRequestPromise = require('xhr-promise');

var get = function request(url, data) {
  return new XMLHttpRequestPromise().send({
    method: 'GET',
    url: url,
    data: data
  });
}

module.exports = {
  get: get
}
