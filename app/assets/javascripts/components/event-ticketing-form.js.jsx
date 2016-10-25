var EventTicketingForm = React.createClass({
   getInitialState: function() {
        return { 
            ticketObj: this.props.ticketObj

        }
    },

    setItemDate: function(dateText) {
        ticketObj = this.state.ticketObj;
        ticketObj["stop_date"] = dateText;
        this.setState({ticketObj: ticketObj})

    },

    componentDidMount: function() {
        var that = this;
        //format specific 
        this.state.ticketObj.stop_date = moment(this.state.ticketObj.stop_date).format('MM/DD/YYYY');
        this.setState({ticketObj: this.state.ticketObj})
        $('#datepairExample .date').datepicker({
          onSelect: function(dateText) {

            that.setItemDate(dateText);
            $('.date').focusout();
          },
          'format': 'MM/DD/YYYY',
          'autoclose': true
        });


        var validator5 = $(".edit_ticket").validate({
          rules: {
            "title": {
              required: true
            },
            "price": {
              required: true
            },
            "ticket_limit": {
              required: true
            },
            "stop_date": {
              required: true
            },
            "buy_limit": {
              required: true
            },
          }, messages : {
            "title": 'Please enter a ticket name.',
            "price": 'Please enter a ticket price.',
            "ticket_limit": 'Please enter a ticket limit.',
            "buy_limit": 'Please enter a ticket limit.',
            "stop_date": 'Please enter an end date.'

          }
        });


   
    },

    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        obj = this.state.ticketObj;
        obj[name] = e.target.value;
        this.setState({ticketObj: obj});
    },


    render: function() {
        return (
            <div>
             <h1>{this.props.header}</h1>
                <p>{this.props.subheader}</p>

                <form className="edit_ticket">
                    <div className="input-group">
                      <label>Ticket Price</label>
                      <input name="price" type="text" value={this.state.ticketObj.price} onChange={this.handleChange} />
                    </div>

                    <div className="input-group" id="datepairExample">
                      <label>Registration closes on</label>
                      <input name="stop_date" type="text" className="date" value={this.state.ticketObj.stop_date} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                      <label>Event capacity</label>
                      <input name="ticket_limit" type="text" value={this.state.ticketObj.ticket_limit} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                      <label>Buy Limit</label>
                      <input name="buy_limit" type="text" value={this.state.ticketObj.buy_limit} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        )
    } 
});


