var EventPaymentForm = React.createClass({
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



    handleUpdate: function(e) {

        e.preventDefault();
        var method, uri;
      
        method = 'PUT'
        uri = '/events/' + this.state.eventObj.id
        $.ajax({
            method: method,
            url: uri,
            data: {"event": this.state.eventObj},
            dataType: 'JSON',
            success: function() {
               //alert('success');
               //
               
               
            }.bind(this)
        });

        

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
                   

                    <h3 style={{marginBottom: '20px'}}>  Nice! So you're selling tickets? Let's figure out how you want to get paid.</h3>
                    <p>EventCreate partners with Stripe to process payments, so <u> <b> you get paid immediately</b></u>.</p> 
                    <p> Please head over to Stripe and add your payment details before you start selling tickets. You'll be redirected back to EventCreate automatically. It's easy and only takes a minute. </p>

                    <a className="stripe-connect-btn" href="https://connect.stripe.com/oauth/authorize?response_type=code&client_id=STRIPE_CLIENT_ID&scope=read_write"><img src="/assets/stripe/blue-on-light.png" /> </a>
        

                    <div className="input-group">
                      <label>Currency</label>
                       <select name="currency_type"  value={this.state.eventObj.currency_type} onChange={this.handleChange} >
                                <option value="USD">USD</option>
                                <option value="CAD">CAD</option>
                                <option value="AUD">AUD</option>
                              </select>

                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary" onClick={this.handleUpdate} >Update</button>
                    </div>
                </form>
            </div>
        )
    } 
});
