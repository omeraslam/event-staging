var EventUrlForm = React.createClass({
    getInitialState: function() {
        return { 
            eventObj: this.props.eventObj

        }
    },

    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        obj = this.state.eventObj;
        obj[name] = e.target.value;
        this.setState({eventObj: obj});
    },
    render: function() {
        return (
            <div>
             <h1>{this.props.header}</h1>
                <p>{this.props.subheader}</p>

                <form>
                    <div className="input-group">
                      <label>Your event URL</label>
                      <input name="slug" type="text" value={this.state.eventObj.slug} onChange={this.handleChange} />
                      <small>www.eventcreate.com/{this.state.eventObj.slug}</small>
                    </div>
                    <div className="input-group">
                      <label>Website Availability</label>
                      <select name="published"  value={this.state.eventObj.published} onChange={this.handleChange} >
                                <option value="true">Live</option>
                                <option value="false">Draft</option>
                              </select>
                      <small>You can prevent anyone from accessing your event website by changing the status to "hidden." Once hidden, only you will be able to view the website when logged in.</small> 
                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        )
    } 
});