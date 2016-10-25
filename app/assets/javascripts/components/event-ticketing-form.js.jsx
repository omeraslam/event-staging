var EventTicketingForm = React.createClass({
    render: function() {
        return (
            <div>
             <h1>{this.props.header}</h1>
                <p>{this.props.subheader}</p>

                <form>
                    <div className="input-group">
                      <label>Ticket Price</label>
                      <input type="text" value={this.props.ticketObj.price}/>
                    </div>

                    <div className="input-group">
                      <label>Registration closes on</label>
                      <input type="text" value={this.props.ticketObj.stop_date} />
                    </div>
                    <div className="input-group">
                      <label>Event capacity</label>
                      <input type="text" value={this.props.ticketObj.ticket_limit} />
                    </div>
                    <div className="input-group">
                      <label>Buy Limit</label>
                      <input type="text" value={this.props.ticketObj.buy_limit}/>
                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        )
    } 
});


