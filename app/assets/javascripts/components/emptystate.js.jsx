var EmptyState = React.createClass({

    render: function() {
        return (
              <div className="empty">
                  <h2>{this.props.message}</h2>
              </div>

        )
   }
});