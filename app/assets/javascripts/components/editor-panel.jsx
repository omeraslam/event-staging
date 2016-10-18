var EditorPanel = React.createClass({
    // getInitialState: function() {
    //     return { current_selection: this.props.current_selection}
    // },
    // getDefaultProps: function() {
    //     return { current_selection: null}
    // },

    // componentDidMount: function() {
   
    // },

    // componentWillReceiveProps: function(nextProps) {
    //     //alert('current_item: '+ current_selection);
    
    //   this.setState({
    //     current_selection: nextProps.current_selection
    //   });
    // },

    render: function() {
   

        return (
            <div className="editor-panel">
            
                <h1>{this.props.current_selection.title}</h1>

                <form>
                    <div className="input-group">
                        <label> Ticket Name</label>
                        <input type="text" value={this.props.current_selection.title} />
                    </div>
                    <div className="input-group">
                        <label> Ticket Active</label>
                        <input type="text" value={this.props.current_selection.active} />
                    </div>
                    <div className="input-group">
                        <label>Quantity Available</label>
                        <input type="text" value={this.props.current_selection.ticket_limit} />
                    </div>
                    <div className="input-group">
                        <label>Buy Limit</label>
                        <input type="text" value={this.props.current_selection.buy_limit} />
                    </div>
                    <div className="input-group">
                        <label>Registration closes on</label>
                        <input type="text" value={this.props.current_selection.stop_date} />
                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        )
   } 
});

