var EventPaymentForm = React.createClass({
    render: function() {
        return (
            <div>
             <h1>{this.props.header}</h1>
                <p>{this.props.subheader}</p>

                <form>
                   STRIPE ACCOUNT STUFF GOES HERE
                    <div className="input-group">
                      <label>Currency</label>
                      <input type="text" value={this.props.eventObj.currency_type}/>
                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        )
    } 
});