var CouponForm = React.createClass({
    getInitialState: function() {
        return { 
            current_selection: this.props.current_selection,
            event_slug: this.props.event_slug

        }
    },

    setItemDate: function(dateText) {
        ticketObj = this.state.current_selection;
        ticketObj["stop_date"] = dateText;
        console.log(ticketObj);
        this.setState({current_selection: ticketObj})

    },


    componentWillReceiveProps: function(nextProps) {
      nextProps.current_selection.stop_date = moment(nextProps.current_selection.stop_date).format('MM/DD/YYYY');
        
      this.setState({
        current_selection: nextProps.current_selection 
      });
    },

    componentDidMount: function() {
        alert('hello')
        var that = this;
        //format specific 
        this.state.current_selection.stop_date = moment(this.state.current_selection.stop_date).format('MM/DD/YYYY');
        this.setState({current_selection: this.state.current_selection})
        $('#datepairExample .date').datepicker({
          onSelect: function(dateText) {

            that.setItemDate(dateText);
            $('.date').focusout();
          },
          'format': 'MM/DD/YYYY',
          'autoclose': true
        });

   
    },

    handleUpdate: function(e) {

        e.preventDefault();
        //this.props.current_selection["stop_date"] = moment(this.props.current_selection["stop_date"], "YYYY-MM-DD");
        var method, uri;
        if (this.state.current_selection.id == null) {
            method = 'POST'
            uri = this.props.event_slug + '/tickets'
        } else {
            method = 'PUT'
            uri = '/tickets/' + this.state.current_selection.id
        }
        $.ajax({
            method: method,
            url: uri,
            data: {"ticket" : {
                     "title" : this.state.current_selection.title, 
                      "description" : this.state.current_selection.description, 
                      "price" : this.state.current_selection.price, 
                      "ticket_limit" : this.state.current_selection.ticket_limit, 
                      "buy_limit" : this.state.current_selection.buy_limit, 
                      "stop_date" : this.state.current_selection.stop_date,
                      "is_active" : this.state.current_selection.is_active
            }},
            dataType: 'JSON',
            success: function() {
               //alert('success');
               // this.props.handleDeleteEvent(this.props.event)
               
            }.bind(this)
        });

        

    },

    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        ticketObj = this.state.current_selection;
        ticketObj[name] = e.target.value;
        this.setState({current_selection: ticketObj});
    },


    render: function() {
        return (
                <div>
                <h1>{this.props.current_selection.title}</h1>

                    <form>
                        <div className="input-group">
                            <label>Coupon Active</label>
                             <select name="is_active"  value={this.state.current_selection.is_active} onChange={this.handleChange} >
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                              </select>
                        </div>

                        <div className="input-group">
                            <label>Offer Code</label>
                            <input name="promo_code" type="text" className="input-primary" id="event-url-input" placeholder="SAVE2016" value={this.state.current_selection.promo_code} onChange={this.handleChange}  />
                             <p>Enter an offer code (ie "Save2016") to advertise to your attendees</p>
                        </div>

                        <input type="hidden" name="event_id" value={this.state.current_selection.event_id} />



                        <div className="input-group">
                            <label>Discount</label>
                            <input name="discount" type="number" className="input-primary" id="event-url-input"  value={this.state.current_selection.discount} onChange={this.handleChange}/>
                            <p>Discount amount</p>
                        </div>

                        <div className="input-group">
                            <label>Percentage or Fixed</label>
                            <select name="is_fixed"  value={this.state.current_selection.is_fixed} onChange={this.handleChange} >
                                <option value="true">$</option>
                                <option value="false">%</option>
                              </select>

                        <p> Should the discount be applied as a percentage (ie 10%) or fixed amount ($10). </p>
                        </div>


                        <div className="input-group">
                            <button onClick={this.handleUpdate} className="btn btn-primary">Update</button>
                        </div>
                    </form>
                </div>


        )
    }

});





  


         
















       