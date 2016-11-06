var EventSeoForm = React.createClass({
    render: function() {
        return (
            <div>
             <h1>{this.props.header}</h1>
                <p>{this.props.subheader}</p>

                <form>
                    <div className="input-group">
                      <label>Event Name</label>
                      <input type="text" />
                    </div>

                    <div className="input-group">
                      <label>Event Date</label>
                      <input type="text" />
                    </div>
                    <div className="input-group">
                      <label>Location Address</label>
                      <input type="text" />
                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        )
    }
});