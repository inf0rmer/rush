var React = require('react');
var OperationsListComponent = require('./views/operationsListComponent');

var App = function (domNode) {
  this.domNode = domNode;
}

App.prototype.render = function (operations) {
  React.render(
    <OperationsListComponent operations={operations}></OperationsListComponent>,
    this.domNode
  )
}

module.exports = App;
