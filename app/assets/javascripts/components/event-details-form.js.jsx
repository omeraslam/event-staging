var EventDetailsForm = React.createClass({
    getInitialState: function() {
        return {eventObj: this.props.eventObj}
    },
    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        obj = this.state.eventObj;
        obj[name] = e.target.value;
        this.setState({eventObj: obj});
    },
    componentWillReceiveProps: function(nextProps) {
        this.setState({eventObj: nextProps.eventObj})
    },
    render: function() {
        return (
            <div>
             <h1>{this.props.header}</h1>
                <p>{this.props.subheader}</p>

                <form>
                    <div className="input-group">
                      <label>Event Name</label>
                      <input name="name" type="text" value={this.state.eventObj["name"]} onChange={this.handleChange} />
                    </div>

                    <div className="input-group" id="datepairExample">
                        <label>Event Date</label>
                        <input name="date_start" className="date" type="text"  value={this.state.eventObj["date_start"]} onChange={this.handleChange} />
                    </div>

                    <div className="input-group">
                      <label>Location Address</label>
                      <input name="location" type="text"  value={this.state.eventObj["location"]} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        )
    } 
});