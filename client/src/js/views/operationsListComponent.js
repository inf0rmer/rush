var React = require('react');
var request = require('../lib/request');

var OperationsListComponent = React.createClass({
  getInitialState: function () {
    return {
      items: this.props.operations || []
    }
  },

  componentDidMount: function () {
    if (!this.state.items.length) {
      this.refresh();
    }
  },

  render: function () {
    var operations = this.state.items.map(function (operation) {
      return <li key={operation}>{operation}</li>;
    });

    return <div>
             <button onClick={this.refresh}>Refresh</button>
             <ul>{operations}</ul>
           </div>;
  },

  refresh: function () {
    request.get("http://api.rush.dev/v1.0.0/military_operations")
      .then(function (results) {
        this.setState({
          items: results.responseText.military_operations
        });
      }.bind(this));
  }
});

module.exports = OperationsListComponent;
