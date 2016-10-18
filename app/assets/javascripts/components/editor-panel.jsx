var EditorPanel = React.createClass({
    getInitialState: function() {
        return { current_selection: this.props.current_selection}
    },
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
    // 
    handleUpdate: function(e) {
        alert('handle update');
        e.preventDefault();
        this.props.current_selection["stop_date"] = moment(this.props.current_selection["stop_date"], "MM/DD/YYYY");

        alert(moment(this.props.current_selection["stop_date"], "MM/DD/YYYY"));

        $.ajax({
            method: 'PUT',
            url: '/tickets/' + this.props.current_selection.id,
            data: {"ticket" : this.props.current_selection},
            dataType: 'JSON',
            success: function() {
                alert('success');
               // this.props.handleDeleteEvent(this.props.event)
            }.bind(this)
        });
    },

    handleChange: function(e) {
        this.setState({value: event.target.value})
    },
    render: function() {
        return (
            <div className="editor-panel">
            
                <h1>{this.props.current_selection.title}</h1>

                <form>
                    <div className="input-group">
                        <label> Ticket Name</label>
                        <input type="text" defaultValue={this.props.current_selection.title} />
                    </div>
                    <div className="input-group">
                        <label> Ticket Active</label>
                        <input type="text" defaultValue={this.props.current_selection.active} />
                    </div>
                    <div className="input-group">
                        <label>Quantity Available</label>
                        <input type="text" defaultValue={this.props.current_selection.ticket_limit} />
                    </div>
                    <div className="input-group">
                        <label>Buy Limit</label>
                        <input type="text" defaultValue={this.props.current_selection.buy_limit} />
                    </div>
                    <div className="input-group">
                        <label>Registration closes on</label>
                        <input type="text" defaultValue={this.props.current_selection.stop_date} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                        <button onClick={this.handleUpdate} className="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        )
   } 
});

