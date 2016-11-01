var CouponForm = React.createClass({
    getInitialState: function() {
        return { 
            current_selection: this.props.current_selection,
            event_slug: this.props.event_slug,
            event_id: this.props.event_id

        }
    },

    componentWillReceiveProps: function(nextProps) {
      nextProps.current_selection.stop_date = moment(nextProps.current_selection.stop_date).format('MM/DD/YYYY');
        
      this.setState({
        current_selection: nextProps.current_selection 
      });
    },

    componentDidMount: function() {
        var that = this;
        //format specific 
        this.setState({current_selection: this.state.current_selection})
        

   
    },

    handleUpdate: function(e) {
        e.preventDefault();
        //this.props.current_selection["stop_date"] = moment(this.props.current_selection["stop_date"], "YYYY-MM-DD");
        var method, uri;
        if (this.state.current_selection.id == null) {
            method = 'POST'
            uri = this.props.event_slug + '/coupons'
        } else {
            method = 'PUT'
            uri = '/coupons/' + this.state.current_selection.id
        }
        $.ajax({
            method: method,
            url: uri,
            data: {"coupon" : {
                      "promo_code" : this.state.current_selection.promo_code, 
                      "discount" : this.state.current_selection.discount, 
                      "is_fixed" : this.state.current_selection.is_fixed, 
                      "event_id" : this.state.current_selection.event_id, 
                      "is_active" : this.state.current_selection.is_active
            }},
            dataType: 'JSON',
            success: function() {
               this.props.onUpdateMessage('Coupon has been updated');
               
            }.bind(this)
        });

        

    },

    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        couponObj = this.state.current_selection;
        couponObj[name] = e.target.value;
        this.setState({current_selection: couponObj});
    },


    render: function() {
        return (
                <div>
                <h1>{this.props.current_selection.promo_code}</h1>

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





  


         
















       